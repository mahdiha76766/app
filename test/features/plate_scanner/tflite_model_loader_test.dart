import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/errors/model_not_found_exception.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/iran_plate_models_config.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/tflite_model_loader.dart';

const _missingConfig = IranPlateModelsConfig(
  mode: 'auto',
  detector: DetectorModelConfig(
    path: 'assets/models/missing_detector.tflite',
    inputWidth: 320,
    inputHeight: 320,
    confidenceThreshold: 0.55,
    iouThreshold: 0.45,
  ),
  recognizer: RecognizerModelConfig(
    path: 'assets/models/missing_recognizer.tflite',
    inputWidth: 160,
    inputHeight: 48,
    confidenceThreshold: 0.65,
  ),
  digitClassifier: ClassifierModelConfig(
    path: 'assets/models/missing_digit.tflite',
    inputWidth: 32,
    inputHeight: 48,
    classes: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    confidenceThreshold: 0.7,
  ),
  letterClassifier: ClassifierModelConfig(
    path: 'assets/models/missing_letter.tflite',
    inputWidth: 40,
    inputHeight: 48,
    classes: ['ب', 'ج', 'د'],
    confidenceThreshold: 0.65,
  ),
  normalization: PlateNormalizationConfig(plateWidth: 280, plateHeight: 64),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TfliteModelLoader', () {
    test('tryLoadAll بدون فایل مدل false برمی‌گرداند', () async {
      final loader = TfliteModelLoader(config: _missingConfig);

      final loaded = await loader.tryLoadAll();

      expect(loaded, isFalse);
      expect(loader.isFullyLoaded, isFalse);
    });

    test('loadAll بدون فایل مدل خطا می‌دهد', () async {
      final loader = TfliteModelLoader(config: _missingConfig);

      await expectLater(
        loader.loadAll(),
        throwsA(isA<ModelNotFoundException>()),
      );
    });

    test('config از JSON asset parse می‌شود', () async {
      final config = await IranPlateModelsConfig.loadFromAssets();
      expect(config.mode, 'auto');
      expect(config.detector.inputWidth, 320);
      expect(config.recognizer.path, contains('recognizer'));
      expect(config.digitClassifier.classes.length, 10);
      expect(config.letterClassifier.classes.length, 13);
      expect(config.normalization.plateWidth, 280);
    });
  });
}
