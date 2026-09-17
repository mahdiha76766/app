import '../../domain/entities/plate_frame.dart';
import '../../domain/services/plate_detector_service.dart';

/// تشخیص‌دهنده بدون مدل — کل ROI را به‌عنوان پلاک برمی‌گرداند.
class FullRoiPlateDetectorService implements PlateDetectorService {
  const FullRoiPlateDetectorService();

  @override
  Future<List<DetectedPlate>> detect(PlateImage roiImage) async {
    if (roiImage.width <= 0 || roiImage.height <= 0) {
      return const [];
    }
    return const [
      DetectedPlate(
        left: 0.02,
        top: 0.02,
        right: 0.98,
        bottom: 0.98,
        confidence: 1.0,
      ),
    ];
  }

  @override
  Future<void> dispose() async {}
}
