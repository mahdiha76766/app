import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import '../../domain/entities/iranian_plate_parts.dart';
import '../../domain/entities/plate_frame.dart';
import '../../domain/entities/plate_recognition_candidate.dart';
import '../../domain/services/live_plate_recognition_service.dart';
import '../../domain/services/plate_detection_service.dart';
import '../ml/iran_plate_yolo_labels.dart';
import '../ml/plate_image_utils.dart';
import 'plate_segmentation_service_impl.dart';
import 'tflite_plate_detection_service.dart';

/// Localization پلاک + خواندن کاراکترها از همان مدل YOLO (بدون recognizer جدا).
class LiveTfliteDetectorOnlyService implements LivePlateRecognitionService {
  LiveTfliteDetectorOnlyService({
    required this.detector,
    this.normalizer = const PlateNormalizationService(),
    this.acceptThreshold = 0.40,
  });

  final PlateDetectionService detector;
  final PlateNormalizationService normalizer;
  final double acceptThreshold;

  List<int>? lastCroppedBytes;
  int lastCroppedWidth = 0;
  int lastCroppedHeight = 0;

  static const emptyPlate = IranianPlateParts(
    firstTwoDigits: '',
    letter: '',
    middleThreeDigits: '',
    cityCode: '',
  );

  @override
  Future<PlateRecognitionCandidate?> recognize(
    Uint8List roiBytes,
    int width,
    int height,
  ) async {
    final started = DateTime.now();

    // فریم خام دوربین را راست کن، بعد detect کن تا با آموزش مدل هم‌راستا باشد.
    var orientation = 0;
    if (detector is TflitePlateDetectionService) {
      orientation =
          (detector as TflitePlateDetectionService).sensorOrientationDegrees;
      // خود سرویس تشخیص دوباره rotate نکند
      (detector as TflitePlateDetectionService).sensorOrientationDegrees = 0;
    }

    final upright = _uprightRgb(roiBytes, width, height, orientation);
    final detection = await detector.detect(
      Uint8List.fromList(upright.bytes),
      upright.width,
      upright.height,
    );

    // orientation را برای فریم بعد برگردان
    if (detector is TflitePlateDetectionService) {
      (detector as TflitePlateDetectionService).sensorOrientationDegrees =
          orientation;
    }

    final elapsed = DateTime.now().difference(started).inMilliseconds;

    if (detection == null) {
      lastCroppedBytes = null;
      lastCroppedWidth = 0;
      lastCroppedHeight = 0;
      return null;
    }

    final plate =
        detection.assembledPlate ??
        PlateYoloCharacterAssembler.assemble(detection.allDetections);
    final charCount = detection.allDetections
        .where((d) => IranPlateYoloLabels.isCharacterClass(d.classId))
        .length;

    debugPrint(
      'detector-only: conf=${detection.confidence.toStringAsFixed(3)} '
      'chars=$charCount plate=${plate?.rawCompact ?? "-"} '
      'bbox=${detection.bbox.left.toStringAsFixed(2)},'
      '${detection.bbox.top.toStringAsFixed(2)},'
      '${detection.bbox.right.toStringAsFixed(2)},'
      '${detection.bbox.bottom.toStringAsFixed(2)} '
      '(${elapsed}ms)',
    );

    if (detection.confidence < acceptThreshold) {
      return null;
    }

    final cropped = normalizer.normalizeFromRoi(upright, detection.bbox);
    lastCroppedBytes = cropped.bytes;
    lastCroppedWidth = cropped.width;
    lastCroppedHeight = cropped.height;

    // تا وقتی کاراکتر خوانده نشده، قبول نکن (فیلد خالی به کاربر نده).
    if (plate == null || !plate.isComplete) {
      return null;
    }

    final digitConfs = detection.allDetections
        .where((d) => d.classId >= 0 && d.classId <= 9)
        .map((d) => d.confidence)
        .toList(growable: false);
    final letterConf = detection.allDetections
        .where(
          (d) =>
              IranPlateYoloLabels.isCharacterClass(d.classId) &&
              d.classId > 9,
        )
        .fold<double>(0, (best, d) => d.confidence > best ? d.confidence : best);

    return PlateRecognitionCandidate(
      plate: plate,
      confidence: detection.confidence,
      timestamp: DateTime.now(),
      detectorConfidence: detection.confidence,
      digitConfidences: digitConfs,
      letterConfidence: letterConf,
      boundingBox: detection.bbox,
      processingMs: elapsed,
      // فیلدها پر شده‌اند؛ دیگر manual خالی نیست.
      detectorOnly: false,
    );
  }

  PlateImage _uprightRgb(
    Uint8List bytes,
    int width,
    int height,
    int sensorOrientation,
  ) {
    final source = PlateImageUtils.fromRgbBytes(bytes, width, height);
    final angle = ((sensorOrientation % 360) + 360) % 360;
    if (angle == 0) {
      return source;
    }
    final rotated = img.copyRotate(PlateImageUtils.toImage(source), angle: angle);
    return PlateImageUtils.fromImage(rotated);
  }

  @override
  Future<void> dispose() async {
    await detector.dispose();
  }
}
