import '../../../../core/formatters/iranian_plate_normalizer.dart';
import '../../domain/entities/plate_recognition_result.dart';
import '../../domain/services/plate_recognition_service.dart';

/// سرویس نمونه برای توسعه و تست.
class MockPlateRecognitionService implements PlateRecognitionService {
  const MockPlateRecognitionService({
    this.firstTwoDigits = '45',
    this.middleThreeDigits = '123',
    this.letter = 'ب',
    this.cityCode = '11',
    this.confidence = 0.92,
  });

  final String firstTwoDigits;
  final String middleThreeDigits;
  final String letter;
  final String cityCode;
  final double confidence;

  @override
  Future<PlateRecognitionResult> recognize(String imagePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));

    final normalized = IranianPlateNormalizer.normalizeParts(
      firstTwoDigits: firstTwoDigits,
      middleThreeDigits: middleThreeDigits,
      letter: letter,
      cityCode: cityCode,
    );
    final display = IranianPlateNormalizer.formatDisplayParts(
      firstTwoDigits: firstTwoDigits,
      middleThreeDigits: middleThreeDigits,
      letter: letter,
      cityCode: cityCode,
    );

    return PlateRecognitionResult(
      rawText: display,
      normalizedPlate: normalized,
      firstTwoDigits: firstTwoDigits,
      middleThreeDigits: middleThreeDigits,
      letter: letter,
      cityCode: cityCode,
      confidence: confidence,
      imagePath: imagePath,
    );
  }
}
