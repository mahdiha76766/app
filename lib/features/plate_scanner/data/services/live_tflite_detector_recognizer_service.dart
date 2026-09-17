import 'dart:typed_data';

import '../../domain/config/iranian_plate_config.dart';
import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_recognition_candidate.dart';
import '../../domain/services/live_plate_recognition_service.dart';
import '../../domain/services/plate_detection_service.dart';
import '../ml/plate_image_utils.dart';
import '../ml/tflite_model_loader.dart';
import 'plate_ocr_text_parser.dart';
import 'plate_segmentation_service_impl.dart';

/// تشخیص با detector + recognizer (CRNN / sequence).
class LiveTfliteDetectorRecognizerService implements LivePlateRecognitionService {
  LiveTfliteDetectorRecognizerService({
    required this.detector,
    required this.loader,
    this.normalizer = const PlateNormalizationService(),
  });

  final PlateDetectionService detector;
  final TfliteModelLoader loader;
  final PlateNormalizationService normalizer;

  @override
  Future<PlateRecognitionCandidate?> recognize(
    Uint8List roiBytes,
    int width,
    int height,
  ) async {
    final started = DateTime.now();
    final roi = PlateImageUtils.fromRgbBytes(roiBytes, width, height);

    final detection = await detector.detect(roiBytes, width, height);
    if (detection == null) {
      return null;
    }

    final normalized = normalizer.normalizeFromRoi(roi, detection.bbox);
    final cfg = loader.config.recognizer;
    final resized = PlateImageUtils.resize(
      normalized,
      cfg.inputWidth,
      cfg.inputHeight,
    );

    final interpreter = loader.recognizer;
    final inputShape = interpreter.getInputTensor(0).shape;
    final inputH = inputShape.length > 1 ? inputShape[1] : cfg.inputHeight;
    final inputW = inputShape.length > 2 ? inputShape[2] : cfg.inputWidth;
    final inputC = inputShape.length > 3 ? inputShape[3] : 1;

    final input = _buildInput(resized, inputW, inputH, inputC);
    final outputShape = interpreter.getOutputTensor(0).shape;
    final outputSize = outputShape.reduce((a, b) => a * b);
    final output = List<double>.filled(outputSize, 0);
    interpreter.run(input, output);

    final decoded = _decodeSequence(output, outputShape);
    if (decoded == null) {
      return null;
    }

    final parts = PlateOcrTextParser.parseFreeform(decoded.text);
    if (parts == null ||
        !IranianPlateConfig.isValidParts(
          firstTwoDigits: parts.firstTwoDigits,
          letter: parts.letter,
          middleThreeDigits: parts.middleThreeDigits,
          cityCode: parts.cityCode,
        )) {
      return null;
    }

    if (decoded.confidence < cfg.confidenceThreshold) {
      return null;
    }

    return PlateRecognitionCandidate(
      plate: parts,
      confidence: decoded.confidence.clamp(0, 1),
      timestamp: DateTime.now(),
      detectorConfidence: detection.confidence,
      digitConfidences: const [],
      letterConfidence: decoded.confidence,
      boundingBox: detection.bbox,
      processingMs: DateTime.now().difference(started).inMilliseconds,
    );
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
          final sx =
              (x * source.width / width).round().clamp(0, source.width - 1);
          final sy =
              (y * source.height / height).round().clamp(0, source.height - 1);
          final index = (sy * source.width + sx) * 3;
          final gray =
              ((rgb[index] + rgb[index + 1] + rgb[index + 2]) / 3) / 255.0;
          if (channels == 1) {
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

  /// خروجی رایج CRNN: [1, T, C] یا [1, C] یا flat logits.
  _DecodedSequence? _decodeSequence(List<double> output, List<int> shape) {
    if (shape.length == 3) {
      final time = shape[1];
      final classes = shape[2];
      final chars = <String>[];
      var confidenceSum = 0.0;
      var lastIndex = -1;

      for (var t = 0; t < time; t++) {
        var best = 0;
        var bestScore = output[t * classes];
        for (var c = 1; c < classes; c++) {
          final score = output[t * classes + c];
          if (score > bestScore) {
            bestScore = score;
            best = c;
          }
        }
        // blank / CTC index 0 را رد کن
        if (best == 0 || best == lastIndex) {
          continue;
        }
        lastIndex = best;
        final mapped = _indexToChar(best);
        if (mapped != null) {
          chars.add(mapped);
          confidenceSum += bestScore;
        }
      }

      if (chars.isEmpty) {
        return null;
      }
      return _DecodedSequence(
        text: chars.join(),
        confidence: confidenceSum / chars.length,
      );
    }

    // fallback: argmax روی خروجی تخت
    var best = 0;
    for (var i = 1; i < output.length; i++) {
      if (output[i] > output[best]) {
        best = i;
      }
    }
    final mapped = _indexToChar(best);
    if (mapped == null) {
      return null;
    }
    return _DecodedSequence(text: mapped, confidence: output[best]);
  }

  String? _indexToChar(int index) {
    const digits = '0123456789';
    const letters = 'بجدسصطقلمونهی';
    if (index >= 1 && index <= 10) {
      return digits[index - 1];
    }
    if (index >= 11 && index <= 11 + letters.length - 1) {
      return letters[index - 11];
    }
    return null;
  }

  @override
  Future<void> dispose() async {
    await detector.dispose();
  }
}

class _DecodedSequence {
  const _DecodedSequence({
    required this.text,
    required this.confidence,
  });

  final String text;
  final double confidence;
}
