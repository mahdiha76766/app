import '../entities/plate_model_status.dart';

/// بررسی وجود مدل‌های TFLite.
abstract interface class PlateModelAvailabilityService {
  Future<PlateModelStatus> check();
}
