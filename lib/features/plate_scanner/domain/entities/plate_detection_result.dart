import 'iranian_plate_parts.dart';
import 'plate_frame.dart';

/// نتیجه detector پلاک.
class PlateDetectionResult {
  const PlateDetectionResult({
    required this.bbox,
    required this.confidence,
    this.angle,
    this.isComplete = true,
    this.allDetections = const [],
    this.assembledPlate,
  });

  final DetectedPlate bbox;
  final double confidence;
  final double? angle;
  final bool isComplete;

  /// همه باکس‌های YOLO (پلاک + کاراکترها) در مختصات تصویر ورودی.
  final List<DetectedPlate> allDetections;

  /// پلاک ساخته‌شده از کلاس کاراکترها (در صورت موفقیت).
  final IranianPlateParts? assembledPlate;
}
