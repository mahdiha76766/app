import '../entities/plate_frame.dart';
import '../entities/plate_frame_quality.dart';

/// ارزیابی کیفیت ROI قبل از OCR.
abstract interface class PlateQualityService {
  PlateFrameQuality evaluate(
    PlateImage roiImage, {
    DetectedPlate? detectedPlate,
  });
}
