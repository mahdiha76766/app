import '../../domain/entities/plate_frame.dart';
import '../../domain/config/iranian_plate_config.dart';
import '../../domain/entities/iranian_plate_parts.dart';
import '../../domain/entities/plate_consensus_result.dart';
import '../../domain/entities/plate_ocr_candidate.dart';
import '../../domain/services/plate_consensus_service.dart';

/// رأی‌گیری سریع بین فریم‌های اخیر با کمی تحمل خطای OCR.
class PlateConsensusServiceImpl implements PlateConsensusService {
  PlateConsensusServiceImpl({
    this.maxCandidates = 2,
    this.requiredVotes = 2,
    this.minAverageConfidence = 0.6,
    this.candidateTtl = const Duration(seconds: 2),
    this.maxBoundingCenterDrift = 0.08,
  });

  final int maxCandidates;
  final int requiredVotes;
  final double minAverageConfidence;
  final Duration candidateTtl;
  final double maxBoundingCenterDrift;

  final List<PlateOcrCandidate> _buffer = [];

  @override
  void reset() => _buffer.clear();

  @override
  PlateConsensusResult addCandidate(PlateOcrCandidate candidate) {
    _purgeExpired(DateTime.now());

    if (!candidate.isStructurallyValid ||
        !IranianPlateConfig.isValidParts(
          firstTwoDigits: candidate.plate.firstTwoDigits,
          letter: candidate.plate.letter,
          middleThreeDigits: candidate.plate.middleThreeDigits,
          cityCode: candidate.plate.cityCode,
        )) {
      return PlateConsensusResult.none;
    }

    _buffer.add(candidate);
    while (_buffer.length > maxCandidates) {
      _buffer.removeAt(0);
    }

    if (_buffer.length < requiredVotes) {
      return PlateConsensusResult(
        isAccepted: false,
        voteCount: _buffer.length,
        requiredVotes: requiredVotes,
      );
    }

    final merged = _majorityPlate(_buffer);
    final supporting = <PlateOcrCandidate>[];

    for (final item in _buffer) {
      if (_differenceCount(item.plate, merged) <= 1) {
        supporting.add(item);
      }
    }

    if (supporting.length < requiredVotes) {
      return PlateConsensusResult(
        isAccepted: false,
        plate: merged,
        voteCount: supporting.length,
        requiredVotes: requiredVotes,
      );
    }

    final avgConfidence =
        supporting.map((e) => e.confidence).reduce((a, b) => a + b) /
            supporting.length;

    if (avgConfidence < minAverageConfidence) {
      return PlateConsensusResult(
        isAccepted: false,
        plate: merged,
        averageConfidence: avgConfidence,
        voteCount: supporting.length,
        requiredVotes: requiredVotes,
      );
    }

    if (!_isBoundingStable(supporting)) {
      return PlateConsensusResult(
        isAccepted: false,
        plate: merged,
        averageConfidence: avgConfidence,
        voteCount: supporting.length,
        requiredVotes: requiredVotes,
      );
    }

    return PlateConsensusResult(
      isAccepted: true,
      plate: merged,
      averageConfidence: avgConfidence,
      voteCount: supporting.length,
      requiredVotes: requiredVotes,
    );
  }

  void _purgeExpired(DateTime now) {
    _buffer.removeWhere(
      (item) => now.difference(item.timestamp) > candidateTtl,
    );
  }

  IranianPlateParts _majorityPlate(List<PlateOcrCandidate> items) {
    return IranianPlateParts(
      firstTwoDigits: _majority(items.map((e) => e.plate.firstTwoDigits)),
      letter: _majority(items.map((e) => e.plate.letter)),
      middleThreeDigits:
          _majority(items.map((e) => e.plate.middleThreeDigits)),
      cityCode: _majority(items.map((e) => e.plate.cityCode)),
    );
  }

  String _majority(Iterable<String> values) {
    final counts = <String, int>{};
    for (final value in values) {
      counts[value] = (counts[value] ?? 0) + 1;
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  int _differenceCount(IranianPlateParts a, IranianPlateParts b) {
    var diff = 0;
    if (a.firstTwoDigits != b.firstTwoDigits) {
      diff++;
    }
    if (a.letter != b.letter) {
      diff++;
    }
    if (a.middleThreeDigits != b.middleThreeDigits) {
      diff++;
    }
    if (a.cityCode != b.cityCode) {
      diff++;
    }
    return diff;
  }

  bool _isBoundingStable(List<PlateOcrCandidate> items) {
    final boxes = items
        .map((e) => e.boundingBox)
        .whereType<DetectedPlate>()
        .toList(growable: false);
    if (boxes.length < requiredVotes) {
      return true;
    }

    final avgCenterX =
        boxes.map((b) => b.centerX).reduce((a, b) => a + b) / boxes.length;
    final avgCenterY =
        boxes.map((b) => b.centerY).reduce((a, b) => a + b) / boxes.length;

    for (final box in boxes) {
      if ((box.centerX - avgCenterX).abs() > maxBoundingCenterDrift ||
          (box.centerY - avgCenterY).abs() > maxBoundingCenterDrift) {
        return false;
      }
    }
    return true;
  }
}
