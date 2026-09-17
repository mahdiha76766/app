import '../entities/plate_consensus_result.dart';
import '../entities/plate_ocr_candidate.dart';

/// رأی‌گیری بین چند فریم OCR.
abstract interface class PlateConsensusService {
  PlateConsensusResult addCandidate(PlateOcrCandidate candidate);

  void reset();
}
