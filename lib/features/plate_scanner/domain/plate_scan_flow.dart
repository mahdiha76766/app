import '../domain/entities/plate_recognition_result.dart';
import '../domain/services/plate_recognition_service.dart';

/// هماهنگی گرفتن عکس و تشخیص پلاک — قابل تست بدون UI دوربین.
class PlateScanFlow {
  const PlateScanFlow(this._recognitionService);

  final PlateRecognitionService _recognitionService;

  /// عکس ذخیره‌شده را با سرویس فعال پردازش می‌کند.
  Future<PlateRecognitionResult> processCapturedImage(String imagePath) {
    return _recognitionService.recognize(imagePath);
  }
}
