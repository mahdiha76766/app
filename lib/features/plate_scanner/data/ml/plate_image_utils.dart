import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../domain/entities/plate_frame.dart';

/// ابزارهای پردازش تصویر پلاک.
abstract final class PlateImageUtils {
  static PlateImage fromRgbBytes(Uint8List bytes, int width, int height) {
    return PlateImage(bytes: bytes, width: width, height: height);
  }

  static Uint8List toUint8List(List<int> bytes) => Uint8List.fromList(bytes);

  static img.Image toImage(PlateImage source) {
    return img.Image.fromBytes(
      width: source.width,
      height: source.height,
      bytes: toUint8List(source.bytes).buffer,
      numChannels: source.channels,
      order: img.ChannelOrder.rgb,
    );
  }

  static PlateImage fromImage(img.Image image) {
    return PlateImage(
      bytes: image.getBytes(order: img.ChannelOrder.rgb),
      width: image.width,
      height: image.height,
    );
  }

  static PlateImage cropNormalized(
    PlateImage source,
    double left,
    double top,
    double right,
    double bottom,
  ) {
    final x = (source.width * left).round().clamp(0, source.width - 1);
    final y = (source.height * top).round().clamp(0, source.height - 1);
    final w = (source.width * (right - left)).round().clamp(1, source.width - x);
    final h =
        (source.height * (bottom - top)).round().clamp(1, source.height - y);
    final image = toImage(source);
    final cropped = img.copyCrop(image, x: x, y: y, width: w, height: h);
    return fromImage(cropped);
  }

  static PlateImage resize(PlateImage source, int width, int height) {
    final image = toImage(source);
    final resized = img.copyResize(
      image,
      width: width,
      height: height,
      interpolation: img.Interpolation.linear,
    );
    return fromImage(resized);
  }

  /// Letterbox YOLO-style: حفظ نسبت تصویر + پد خاکستری.
  static LetterboxResult letterbox(
    PlateImage source,
    int size, {
    int padValue = 114,
  }) {
    final scale = math.min(size / source.width, size / source.height);
    final newW = math.max(1, (source.width * scale).round());
    final newH = math.max(1, (source.height * scale).round());
    final padX = (size - newW) ~/ 2;
    final padY = (size - newH) ~/ 2;

    final resized = resize(source, newW, newH);
    final canvas = img.Image(width: size, height: size, numChannels: 3);
    img.fill(canvas, color: img.ColorRgb8(padValue, padValue, padValue));
    img.compositeImage(canvas, toImage(resized), dstX: padX, dstY: padY);

    return LetterboxResult(
      image: fromImage(canvas),
      scale: scale,
      padX: padX,
      padY: padY,
      inputSize: size,
      originalWidth: source.width,
      originalHeight: source.height,
    );
  }

  /// تبدیل باکس نرمال‌شده letterbox به مختصات نرمال تصویر اصلی.
  static DetectedPlate mapLetterboxBoxToOriginal(
    DetectedPlate box,
    LetterboxResult letterbox,
  ) {
    final size = letterbox.inputSize.toDouble();
    final leftPx = box.left * size;
    final topPx = box.top * size;
    final rightPx = box.right * size;
    final bottomPx = box.bottom * size;

    double toOriginalX(double px) =>
        ((px - letterbox.padX) / letterbox.scale)
            .clamp(0, letterbox.originalWidth.toDouble());
    double toOriginalY(double py) =>
        ((py - letterbox.padY) / letterbox.scale)
            .clamp(0, letterbox.originalHeight.toDouble());

    final left = toOriginalX(leftPx) / letterbox.originalWidth;
    final top = toOriginalY(topPx) / letterbox.originalHeight;
    final right = toOriginalX(rightPx) / letterbox.originalWidth;
    final bottom = toOriginalY(bottomPx) / letterbox.originalHeight;

    return DetectedPlate(
      left: left.clamp(0.0, 1.0),
      top: top.clamp(0.0, 1.0),
      right: right.clamp(0.0, 1.0),
      bottom: bottom.clamp(0.0, 1.0),
      confidence: box.confidence,
      classId: box.classId,
    );
  }

  static PlateImage cropRect(PlateImage source, RectLike rect) {
    return cropNormalized(
      source,
      rect.left / source.width,
      rect.top / source.height,
      rect.right / source.width,
      rect.bottom / source.height,
    );
  }
}

class LetterboxResult {
  const LetterboxResult({
    required this.image,
    required this.scale,
    required this.padX,
    required this.padY,
    required this.inputSize,
    required this.originalWidth,
    required this.originalHeight,
  });

  final PlateImage image;
  final double scale;
  final int padX;
  final int padY;
  final int inputSize;
  final int originalWidth;
  final int originalHeight;
}

class RectLike {
  const RectLike({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;
}
