import 'dart:typed_data';

import '../../domain/config/iranian_plate_config.dart';
import '../../domain/entities/iranian_plate_parts.dart';
import '../../domain/entities/plate_recognition_candidate.dart';
import '../../domain/services/live_plate_recognition_service.dart';
import '../../domain/services/plate_character_classifier.dart';
import '../../domain/services/plate_detection_service.dart';
import '../../domain/services/plate_segmentation_service.dart';
import '../ml/plate_image_utils.dart';
import 'plate_segmentation_service_impl.dart';

/// pipeline کامل تشخیص: detector → normalize → segment → classify.
class LiveTflitePlateRecognitionService implements LivePlateRecognitionService {
  LiveTflitePlateRecognitionService({
    required this._detector,
    required this._classifier,
    PlateSegmentationService? segmenter,
    this.normalizer = const PlateNormalizationService(),
  }) : _segmenter = segmenter ?? const PlateSegmentationServiceImpl();

  final PlateDetectionService _detector;
  final PlateCharacterClassifier _classifier;
  final PlateSegmentationService _segmenter;
  final PlateNormalizationService normalizer;

  @override
  Future<PlateRecognitionCandidate?> recognize(
    Uint8List roiBytes,
    int width,
    int height,
  ) async {
    final started = DateTime.now();
    final roi = PlateImageUtils.fromRgbBytes(roiBytes, width, height);

    final detection = await _detector.detect(roiBytes, width, height);
    if (detection == null) {
      return null;
    }

    final normalized = normalizer.normalizeFromRoi(roi, detection.bbox);
    final segments = await _segmenter.segment(normalized);

    final d1 = await _classifier.predictDigit(segments.firstDigit1);
    final d2 = await _classifier.predictDigit(segments.firstDigit2);
    final letter = await _classifier.predictLetter(segments.letter);
    final m1 = await _classifier.predictDigit(segments.middleDigit1);
    final m2 = await _classifier.predictDigit(segments.middleDigit2);
    final m3 = await _classifier.predictDigit(segments.middleDigit3);
    final c1 = await _classifier.predictDigit(segments.cityDigit1);
    final c2 = await _classifier.predictDigit(segments.cityDigit2);

    final digits = [d1, d2, m1, m2, m3, c1, c2];
    if (!d1.isValid ||
        !d2.isValid ||
        !letter.isValid ||
        !m1.isValid ||
        !m2.isValid ||
        !m3.isValid ||
        !c1.isValid ||
        !c2.isValid) {
      return null;
    }

    final parts = IranianPlateParts(
      firstTwoDigits: '${d1.digit}${d2.digit}',
      letter: letter.letter,
      middleThreeDigits: '${m1.digit}${m2.digit}${m3.digit}',
      cityCode: '${c1.digit}${c2.digit}',
    );

    if (!IranianPlateConfig.isValidParts(
      firstTwoDigits: parts.firstTwoDigits,
      letter: parts.letter,
      middleThreeDigits: parts.middleThreeDigits,
      cityCode: parts.cityCode,
    )) {
      return null;
    }

    final digitConfidences =
        digits.map((d) => d.confidence).toList(growable: false);
    final avgConfidence = digitConfidences.reduce((a, b) => a + b) / 7 +
        letter.confidence / 7;

    return PlateRecognitionCandidate(
      plate: parts,
      confidence: avgConfidence.clamp(0, 1),
      timestamp: DateTime.now(),
      detectorConfidence: detection.confidence,
      digitConfidences: digitConfidences,
      letterConfidence: letter.confidence,
      boundingBox: detection.bbox,
      processingMs: DateTime.now().difference(started).inMilliseconds,
    );
  }

  @override
  Future<void> dispose() async {
    await _detector.dispose();
    await _classifier.dispose();
  }
}
