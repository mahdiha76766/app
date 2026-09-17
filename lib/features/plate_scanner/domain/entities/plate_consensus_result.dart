import 'iranian_plate_parts.dart';

/// نتیجه رأی‌گیری بین چند فریم.
class PlateConsensusResult {
  const PlateConsensusResult({
    required this.isAccepted,
    this.plate,
    this.averageConfidence = 0,
    this.voteCount = 0,
    this.requiredVotes = 4,
  });

  final bool isAccepted;
  final IranianPlateParts? plate;
  final double averageConfidence;
  final int voteCount;
  final int requiredVotes;

  static const none = PlateConsensusResult(isAccepted: false);
}
