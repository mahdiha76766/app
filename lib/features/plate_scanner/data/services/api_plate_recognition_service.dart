import '../../../../core/errors/not_implemented_exception.dart';
import '../../domain/entities/plate_recognition_result.dart';
import '../../domain/services/plate_recognition_service.dart';

/// اسکلت اتصال به API تشخیص پلاک — فعلاً NotImplemented.
class ApiPlateRecognitionService implements PlateRecognitionService {
  const ApiPlateRecognitionService({
    this.baseUrl,
    this.recognizePath = '/api/v1/plates/recognize',
  });

  /// آدرس پایه سرور؛ بعداً از تنظیمات خوانده می‌شود.
  final String? baseUrl;

  /// مسیر endpoint تشخیص پلاک.
  final String recognizePath;

  Uri? get recognizeEndpoint {
    if (baseUrl == null || baseUrl!.trim().isEmpty) {
      return null;
    }
    return Uri.parse(baseUrl!).resolve(recognizePath);
  }

  @override
  Future<PlateRecognitionResult> recognize(String imagePath) async {
    throw NotImplementedException(
      'تشخیص پلاک از طریق API هنوز پیاده‌سازی نشده است. '
      'endpoint پیشنهادی: ${recognizeEndpoint ?? '$baseUrl$recognizePath'} '
      '— فایل تصویر: $imagePath',
    );
  }
}
