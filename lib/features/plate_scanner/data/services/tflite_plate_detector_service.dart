import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../domain/entities/plate_frame.dart';
import '../../domain/services/plate_detector_service.dart';
import '../ml/tflite_model_loader.dart';

/// تشخیص bounding box پلاک با مدل TFLite اختصاصی.
class TflitePlateDetectorService implements PlateDetectorService {
  TflitePlateDetectorService(this._loader);

  final TfliteModelLoader _loader;

  @override
  Future<List<DetectedPlate>> detect(PlateImage roiImage) async {
    final interpreter = _loader.detector;
    final inputShape = interpreter.getInputTensor(0).shape;
    final inputH = inputShape[1];
    final inputW = inputShape[2];
    final inputC = inputShape.length > 3 ? inputShape[3] : 1;

    final resized = _resizeRgb(roiImage, inputW, inputH);
    final input = _buildInput(resized, inputW, inputH, inputC);

    final outputShape = interpreter.getOutputTensor(0).shape;
    final outputSize = outputShape.reduce((a, b) => a * b);
    final output = List<double>.filled(outputSize, 0);

    interpreter.run(input, output);

    return _parseDetections(output, outputShape);
  }

  List<List<List<List<double>>>> _buildInput(
    Uint8List rgb,
    int width,
    int height,
    int channels,
  ) {
    final input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(width, (x) {
          final index = (y * width + x) * 3;
          if (channels == 1) {
            final gray = ((rgb[index] + rgb[index + 1] + rgb[index + 2]) / 3) /
                255.0;
            return [gray];
          }
          return [
            rgb[index] / 255.0,
            rgb[index + 1] / 255.0,
            rgb[index + 2] / 255.0,
          ];
        }),
      ),
    );
    return input;
  }

  Uint8List _resizeRgb(PlateImage source, int width, int height) {
    final image = img.Image.fromBytes(
      width: source.width,
      height: source.height,
      bytes: Uint8List.fromList(source.bytes).buffer,
      numChannels: 3,
      order: img.ChannelOrder.rgb,
    );
    final resized = img.copyResize(image, width: width, height: height);
    return resized.getBytes(order: img.ChannelOrder.rgb);
  }

  List<DetectedPlate> _parseDetections(
    List<double> output,
    List<int> shape,
  ) {
    // فرمت مورد انتظار: [1, N, 6] => cx,cy,w,h,conf,class
    if (shape.length == 3 && shape[2] >= 5) {
      final count = shape[1];
      final stride = shape[2];
      final results = <DetectedPlate>[];
      for (var i = 0; i < count; i++) {
        final base = i * stride;
        final confidence = output[base + 4];
        if (confidence < 0.4) {
          continue;
        }
        final cx = output[base];
        final cy = output[base + 1];
        final w = output[base + 2];
        final h = output[base + 3];
        results.add(
          DetectedPlate(
            left: (cx - w / 2).clamp(0, 1),
            top: (cy - h / 2).clamp(0, 1),
            right: (cx + w / 2).clamp(0, 1),
            bottom: (cy + h / 2).clamp(0, 1),
            confidence: confidence.clamp(0, 1),
          ),
        );
      }
      results.sort((a, b) => b.confidence.compareTo(a.confidence));
      return results;
    }

    // اگر خروجی مدل متفاوت باشد، کل ROI را پلاک فرض می‌کنیم.
    return const [
      DetectedPlate(
        left: 0.05,
        top: 0.15,
        right: 0.95,
        bottom: 0.85,
        confidence: 0.5,
      ),
    ];
  }

  @override
  Future<void> dispose() async {}
}
