import 'dart:ui';

import '../../domain/entities/plate_frame.dart';
import '../../domain/services/plate_segmentation_service.dart';
import '../ml/iran_plate_models_config.dart';
import '../ml/plate_character_segment_layout.dart';
import '../ml/plate_image_utils.dart';
import '../../domain/entities/plate_segments.dart';

/// normalize و crop پلاک تشخیص‌داده‌شده.
class PlateNormalizationService {
  const PlateNormalizationService({this.config = PlateNormalizationConfig.defaults});

  final PlateNormalizationConfig config;

  /// crop پلاک از ROI و normalize به اندازه ثابت.
  PlateImage normalizeFromRoi(
    PlateImage roi,
    DetectedPlate bbox, {
    double? angle,
  }) {
    final cropped = PlateImageUtils.cropNormalized(
      roi,
      bbox.left,
      bbox.top,
      bbox.right,
      bbox.bottom,
    );
    return PlateImageUtils.resize(
      cropped,
      config.plateWidth,
      config.plateHeight,
    );
  }

  /// حذف نوار آبی و normalize (بعد از crop detector).
  PlateImage removeBlueStrip(PlateImage normalized) {
    final stripEnd = PlateCharacterSegmentLayout.blueStripRatio;
    return PlateImageUtils.cropNormalized(
      normalized,
      stripEnd,
      0,
      1,
      1,
    );
  }
}

/// تقسیم پلاک normalize شده به segmentهای کاراکتر.
class PlateSegmentationServiceImpl implements PlateSegmentationService {
  const PlateSegmentationServiceImpl({
    this.normalizer = const PlateNormalizationService(),
  });

  final PlateNormalizationService normalizer;

  @override
  Future<PlateSegments> segment(PlateImage normalizedPlate) async {
    final plate = normalizer.removeBlueStrip(normalizedPlate);
    final w = plate.width;
    final h = plate.height;

    PlateImage crop(Rect rect) {
      return PlateImageUtils.cropRect(plate, RectLike(
        left: rect.left,
        top: rect.top,
        right: rect.right,
        bottom: rect.bottom,
      ));
    }

    return PlateSegments(
      firstDigit1: crop(PlateCharacterSegmentLayout.firstDigit1Rect(w, h)),
      firstDigit2: crop(PlateCharacterSegmentLayout.firstDigit2Rect(w, h)),
      letter: crop(PlateCharacterSegmentLayout.letterRect(w, h)),
      middleDigit1: crop(PlateCharacterSegmentLayout.middleDigit1Rect(w, h)),
      middleDigit2: crop(PlateCharacterSegmentLayout.middleDigit2Rect(w, h)),
      middleDigit3: crop(PlateCharacterSegmentLayout.middleDigit3Rect(w, h)),
      cityDigit1: crop(PlateCharacterSegmentLayout.cityDigit1Rect(w, h)),
      cityDigit2: crop(PlateCharacterSegmentLayout.cityDigit2Rect(w, h)),
      normalizedPlate: plate,
    );
  }
}
