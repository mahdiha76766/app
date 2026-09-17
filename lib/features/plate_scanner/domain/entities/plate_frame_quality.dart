/// کیفیت فریم ROI قبل از OCR.
class PlateFrameQuality {
  const PlateFrameQuality({
    required this.brightness,
    required this.blurScore,
    required this.glareScore,
    required this.plateSizeRatio,
    required this.horizontalAngle,
    required this.isAcceptable,
    this.rejectionReason,
  });

  final double brightness;
  final double blurScore;
  final double glareScore;
  final double plateSizeRatio;
  final double horizontalAngle;
  final bool isAcceptable;
  final String? rejectionReason;

  static const acceptable = PlateFrameQuality(
    brightness: 128,
    blurScore: 500,
    glareScore: 0,
    plateSizeRatio: 0.5,
    horizontalAngle: 0,
    isAcceptable: true,
  );
}
