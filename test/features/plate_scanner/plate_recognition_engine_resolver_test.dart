import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/iran_plate_models_config.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/tflite_model_loader.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/plate_model_availability_service_impl.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/plate_recognition_engine_resolver.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_model_status.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/services/plate_recognition_engine.dart';
import 'package:path/path.dart' as p;

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
    classes: ['ب'],
    confidenceThreshold: 0.65,
  ),
  normalization: PlateNormalizationConfig(plateWidth: 280, plateHeight: 64),
);

const _detectorRecognizerConfig = IranPlateModelsConfig(
  mode: 'auto',
  detector: DetectorModelConfig(
    path: 'assets/models/fake_detector.tflite',
    inputWidth: 320,
    inputHeight: 320,
    confidenceThreshold: 0.55,
    iouThreshold: 0.45,
  ),
  recognizer: RecognizerModelConfig(
    path: 'assets/models/fake_recognizer.tflite',
    inputWidth: 160,
    inputHeight: 48,
    confidenceThreshold: 0.65,
  ),
  digitClassifier: ClassifierModelConfig(
    path: 'assets/models/missing_digit.tflite',
    inputWidth: 32,
    inputHeight: 48,
    classes: ['0'],
    confidenceThreshold: 0.7,
  ),
  letterClassifier: ClassifierModelConfig(
    path: 'assets/models/missing_letter.tflite',
    inputWidth: 40,
    inputHeight: 48,
    classes: ['ب'],
    confidenceThreshold: 0.65,
  ),
  normalization: PlateNormalizationConfig(plateWidth: 280, plateHeight: 64),
);

const _detectorClassifiersConfig = IranPlateModelsConfig(
  mode: 'auto',
  detector: DetectorModelConfig(
    path: 'assets/models/fake_detector.tflite',
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
    path: 'assets/models/fake_digit.tflite',
    inputWidth: 32,
    inputHeight: 48,
    classes: ['0'],
    confidenceThreshold: 0.7,
  ),
  letterClassifier: ClassifierModelConfig(
    path: 'assets/models/fake_letter.tflite',
    inputWidth: 40,
    inputHeight: 48,
    classes: ['ب'],
    confidenceThreshold: 0.65,
  ),
  normalization: PlateNormalizationConfig(plateWidth: 280, plateHeight: 64),
);

class _FakeAssetLoader extends TfliteModelLoader {
  _FakeAssetLoader({
    required IranPlateModelsConfig config,
    required this.presentAssets,
  }) : super(config: config);

  final Set<String> presentAssets;

  @override
  Future<bool> assetExists(String path) async => presentAssets.contains(path);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlateModelAvailabilityService', () {
    test('بدون مدل، Manual fallback', () async {
      final loader = TfliteModelLoader(config: _missingConfig);
      final service = PlateModelAvailabilityServiceImpl(loader);

      final status = await service.check();

      expect(status.availability, PlateModelAvailability.none);
      expect(status.mode, PlateModelMode.none);
      expect(status.canAutoScan, isFalse);
      expect(status.userTitle, contains('اسکن آفلاین'));
      expect(status.debugEngineLabel, 'Manual fallback');
    });

    test('detector + recognizer => detectorRecognizer', () async {
      final loader = _FakeAssetLoader(
        config: _detectorRecognizerConfig,
        presentAssets: {
          _detectorRecognizerConfig.detector.path,
          _detectorRecognizerConfig.recognizer.path,
        },
      );
      final status = await PlateModelAvailabilityServiceImpl(loader).check();

      expect(status.availability, PlateModelAvailability.fullTflite);
      expect(status.mode, PlateModelMode.detectorRecognizer);
      expect(status.canAutoScan, isTrue);
    });

    test('detector + digit/letter => detectorClassifiers', () async {
      final loader = _FakeAssetLoader(
        config: _detectorClassifiersConfig,
        presentAssets: {
          _detectorClassifiersConfig.detector.path,
          _detectorClassifiersConfig.digitClassifier.path,
          _detectorClassifiersConfig.letterClassifier.path,
        },
      );
      final status = await PlateModelAvailabilityServiceImpl(loader).check();

      expect(status.availability, PlateModelAvailability.fullTflite);
      expect(status.mode, PlateModelMode.detectorClassifiers);
      expect(status.canAutoScan, isTrue);
    });

    test('فقط detector => detectorOnly فعال', () async {
      final loader = _FakeAssetLoader(
        config: _detectorClassifiersConfig,
        presentAssets: {_detectorClassifiersConfig.detector.path},
      );
      final status = await PlateModelAvailabilityServiceImpl(loader).check();

      expect(status.availability, PlateModelAvailability.detectorOnly);
      expect(status.mode, PlateModelMode.detectorOnly);
      expect(status.canDetectOnly, isTrue);
      expect(status.userMessage, isNot(contains('اسکن آفلاین هنوز نصب نشده')));
      expect(status.debugEngineLabel, 'TFLite detector-only');
    });
  });

  group('PlateRecognitionEngineResolver', () {
    test('بدون TFLite، live scan به manual می‌رود نه Tesseract', () async {
      final loader = TfliteModelLoader(config: _missingConfig);
      final resolver = PlateRecognitionEngineResolver(modelLoader: loader);

      final resolved = await resolver.resolveForLiveScan();

      expect(resolved.kind, ActivePlateEngineKind.manual);
      expect(resolved.pipeline, isNull);
      expect(resolved.statusMessage, contains('اسکن آفلاین'));
      expect(resolved.engineName, contains('Manual'));
      expect(resolved.frameIntervalMs, 200);
    });

    test('resolveForStillImage بدون crash', () async {
      final loader = TfliteModelLoader(config: _missingConfig);
      final resolver = PlateRecognitionEngineResolver(modelLoader: loader);
      final engine = await resolver.resolveForStillImage();

      expect(engine.name, isNotEmpty);
    });
  });

  group('sample capture directory', () {
    test('plate_captures ساخته می‌شود قبل از نوشتن sample', () async {
      final temp = await Directory.systemTemp.createTemp('nedicar_sample_');
      final capturesDir = Directory(p.join(temp.path, 'plate_captures'));
      expect(await capturesDir.exists(), isFalse);

      if (!await capturesDir.exists()) {
        await capturesDir.create(recursive: true);
      }
      final sampleFile = File(p.join(capturesDir.path, 'sample_pelak.jpg'));
      await sampleFile.writeAsBytes([1, 2, 3, 4]);

      expect(await sampleFile.exists(), isTrue);
      await temp.delete(recursive: true);
    });

    test('assets/branding/pelak.jpg قابل خواندن است', () async {
      final data = await rootBundle.load('assets/branding/pelak.jpg');
      expect(data.lengthInBytes, greaterThan(100));
    });
  });
}
