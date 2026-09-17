import '../entities/plate_frame.dart';
import '../entities/plate_segments.dart';

/// تقسیم پلاک normalize شده به segmentهای کاراکتر.
abstract interface class PlateSegmentationService {
  Future<PlateSegments> segment(PlateImage normalizedPlate);
}
