import '../../domain/entities/plate_model_status.dart';
import '../../domain/services/plate_model_availability_service.dart';
import '../ml/tflite_model_loader.dart';

/// بررسی وجود مدل‌های TFLite و انتخاب حالت.
class PlateModelAvailabilityServiceImpl implements PlateModelAvailabilityService {
  PlateModelAvailabilityServiceImpl(this._loader);

  final TfliteModelLoader _loader;

  @override
  Future<PlateModelStatus> check() async {
    try {
      await _loader.loadConfig();
    } catch (_) {
      return const PlateModelStatus.none();
    }

    final cfg = _loader.config;
    final detector = await _loader.assetExists(cfg.detector.path);
    final recognizer = await _loader.assetExists(cfg.recognizer.path);
    final digit = await _loader.assetExists(cfg.digitClassifier.path);
    final letter = await _loader.assetExists(cfg.letterClassifier.path);

    if (detector && recognizer) {
      return const PlateModelStatus(
        availability: PlateModelAvailability.fullTflite,
        mode: PlateModelMode.detectorRecognizer,
        detectorPresent: true,
        recognizerPresent: true,
        digitClassifierPresent: false,
        letterClassifierPresent: false,
      );
    }

    if (detector && digit && letter) {
      return PlateModelStatus(
        availability: PlateModelAvailability.fullTflite,
        mode: PlateModelMode.detectorClassifiers,
        detectorPresent: true,
        recognizerPresent: false,
        digitClassifierPresent: digit,
        letterClassifierPresent: letter,
      );
    }

    if (detector) {
      return PlateModelStatus(
        availability: PlateModelAvailability.detectorOnly,
        mode: PlateModelMode.detectorOnly,
        detectorPresent: true,
        recognizerPresent: recognizer,
        digitClassifierPresent: digit,
        letterClassifierPresent: letter,
        message: 'اسکن آفلاین هنوز نصب نشده',
      );
    }

    return const PlateModelStatus.none();
  }
}
