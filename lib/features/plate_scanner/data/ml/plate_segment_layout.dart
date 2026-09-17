import 'dart:ui';

/// تقسیم crop پلاک به چهار ناحیه OCR (بدون نوار آبی و متن «ایران»).
abstract final class PlateSegmentLayout {
  /// عرض نوار آبی سمت چپ (نسبت به عرض پلاک).
  static const double blueStripRatio = 0.11;

  static const double firstTwoStart = 0.11;
  static const double firstTwoEnd = 0.28;

  static const double letterStart = 0.28;
  static const double letterEnd = 0.40;

  static const double middleStart = 0.40;
  static const double middleEnd = 0.68;

  static const double cityPanelStart = 0.68;
  static const double cityPanelEnd = 0.96;

  /// کد شهر در پایین پنل سمت راست است؛ «ایران» بالای آن قرار دارد.
  static const double cityCodeTopRatio = 0.45;

  static Rect firstTwoDigitsRect(int width, int height) =>
      _horizontalBand(firstTwoStart, firstTwoEnd, width, height);

  static Rect letterRect(int width, int height) =>
      _horizontalBand(letterStart, letterEnd, width, height);

  static Rect middleThreeDigitsRect(int width, int height) =>
      _horizontalBand(middleStart, middleEnd, width, height);

  static Rect cityCodeRect(int width, int height) {
    if (width <= 0 || height <= 0) {
      return Rect.zero;
    }
    final left = (width * cityPanelStart).round().clamp(0, width - 1);
    final right = (width * cityPanelEnd).round().clamp(left + 1, width);
    final top = (height * cityCodeTopRatio).round().clamp(0, height - 1);
    final bottom = height;
    return Rect.fromLTRB(
      left.toDouble(),
      top.toDouble(),
      right.toDouble(),
      bottom.toDouble(),
    );
  }

  static Rect _horizontalBand(
    double startRatio,
    double endRatio,
    int width,
    int height,
  ) {
    if (width <= 0 || height <= 0) {
      return Rect.zero;
    }
    final left = (width * startRatio).round().clamp(0, width - 1);
    final right = (width * endRatio).round().clamp(left + 1, width);
    return Rect.fromLTRB(
      left.toDouble(),
      0,
      right.toDouble(),
      height.toDouble(),
    );
  }

  /// بررسی معتبر بودن rect نسبت به ابعاد تصویر.
  static bool isValidSegment(Rect rect, int width, int height) {
    if (width <= 0 || height <= 0) {
      return false;
    }
    if (rect.width < 4 || rect.height < 4) {
      return false;
    }
    if (rect.left < 0 ||
        rect.top < 0 ||
        rect.right > width ||
        rect.bottom > height) {
      return false;
    }
    return true;
  }
}
