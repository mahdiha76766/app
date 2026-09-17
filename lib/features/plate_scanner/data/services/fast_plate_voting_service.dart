import '../../domain/entities/iranian_plate_parts.dart';
import '../../domain/entities/plate_consensus_result.dart';
import '../../domain/entities/plate_recognition_candidate.dart';

/// رأی‌گیری سریع: یک نتیجه با confidence بالا یا حداکثر 2 فریم مشابه.
class FastPlateVotingService {
  FastPlateVotingService({
    this.highConfidenceThreshold = 0.85,
    this.mediumConfidenceThreshold = 0.70,
    this.requiredSimilarFrames = 2,
    this.maxBuffer = 2,
    this.candidateTtl = const Duration(seconds: 2),
  });

  final double highConfidenceThreshold;
  final double mediumConfidenceThreshold;
  final int requiredSimilarFrames;
  final int maxBuffer;
  final Duration candidateTtl;

  final List<PlateRecognitionCandidate> _buffer = [];

  void reset() => _buffer.clear();

  PlateConsensusResult addCandidate(PlateRecognitionCandidate candidate) {
    _purgeExpired(DateTime.now());

    // detector-only بدون پلاک کامل: قبول نکن (صبر برای خواندن کاراکترها).
    if (candidate.detectorOnly) {
      final hasPlate = candidate.plate.isComplete;
      if (hasPlate &&
          candidate.detectorConfidence >= mediumConfidenceThreshold) {
        return PlateConsensusResult(
          isAccepted: true,
          plate: candidate.plate,
          averageConfidence: candidate.detectorConfidence,
          voteCount: 1,
          requiredVotes: 1,
        );
      }
      if (!hasPlate &&
          candidate.detectorConfidence >= mediumConfidenceThreshold &&
          candidate.plate.rawCompact.isEmpty) {
        // مسیر قدیمی: فقط localization — یک فریم کافی است.
        return PlateConsensusResult(
          isAccepted: true,
          plate: candidate.plate,
          averageConfidence: candidate.detectorConfidence,
          voteCount: 1,
          requiredVotes: 1,
        );
      }
      return PlateConsensusResult.none;
    }

    if (!candidate.isStructurallyValid) {
      return PlateConsensusResult.none;
    }

    if (candidate.confidence >= highConfidenceThreshold) {
      return PlateConsensusResult(
        isAccepted: true,
        plate: candidate.plate,
        averageConfidence: candidate.confidence,
        voteCount: 1,
        requiredVotes: 1,
      );
    }

    _buffer.add(candidate);
    while (_buffer.length > maxBuffer) {
      _buffer.removeAt(0);
    }

    if (_buffer.length < requiredSimilarFrames) {
      return PlateConsensusResult(
        isAccepted: false,
        voteCount: _buffer.length,
        requiredVotes: requiredSimilarFrames,
      );
    }

    final merged = _majorityPlate(_buffer);
    final supporting = _buffer
        .where((item) => _differenceCount(item.plate, merged) <= 1)
        .toList();

    if (supporting.length < requiredSimilarFrames) {
      return PlateConsensusResult(
        isAccepted: false,
        plate: merged,
        voteCount: supporting.length,
        requiredVotes: requiredSimilarFrames,
      );
    }

    final avgConfidence =
        supporting.map((e) => e.confidence).reduce((a, b) => a + b) /
            supporting.length;

    if (avgConfidence < mediumConfidenceThreshold) {
      return PlateConsensusResult(
        isAccepted: false,
        plate: merged,
        averageConfidence: avgConfidence,
        voteCount: supporting.length,
        requiredVotes: requiredSimilarFrames,
      );
    }

    return PlateConsensusResult(
      isAccepted: true,
      plate: merged,
      averageConfidence: avgConfidence,
      voteCount: supporting.length,
      requiredVotes: requiredSimilarFrames,
    );
  }

  void _purgeExpired(DateTime now) {
    _buffer.removeWhere(
      (item) => now.difference(item.timestamp) > candidateTtl,
    );
  }

  IranianPlateParts _majorityPlate(List<PlateRecognitionCandidate> items) {
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
    if (a.firstTwoDigits != b.firstTwoDigits) diff++;
    if (a.letter != b.letter) diff++;
    if (a.middleThreeDigits != b.middleThreeDigits) diff++;
    if (a.cityCode != b.cityCode) diff++;
    return diff;
  }
}
