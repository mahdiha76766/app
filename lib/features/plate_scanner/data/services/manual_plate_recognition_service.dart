import '../../domain/entities/plate_recognition_result.dart';
import '../../domain/services/plate_recognition_service.dart';

/// بدون OCR — کاربر در صفحه تأیید پلاک را کامل می‌کند.
class ManualPlateRecognitionService implements PlateRecognitionService {
  const ManualPlateRecognitionService();

  @override
  Future<PlateRecognitionResult> recognize(String imagePath) async {
    return PlateRecognitionResult(
      rawText: '',
      normalizedPlate: '',
      firstTwoDigits: '',
      middleThreeDigits: '',
      letter: '',
      cityCode: '',
      confidence: 0,
      imagePath: imagePath,
    );
  }
}
