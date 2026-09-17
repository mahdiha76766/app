import 'plate_frame.dart';
import 'iranian_plate_parts.dart';

/// نتیجه OCR یک فریم.
class PlateOcrCandidate {
  const PlateOcrCandidate({
    required this.plate,
    required this.confidence,
    required this.timestamp,
    this.boundingBox,
  });

  final IranianPlateParts plate;
  final double confidence;
  final DateTime timestamp;
  final DetectedPlate? boundingBox;

  bool get isStructurallyValid => plate.isComplete;
}
