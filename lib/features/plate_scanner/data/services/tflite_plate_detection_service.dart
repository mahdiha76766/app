import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../../domain/entities/plate_detection_result.dart';
import '../../domain/entities/plate_frame.dart';
import '../../domain/services/plate_detection_service.dart';
import '../ml/iran_plate_yolo_labels.dart';
import '../ml/plate_detector_output_parser.dart';
import '../ml/plate_image_utils.dart';
import '../ml/tflite_model_loader.dart';

/// detector پلاک با TFLite (YOLO letterbox + اصلاح orientation).
class TflitePlateDetectionService implements PlateDetectionService {
  TflitePlateDetectionService(this._loader);

  final TfliteModelLoader _loader;

  /// زاویه سنسور دوربین؛ برای راست‌کردن فریم زنده لازم است.
  int sensorOrientationDegrees = 0;

  @override
  Future<PlateDetectionResult?> detect(
    Uint8List imageBytes,
    int width,
    int height,
  ) async {
    if (!_loader.isDetectorLoaded) {
      return null;
    }

    final cfg = _loader.config.detector;
    var source = PlateImageUtils.fromRgbBytes(imageBytes, width, height);
    source = _upright(source, sensorOrientationDegrees);

    final interpreter = _loader.detector;
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;
    final inputH = inputShape.length > 1 ? inputShape[1] : cfg.inputHeight;
    final inputW = inputShape.length > 2 ? inputShape[2] : cfg.inputWidth;
    final inputC = inputShape.length > 3 ? inputShape[3] : 3;

    // برای سرعت: ورودی detector را کوچک‌تر نگه دار تا پردازش زنده روان‌تر شود.
    final detectSource = _maybeDownscale(source, maxSide: 416);

    final letterboxed = PlateImageUtils.letterbox(detectSource, inputW);
    final input = _buildInput(letterboxed.image, inputW, inputH, inputC);
    final output = _allocateOutput(outputShape);

    try {
      interpreter.run(input, output);
    } catch (error, stack) {
      debugPrint('detector run error: $error\n$stack');
      return null;
    }

    final flat = _flattenOutput(output, outputShape);
    final detections = PlateDetectorOutputParser.parseYoloLike(
      output: flat,
      shape: outputShape,
      confidenceThreshold: cfg.confidenceThreshold,
      iouThreshold: cfg.iouThreshold,
      inputWidth: inputW.toDouble(),
      inputHeight: inputH.toDouble(),
    );

    if (detections.isEmpty) {
      final peek = _peekMaxScore(flat, outputShape);
      debugPrint(
        'detector empty: maxScore=${peek.toStringAsFixed(3)} '
        'upright=${source.width}x${source.height} rot=$sensorOrientationDegrees',
      );
      return null;
    }

    final bestLetterbox = PlateDetectorOutputParser.pickBest(detections);
    if (bestLetterbox == null) {
      return null;
    }

    DetectedPlate mapBox(DetectedPlate box) {
      var mapped = PlateImageUtils.mapLetterboxBoxToOriginal(box, letterboxed);
      // اگر detectSource کوچک‌شده باشد، مختصات نسبت به همان است (= source).
      if (sensorOrientationDegrees != 0) {
        mapped = _mapBoxBackToRaw(
          mapped,
          width,
          height,
          sensorOrientationDegrees,
        );
      }
      return mapped;
    }

    final mappedAll = detections.map(mapBox).toList(growable: false);
    final best = mapBox(bestLetterbox);

    if (best.width < 0.04 || best.height < 0.04) {
      return null;
    }

    final assembled = PlateYoloCharacterAssembler.assemble(mappedAll);

    return PlateDetectionResult(
      bbox: best,
      confidence: best.confidence,
      isComplete: true,
      allDetections: mappedAll,
      assembledPlate: assembled,
    );
  }

  PlateImage _maybeDownscale(PlateImage source, {required int maxSide}) {
    final longest = source.width > source.height ? source.width : source.height;
    if (longest <= maxSide) {
      return source;
    }
    final scale = maxSide / longest;
    final w = (source.width * scale).round().clamp(1, maxSide);
    final h = (source.height * scale).round().clamp(1, maxSide);
    return PlateImageUtils.resize(source, w, h);
  }

  PlateImage _upright(PlateImage source, int sensorOrientation) {
    final angle = ((sensorOrientation % 360) + 360) % 360;
    if (angle == 0) {
      return source;
    }
    final image = PlateImageUtils.toImage(source);
    final rotated = img.copyRotate(image, angle: angle);
    return PlateImageUtils.fromImage(rotated);
  }

  /// تبدیل باکس نرمال upright → مختصات نرمال بافر خام CameraImage.
  DetectedPlate _mapBoxBackToRaw(
    DetectedPlate box,
    int rawWidth,
    int rawHeight,
    int sensorOrientation,
  ) {
    final angle = ((sensorOrientation % 360) + 360) % 360;
    if (angle == 0) {
      return box;
    }

    final left = box.left;
    final top = box.top;
    final right = box.right;
    final bottom = box.bottom;

    List<double> mapPoint(double x, double y) {
      switch (angle) {
        case 90:
          // upright = rotate raw 90 CW → inverse: rotate 270 CW
          return [y, 1.0 - x];
        case 180:
          return [1.0 - x, 1.0 - y];
        case 270:
          return [1.0 - y, x];
        default:
          return [x, y];
      }
    }

    final corners = [
      mapPoint(left, top),
      mapPoint(right, top),
      mapPoint(left, bottom),
      mapPoint(right, bottom),
    ];
    final xs = corners.map((p) => p[0]);
    final ys = corners.map((p) => p[1]);
    return DetectedPlate(
      left: xs.reduce((a, b) => a < b ? a : b).clamp(0.0, 1.0),
      top: ys.reduce((a, b) => a < b ? a : b).clamp(0.0, 1.0),
      right: xs.reduce((a, b) => a > b ? a : b).clamp(0.0, 1.0),
      bottom: ys.reduce((a, b) => a > b ? a : b).clamp(0.0, 1.0),
      confidence: box.confidence,
      classId: box.classId,
    );
  }

  double _peekMaxScore(List<double> output, List<int> shape) {
    if (shape.length != 3 || shape[1] < 5) {
      return output.isEmpty ? 0 : output.reduce((a, b) => a > b ? a : b);
    }
    final channels = shape[1];
    final count = shape[2];
    var best = 0.0;
    for (var i = 0; i < count; i++) {
      for (var c = 4; c < channels; c++) {
        final score = output[c * count + i];
        if (score > best) {
          best = score;
        }
      }
    }
    return best;
  }

  Object _allocateOutput(List<int> shape) {
    if (shape.length == 3) {
      return List.generate(
        shape[0],
        (_) => List.generate(
          shape[1],
          (_) => List<double>.filled(shape[2], 0),
        ),
      );
    }
    if (shape.length == 2) {
      return List.generate(
        shape[0],
        (_) => List<double>.filled(shape[1], 0),
      );
    }
    final size = shape.fold<int>(1, (a, b) => a * b);
    return List<double>.filled(size, 0);
  }

  List<double> _flattenOutput(Object output, List<int> shape) {
    final size = shape.fold<int>(1, (a, b) => a * b);
    final flat = List<double>.filled(size, 0);
    var index = 0;

    void walk(Object node) {
      if (node is List) {
        if (node.isEmpty) {
          return;
        }
        if (node.first is num) {
          for (final value in node) {
            flat[index++] = (value as num).toDouble();
          }
          return;
        }
        for (final child in node) {
          walk(child);
        }
      }
    }

    walk(output);
    return flat;
  }

  List<List<List<List<double>>>> _buildInput(
    PlateImage source,
    int width,
    int height,
    int channels,
  ) {
    final rgb = source.bytes;
    return List.generate(
      1,
      (_) => List.generate(height, (y) {
        return List.generate(width, (x) {
          final index = (y * width + x) * 3;
          if (channels == 1) {
            final gray =
                ((rgb[index] + rgb[index + 1] + rgb[index + 2]) / 3) / 255.0;
            return [gray];
          }
          return [
            rgb[index] / 255.0,
            rgb[index + 1] / 255.0,
            rgb[index + 2] / 255.0,
          ];
        });
      }),
    );
  }

  @override
  Future<void> dispose() async {}
}
