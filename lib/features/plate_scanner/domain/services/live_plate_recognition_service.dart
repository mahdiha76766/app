import 'dart:typed_data';

import '../entities/plate_recognition_candidate.dart';

/// تشخیص کامل پلاک از ROI (detector + classifier).
abstract interface class LivePlateRecognitionService {
  Future<PlateRecognitionCandidate?> recognize(
    Uint8List roiBytes,
    int width,
    int height,
  );

  Future<void> dispose();
}
