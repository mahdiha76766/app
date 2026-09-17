import '../../domain/entities/plate_frame.dart';
import 'iran_plate_yolo_labels.dart';

/// parse خروجی detector (YOLO/SSD style).
abstract final class PlateDetectorOutputParser {
  /// پشتیبانی از دو فرمت رایج:
  /// - [1, N, >=5] => cx,cy,w,h,conf[,class] (legacy / SSD-like)
  /// - [1, 4+nc, N] => Ultralytics YOLO (channels-first)
  static List<DetectedPlate> parseYoloLike({
    required List<double> output,
    required List<int> shape,
    required double confidenceThreshold,
    double iouThreshold = 0.45,
    double inputWidth = 320,
    double inputHeight = 320,
  }) {
    if (shape.length != 3) {
      return const [];
    }

    // Ultralytics: [1, 4+nc, N] با N معمولاً بزرگ و 4+nc کوچک (<=64)
    // Legacy: [1, N, >=5] با N بزرگ و stride کوچک
    final isChannelsFirst = shape[1] >= 5 && shape[1] <= 64;

    final rawCandidates = isChannelsFirst
        ? _parseChannelsFirst(
            output: output,
            channels: shape[1],
            count: shape[2],
            confidenceThreshold: confidenceThreshold,
            inputWidth: inputWidth,
            inputHeight: inputHeight,
          )
        : _parseDetectionsLast(
            output: output,
            count: shape[1],
            stride: shape[2],
            confidenceThreshold: confidenceThreshold,
            inputWidth: inputWidth,
            inputHeight: inputHeight,
          );

    final candidates = List<DetectedPlate>.from(rawCandidates);
    candidates.sort((a, b) => b.confidence.compareTo(a.confidence));
    return _nms(candidates, iouThreshold);
  }

  /// Ultralytics: [1, 4+nc, N]
  static List<DetectedPlate> _parseChannelsFirst({
    required List<double> output,
    required int channels,
    required int count,
    required double confidenceThreshold,
    required double inputWidth,
    required double inputHeight,
  }) {
    if (channels < 5 || count <= 0) {
      return const [];
    }
    final numClasses = channels - 4;
    final candidates = <DetectedPlate>[];

    for (var i = 0; i < count; i++) {
      var bestScore = output[4 * count + i];
      var bestClass = 0;
      for (var c = 1; c < numClasses; c++) {
        final score = output[(4 + c) * count + i];
        if (score > bestScore) {
          bestScore = score;
          bestClass = c;
        }
      }
      if (bestScore < confidenceThreshold) {
        continue;
      }

      final cx = _normalizeCoord(output[0 * count + i], inputWidth);
      final cy = _normalizeCoord(output[1 * count + i], inputHeight);
      final w = _normalizeCoord(output[2 * count + i], inputWidth);
      final h = _normalizeCoord(output[3 * count + i], inputHeight);

      candidates.add(
        DetectedPlate(
          left: (cx - w / 2).clamp(0.0, 1.0),
          top: (cy - h / 2).clamp(0.0, 1.0),
          right: (cx + w / 2).clamp(0.0, 1.0),
          bottom: (cy + h / 2).clamp(0.0, 1.0),
          confidence: bestScore.clamp(0.0, 1.0),
          classId: bestClass,
        ),
      );
    }
    return candidates;
  }

  /// Legacy: [1, N, >=5]
  static List<DetectedPlate> _parseDetectionsLast({
    required List<double> output,
    required int count,
    required int stride,
    required double confidenceThreshold,
    required double inputWidth,
    required double inputHeight,
  }) {
    if (stride < 5) {
      return const [];
    }
    final candidates = <DetectedPlate>[];

    for (var i = 0; i < count; i++) {
      final base = i * stride;
      final confidence = output[base + 4];
      if (confidence < confidenceThreshold) {
        continue;
      }
      final cx = _normalizeCoord(output[base], inputWidth);
      final cy = _normalizeCoord(output[base + 1], inputHeight);
      final w = _normalizeCoord(output[base + 2], inputWidth);
      final h = _normalizeCoord(output[base + 3], inputHeight);
      final classId = stride > 5 ? output[base + 5].round() : -1;
      candidates.add(
        DetectedPlate(
          left: (cx - w / 2).clamp(0.0, 1.0),
          top: (cy - h / 2).clamp(0.0, 1.0),
          right: (cx + w / 2).clamp(0.0, 1.0),
          bottom: (cy + h / 2).clamp(0.0, 1.0),
          confidence: confidence.clamp(0.0, 1.0),
          classId: classId,
        ),
      );
    }
    return candidates;
  }

  /// اگر مختصات بزرگ‌تر از ۱ باشد، فرض می‌کنیم پیکسلی است.
  static double _normalizeCoord(double value, double size) {
    if (value > 1.5) {
      return (value / size).clamp(0.0, 1.0);
    }
    return value.clamp(0.0, 1.0);
  }

  static List<DetectedPlate> _nms(
    List<DetectedPlate> boxes,
    double iouThreshold,
  ) {
    if (boxes.length <= 1) {
      return boxes;
    }
    final kept = <DetectedPlate>[];
    final suppressed = List<bool>.filled(boxes.length, false);

    for (var i = 0; i < boxes.length; i++) {
      if (suppressed[i]) {
        continue;
      }
      kept.add(boxes[i]);
      for (var j = i + 1; j < boxes.length; j++) {
        if (suppressed[j]) {
          continue;
        }
        // NMS فقط بین هم‌کلاس (یا هر دو بدون کلاس)
        if (boxes[i].classId >= 0 &&
            boxes[j].classId >= 0 &&
            boxes[i].classId != boxes[j].classId) {
          continue;
        }
        if (_iou(boxes[i], boxes[j]) > iouThreshold) {
          suppressed[j] = true;
        }
      }
    }
    return kept;
  }

  static double _iou(DetectedPlate a, DetectedPlate b) {
    final x1 = a.left > b.left ? a.left : b.left;
    final y1 = a.top > b.top ? a.top : b.top;
    final x2 = a.right < b.right ? a.right : b.right;
    final y2 = a.bottom < b.bottom ? a.bottom : b.bottom;
    final interW = (x2 - x1).clamp(0.0, 1.0);
    final interH = (y2 - y1).clamp(0.0, 1.0);
    final inter = interW * interH;
    final union = a.width * a.height + b.width * b.height - inter;
    if (union <= 0) {
      return 0;
    }
    return inter / union;
  }

  /// بهترین باکس برای crop پلاک.
  ///
  /// اولویت با کلاس `plate`؛ وگرنه بزرگ‌ترین باکس یا union کاراکترها.
  static DetectedPlate? pickBest(List<DetectedPlate> detections) {
    if (detections.isEmpty) {
      return null;
    }

    final plateBoxes = detections
        .where((d) => IranPlateYoloLabels.isPlateClass(d.classId))
        .toList();
    if (plateBoxes.isNotEmpty) {
      return plateBoxes.reduce((a, b) {
        final areaA = a.width * a.height;
        final areaB = b.width * b.height;
        if (areaA == areaB) {
          return a.confidence >= b.confidence ? a : b;
        }
        return areaA > areaB ? a : b;
      });
    }

    final largest = detections.reduce((a, b) {
      final areaA = a.width * a.height;
      final areaB = b.width * b.height;
      if (areaA == areaB) {
        return a.confidence >= b.confidence ? a : b;
      }
      return areaA > areaB ? a : b;
    });

    // باکس نسبتاً بزرگ = احتمالاً خود پلاک
    if (largest.width * largest.height >= 0.12) {
      return largest;
    }

    // در غیر این صورت از union کاراکترها محدوده پلاک را بساز
    var left = 1.0;
    var top = 1.0;
    var right = 0.0;
    var bottom = 0.0;
    var confSum = 0.0;
    for (final box in detections) {
      if (box.left < left) left = box.left;
      if (box.top < top) top = box.top;
      if (box.right > right) right = box.right;
      if (box.bottom > bottom) bottom = box.bottom;
      confSum += box.confidence;
    }

    // کمی padding اطراف کاراکترها
    final padX = ((right - left) * 0.06).clamp(0.0, 0.08);
    final padY = ((bottom - top) * 0.15).clamp(0.0, 0.12);

    return DetectedPlate(
      left: (left - padX).clamp(0.0, 1.0),
      top: (top - padY).clamp(0.0, 1.0),
      right: (right + padX).clamp(0.0, 1.0),
      bottom: (bottom + padY).clamp(0.0, 1.0),
      confidence: confSum / detections.length,
      classId: IranPlateYoloLabels.plateClassId,
    );
  }
}
