/// فریم خام دوربین برای پردازش تشخیص پلاک.
class PlateFrame {
  const PlateFrame({
    required this.planes,
    required this.width,
    required this.height,
    required this.format,
    required this.rotationDegrees,
    this.bytesPerRow,
    this.bytesPerRowUV,
  });

  /// بافرهای خام (YUV420: [Y, U, V] یا BGRA تک‌plane).
  final List<List<int>> planes;

  final int width;
  final int height;

  /// 0 = yuv420, 1 = bgra8888
  final int format;

  final int rotationDegrees;
  final int? bytesPerRow;
  final int? bytesPerRowUV;
}

/// تصویر پردازش‌شده (معمولاً ROI یا crop پلاک).
class PlateImage {
  const PlateImage({
    required this.bytes,
    required this.width,
    required this.height,
    this.channels = 3,
  });

  final List<int> bytes;
  final int width;
  final int height;
  final int channels;
}

/// پلاک تشخیص‌داده‌شده در تصویر.
class DetectedPlate {
  const DetectedPlate({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.confidence,
    this.classId = -1,
  });

  /// مختصات نرمال‌شده 0..1 نسبت به PlateImage.
  final double left;
  final double top;
  final double right;
  final double bottom;
  final double confidence;

  /// شناسه کلاس YOLO (−1 اگر نامشخص).
  final int classId;

  double get width => right - left;
  double get height => bottom - top;
  double get centerX => (left + right) / 2;
  double get centerY => (top + bottom) / 2;

  DetectedPlate copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? confidence,
    int? classId,
  }) {
    return DetectedPlate(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      confidence: confidence ?? this.confidence,
      classId: classId ?? this.classId,
    );
  }
}
