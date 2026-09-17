import '../entities/plate_frame.dart';

/// تشخیص bounding box پلاک در ROI.
abstract interface class PlateDetectorService {
  Future<List<DetectedPlate>> detect(PlateImage roiImage);

  Future<void> dispose();
}
