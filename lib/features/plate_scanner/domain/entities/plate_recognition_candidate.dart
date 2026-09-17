import 'iranian_plate_parts.dart';
import 'plate_frame.dart';

/// نتیجه کامل تشخیص یک فریم.
class PlateRecognitionCandidate {
  const PlateRecognitionCandidate({
    required this.plate,
    required this.confidence,
    required this.timestamp,
    this.detectorConfidence = 0,
    this.digitConfidences = const [],
    this.letterConfidence = 0,
    this.boundingBox,
    this.processingMs = 0,
    this.detectorOnly = false,
  });

  final IranianPlateParts plate;
  final double confidence;
  final DateTime timestamp;
  final double detectorConfidence;
  final List<double> digitConfidences;
  final double letterConfidence;
  final DetectedPlate? boundingBox;
  final int processingMs;

  /// فقط localization؛ کاربر باید شماره را دستی وارد کند.
  final bool detectorOnly;

  bool get isStructurallyValid => plate.isComplete;
}
