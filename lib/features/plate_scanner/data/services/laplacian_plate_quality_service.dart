import 'dart:typed_data';

import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_frame_quality.dart';
import '../../domain/services/plate_quality_service.dart';
import '../ml/camera_image_converter.dart';

/// ارزیابی سبک ROI برای نمایش hint؛ مانع اجرای OCR نمی‌شود.
class LaplacianPlateQualityService implements PlateQualityService {
  const LaplacianPlateQualityService({
    this.minBlurScore = 80,
    this.minBrightness = 20,
    this.maxBrightness = 245,
    this.maxGlareRatio = 1,
  });

  final double minBlurScore;
  final double minBrightness;
  final double maxBrightness;
  final double maxGlareRatio;
  @override
  PlateFrameQuality evaluate(
    PlateImage roiImage, {
    DetectedPlate? detectedPlate,
  }) {
    final gray = CameraImageConverter.toGrayscale(roiImage);
    final brightness = _mean(gray);
    final blurScore = _laplacianVariance(gray, roiImage.width, roiImage.height);
    final glareScore = _glareRatio(gray);
    final rejection = blurScore < minBlurScore ? 'گوشی را ثابت نگه دارید' : null;

    return PlateFrameQuality(
      brightness: brightness,
      blurScore: blurScore,
      glareScore: glareScore,
      plateSizeRatio: detectedPlate?.width ?? 1,
      horizontalAngle: 0,
      isAcceptable: true,
      rejectionReason: rejection,
    );
  }

  double _mean(Uint8List gray) {
    if (gray.isEmpty) {
      return 0;
    }
    var sum = 0;
    for (final value in gray) {
      sum += value;
    }
    return sum / gray.length;
  }

  double _glareRatio(Uint8List gray) {
    if (gray.isEmpty) {
      return 0;
    }
    var bright = 0;
    for (final value in gray) {
      if (value >= 245) {
        bright++;
      }
    }
    return bright / gray.length;
  }

  double _laplacianVariance(Uint8List gray, int width, int height) {
    if (width < 3 || height < 3) {
      return 0;
    }

    final values = <double>[];
    for (var y = 1; y < height - 1; y++) {
      for (var x = 1; x < width - 1; x++) {
        final center = gray[y * width + x];
        final lap = -4 * center +
            gray[(y - 1) * width + x] +
            gray[(y + 1) * width + x] +
            gray[y * width + (x - 1)] +
            gray[y * width + (x + 1)];
        values.add(lap.toDouble());
      }
    }
    if (values.isEmpty) {
      return 0;
    }
    final mean = values.reduce((a, b) => a + b) / values.length;
    var variance = 0.0;
    for (final value in values) {
      final diff = value - mean;
      variance += diff * diff;
    }
    return variance / values.length;
  }
}
