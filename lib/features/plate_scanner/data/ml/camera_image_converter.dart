import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/plate_frame.dart';

/// تبدیل CameraImage به RGB و crop ROI.
///
/// فقط ناحیه ROI تبدیل می‌شود. برای Android YUV_420_888 از
/// pixelStride واقعی UV استفاده می‌شود.
abstract final class CameraImageConverter {
  static PlateImage cropRoi(CameraImage image, Rect sensorRect) {
    final width = image.width;
    final height = image.height;
    final left = sensorRect.left.round().clamp(0, width - 1);
    final top = sensorRect.top.round().clamp(0, height - 1);
    final right = sensorRect.right.round().clamp(left + 1, width);
    final bottom = sensorRect.bottom.round().clamp(top + 1, height);
    final cropW = right - left;
    final cropH = bottom - top;

    if (image.format.group == ImageFormatGroup.bgra8888 &&
        image.planes.length == 1) {
      return _cropBgra(image.planes.first.bytes, width, left, top, cropW, cropH);
    }
    return _cropYuv420(image, left, top, cropW, cropH);
  }

  static PlateImage _cropBgra(
    Uint8List bgra,
    int fullWidth,
    int left,
    int top,
    int cropW,
    int cropH,
  ) {
    final rgb = Uint8List(cropW * cropH * 3);
    var dst = 0;
    for (var y = 0; y < cropH; y++) {
      final row = ((top + y) * fullWidth + left) * 4;
      for (var x = 0; x < cropW; x++) {
        final src = row + x * 4;
        // BGRA → RGB
        rgb[dst++] = bgra[src + 2];
        rgb[dst++] = bgra[src + 1];
        rgb[dst++] = bgra[src];
      }
    }
    return PlateImage(bytes: rgb, width: cropW, height: cropH);
  }

  static PlateImage _cropYuv420(
    CameraImage image,
    int left,
    int top,
    int cropW,
    int cropH,
  ) {
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBytes = yPlane.bytes;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final yRowStride = yPlane.bytesPerRow;
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;

    final rgb = Uint8List(cropW * cropH * 3);
    var dst = 0;
    var sum = 0;

    for (var row = 0; row < cropH; row++) {
      final py = top + row;
      for (var col = 0; col < cropW; col++) {
        final px = left + col;
        final yIndex = py * yRowStride + px;
        final uvIndex =
            (py >> 1) * uvRowStride + (px >> 1) * uvPixelStride;

        final yValue = yBytes[yIndex];
        // بعضی دستگاه‌ها U/V را جابه‌جا گزارش می‌کنند؛ هر دو را امتحان‌پذیر نگه می‌داریم
        final uValue = uBytes[uvIndex.clamp(0, uBytes.length - 1)];
        final vValue = vBytes[uvIndex.clamp(0, vBytes.length - 1)];

        // BT.601 YUV → RGB
        final c = yValue - 16;
        final d = uValue - 128;
        final e = vValue - 128;
        final r = ((298 * c + 409 * e + 128) >> 8).clamp(0, 255);
        final g = ((298 * c - 100 * d - 208 * e + 128) >> 8).clamp(0, 255);
        final b = ((298 * c + 516 * d + 128) >> 8).clamp(0, 255);

        rgb[dst++] = r;
        rgb[dst++] = g;
        rgb[dst++] = b;
        sum += r + g + b;
      }
    }

    final mean = sum / (cropW * cropH * 3);
    assert(() {
      debugPrint(
        'YUV crop ${cropW}x$cropH mean=${mean.toStringAsFixed(1)} '
        'uvStride=$uvPixelStride uvRow=$uvRowStride',
      );
      return true;
    }());

    return PlateImage(bytes: rgb, width: cropW, height: cropH);
  }

  /// تبدیل PlateImage RGB به grayscale.
  static Uint8List toGrayscale(PlateImage image) {
    final gray = Uint8List(image.width * image.height);
    var src = 0;
    for (var i = 0; i < gray.length; i++) {
      final r = image.bytes[src++];
      final g = image.bytes[src++];
      final b = image.bytes[src++];
      gray[i] = ((0.299 * r) + (0.587 * g) + (0.114 * b)).round();
    }
    return gray;
  }
}
