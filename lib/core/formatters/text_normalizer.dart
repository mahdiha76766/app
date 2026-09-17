import 'iranian_plate_normalizer.dart';
import 'persian_digit_formatter.dart';

/// نرمال‌سازی متن فارسی برای جستجو و کلید یکتا.
abstract final class TextNormalizer {
  /// فاصله‌های اضافه را حذف و ارقام را به انگلیسی تبدیل می‌کند.
  static String normalize(String input) {
    var value = PersianDigitFormatter.toEnglish(input).trim();
    if (value.isEmpty) {
      return value;
    }

    value = value
        .replaceAll('ي', 'ی')
        .replaceAll('ى', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('\u200c', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();

    return value;
  }

  /// پلاک را به کلید جستجو تبدیل می‌کند: `52-D-689-11`
  static String normalizePlate(String input) {
    return IranianPlateNormalizer.normalize(input);
  }
}
