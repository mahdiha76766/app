import 'dart:ui';

/// تقسیم پلاک normalize شده به 8 segment کاراکتر.
abstract final class PlateCharacterSegmentLayout {
  static const double blueStripRatio = 0.11;

  /// دو رقم اول.
  static const double firstDigit1Start = 0.11;
  static const double firstDigit1End = 0.195;
  static const double firstDigit2Start = 0.195;
  static const double firstDigit2End = 0.28;

  /// حرف.
  static const double letterStart = 0.28;
  static const double letterEnd = 0.40;

  /// سه رقم وسط.
  static const double middle1Start = 0.40;
  static const double middle1End = 0.493;
  static const double middle2Start = 0.493;
  static const double middle2End = 0.586;
  static const double middle3Start = 0.586;
  static const double middle3End = 0.68;

  /// کد شهر (پایین پنل راست — بدون «ایران»).
  static const double cityPanelStart = 0.68;
  static const double cityPanelEnd = 0.96;
  static const double cityCodeTopRatio = 0.45;

  static const double city1Start = 0.68;
  static const double city1End = 0.82;
  static const double city2Start = 0.82;
  static const double city2End = 0.96;

  static Rect firstDigit1Rect(int width, int height) =>
      _band(firstDigit1Start, firstDigit1End, width, height);

  static Rect firstDigit2Rect(int width, int height) =>
      _band(firstDigit2Start, firstDigit2End, width, height);

  static Rect letterRect(int width, int height) =>
      _band(letterStart, letterEnd, width, height);

  static Rect middleDigit1Rect(int width, int height) =>
      _band(middle1Start, middle1End, width, height);

  static Rect middleDigit2Rect(int width, int height) =>
      _band(middle2Start, middle2End, width, height);

  static Rect middleDigit3Rect(int width, int height) =>
      _band(middle3Start, middle3End, width, height);

  static Rect cityDigit1Rect(int width, int height) =>
      _cityDigit(city1Start, city1End, width, height);

  static Rect cityDigit2Rect(int width, int height) =>
      _cityDigit(city2Start, city2End, width, height);

  static Rect _band(double start, double end, int width, int height) {
    if (width <= 0 || height <= 0) {
      return Rect.zero;
    }
    final left = (width * start).round().clamp(0, width - 1);
    final right = (width * end).round().clamp(left + 1, width);
    return Rect.fromLTRB(left.toDouble(), 0, right.toDouble(), height.toDouble());
  }

  static Rect _cityDigit(double start, double end, int width, int height) {
    if (width <= 0 || height <= 0) {
      return Rect.zero;
    }
    final left = (width * start).round().clamp(0, width - 1);
    final right = (width * end).round().clamp(left + 1, width);
    final top = (height * cityCodeTopRatio).round().clamp(0, height - 1);
    return Rect.fromLTRB(
      left.toDouble(),
      top.toDouble(),
      right.toDouble(),
      height.toDouble(),
    );
  }
}
