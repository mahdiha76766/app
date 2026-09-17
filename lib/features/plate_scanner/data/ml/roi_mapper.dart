import 'dart:ui';

import 'package:camera/camera.dart';

/// تبدیل مختصات کادر UI به crop سنسور با در نظر گرفتن BoxFit.cover و rotation.
abstract final class RoiMapper {
  /// نسبت تقریبی پلاک ایرانی (عرض به ارتفاع).
  static const plateAspectRatio = 4.0;

  /// تبدیل مستطیل preview به مستطیل crop در مختصات [CameraImage].
  ///
  /// [expandFactor] کادر را برای تشخیص پایدارتر بزرگ می‌کند
  /// (مثلاً ۱.۸ یعنی اطراف پلاک هم داخل ROI باشد).
  static Rect mapPreviewRectToSensor({
    required Rect previewRect,
    required Size previewSize,
    required Size sensorSize,
    required int rotationDegrees,
    double expandFactor = 1.0,
  }) {
    final normalizedRotation = ((rotationDegrees % 360) + 360) % 360;
    final displaySensorSize =
        _sensorSizeForRotation(sensorSize, normalizedRotation);

    final scale = _coverScale(previewSize, displaySensorSize);
    final scaledWidth = displaySensorSize.width * scale;
    final scaledHeight = displaySensorSize.height * scale;
    final offsetX = (previewSize.width - scaledWidth) / 2;
    final offsetY = (previewSize.height - scaledHeight) / 2;

    var displayRect = Rect.fromLTRB(
      ((previewRect.left - offsetX) / scale).clamp(0, displaySensorSize.width),
      ((previewRect.top - offsetY) / scale).clamp(0, displaySensorSize.height),
      ((previewRect.right - offsetX) / scale).clamp(0, displaySensorSize.width),
      ((previewRect.bottom - offsetY) / scale)
          .clamp(0, displaySensorSize.height),
    );

    if (expandFactor > 1.0) {
      displayRect = _expandRect(
        displayRect,
        expandFactor,
        displaySensorSize,
      );
    }

    return _mapDisplayRectToRawSensor(
      displayRect,
      sensorSize,
      normalizedRotation,
    );
  }

  static Rect _expandRect(Rect rect, double factor, Size bounds) {
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    final w = (rect.width * factor).clamp(1.0, bounds.width);
    final h = (rect.height * factor).clamp(1.0, bounds.height);
    return Rect.fromCenter(center: Offset(cx, cy), width: w, height: h)
        .intersect(Offset.zero & bounds);
  }

  static double _coverScale(Size preview, Size content) {
    final widthScale = preview.width / content.width;
    final heightScale = preview.height / content.height;
    return widthScale > heightScale ? widthScale : heightScale;
  }

  static Size _sensorSizeForRotation(Size sensorSize, int rotation) {
    if (rotation == 90 || rotation == 270) {
      return Size(sensorSize.height.toDouble(), sensorSize.width.toDouble());
    }
    return sensorSize;
  }

  static Rect _mapDisplayRectToRawSensor(
    Rect displayRect,
    Size rawSensorSize,
    int rotation,
  ) {
    final w = rawSensorSize.width;
    final h = rawSensorSize.height;

    switch (rotation) {
      case 90:
        return Rect.fromLTRB(
          displayRect.top,
          h - displayRect.right,
          displayRect.bottom,
          h - displayRect.left,
        );
      case 180:
        return Rect.fromLTRB(
          w - displayRect.right,
          h - displayRect.bottom,
          w - displayRect.left,
          h - displayRect.top,
        );
      case 270:
        return Rect.fromLTRB(
          w - displayRect.bottom,
          displayRect.left,
          w - displayRect.top,
          displayRect.right,
        );
      default:
        return displayRect;
    }
  }
}
