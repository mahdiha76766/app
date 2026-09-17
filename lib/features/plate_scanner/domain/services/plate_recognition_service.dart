import '../entities/plate_recognition_result.dart';

/// سرویس قابل تعویض برای تشخیص پلاک از تصویر.
abstract interface class PlateRecognitionService {
  Future<PlateRecognitionResult> recognize(String imagePath);
}
