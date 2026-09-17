import 'dart:typed_data';

import '../entities/plate_detection_result.dart';

/// تشخیص پلاک در ROI با TFLite.
abstract interface class PlateDetectionService {
  Future<PlateDetectionResult?> detect(Uint8List imageBytes, int width, int height);

  Future<void> dispose();
}
