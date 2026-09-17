import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_segments.dart';
import '../../domain/services/plate_character_classifier.dart';
import '../ml/plate_image_utils.dart';
import '../ml/tflite_model_loader.dart';

/// classifier عدد و حرف با TFLite.
class TflitePlateCharacterClassifier implements PlateCharacterClassifier {
  TflitePlateCharacterClassifier(this._loader);

  final TfliteModelLoader _loader;

  @override
  Future<DigitPrediction> predictDigit(PlateImage segment) async {
    if (!_loader.isDigitClassifierLoaded) {
      return const DigitPrediction(digit: '', confidence: 0);
    }

    final cfg = _loader.config.digitClassifier;
    final resized = PlateImageUtils.resize(
      segment,
      cfg.inputWidth,
      cfg.inputHeight,
    );

    final output = _runClassifier(
      interpreter: _loader.digitClassifier,
      segment: resized,
      classCount: cfg.classes.length,
    );

    final bestIndex = _argMax(output);
    final confidence = output[bestIndex];
    if (confidence < cfg.confidenceThreshold) {
      return DigitPrediction(digit: '', confidence: confidence);
    }

    return DigitPrediction(
      digit: cfg.classes[bestIndex],
      confidence: confidence,
    );
  }

  @override
  Future<LetterPrediction> predictLetter(PlateImage segment) async {
    if (!_loader.isLetterClassifierLoaded) {
      return const LetterPrediction(letter: '', confidence: 0);
    }
    final cfg = _loader.config.letterClassifier;
    final resized = PlateImageUtils.resize(
      segment,
      cfg.inputWidth,
      cfg.inputHeight,
    );

    final output = _runClassifier(
      interpreter: _loader.letterClassifier,
      segment: resized,
      classCount: cfg.classes.length,
    );

    final bestIndex = _argMax(output);
    final confidence = output[bestIndex];
    if (confidence < cfg.confidenceThreshold) {
      return LetterPrediction(letter: '', confidence: confidence);
    }

    return LetterPrediction(
      letter: cfg.classes[bestIndex],
      confidence: confidence,
    );
  }

  List<double> _runClassifier({
    required dynamic interpreter,
    required PlateImage segment,
    required int classCount,
  }) {
    final inputShape = interpreter.getInputTensor(0).shape;
    final inputH = inputShape.length > 1 ? inputShape[1] : segment.height;
    final inputW = inputShape.length > 2 ? inputShape[2] : segment.width;
    final inputC = inputShape.length > 3 ? inputShape[3] : 1;

    final input = _buildGrayscaleInput(segment, inputW, inputH, inputC);
    final output = List<double>.filled(classCount, 0);
    interpreter.run(input, output);

    final maxVal = output.reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0) {
      return output;
    }
    final sum = output.fold<double>(0, (a, b) => a + b);
    if (sum <= 0) {
      return output;
    }
    return output.map((v) => v / sum).toList();
  }

  List<List<List<List<double>>>> _buildGrayscaleInput(
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
          final sx = (x * source.width / width).round().clamp(0, source.width - 1);
          final sy = (y * source.height / height).round().clamp(0, source.height - 1);
          final index = (sy * source.width + sx) * 3;
          final gray =
              ((rgb[index] + rgb[index + 1] + rgb[index + 2]) / 3) / 255.0;
          if (channels == 1) {
            return [gray];
          }
          return [gray, gray, gray];
        });
      }),
    );
  }

  int _argMax(List<double> values) {
    var best = 0;
    for (var i = 1; i < values.length; i++) {
      if (values[i] > values[best]) {
        best = i;
      }
    }
    return best;
  }

  @override
  Future<void> dispose() async {}
}
