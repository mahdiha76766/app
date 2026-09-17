import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_frame_quality.dart';
import '../../domain/services/plate_quality_service.dart';

/// ارزیابی کیفیت بدون محاسبات سنگین (برای detector-only زنده).
class PassthroughPlateQualityService implements PlateQualityService {
  const PassthroughPlateQualityService();

  @override
  PlateFrameQuality evaluate(
    PlateImage roiImage, {
    DetectedPlate? detectedPlate,
  }) {
    return PlateFrameQuality(
      brightness: 128,
      blurScore: 200,
      glareScore: 0,
      plateSizeRatio: detectedPlate?.width ?? 1,
      horizontalAngle: 0,
      isAcceptable: true,
    );
  }
}
