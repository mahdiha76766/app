import '../entities/plate_frame.dart';
import '../entities/plate_segments.dart';

/// classifier عدد و حرف پلاک.
abstract interface class PlateCharacterClassifier {
  Future<DigitPrediction> predictDigit(PlateImage segment);

  Future<LetterPrediction> predictLetter(PlateImage segment);

  Future<void> dispose();
}
