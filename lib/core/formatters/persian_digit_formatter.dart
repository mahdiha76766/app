/// تبدیل ارقام بین فارسی، عربی و انگلیسی.
abstract final class PersianDigitFormatter {
  static const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  static const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  static const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  /// اعداد انگلیسی را برای نمایش به فارسی تبدیل می‌کند.
  static String toPersian(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final englishIndex = englishDigits.indexOf(char);
      if (englishIndex >= 0) {
        buffer.write(persianDigits[englishIndex]);
        continue;
      }
      final arabicIndex = arabicDigits.indexOf(char);
      if (arabicIndex >= 0) {
        buffer.write(persianDigits[arabicIndex]);
        continue;
      }
      buffer.write(char);
    }
    return buffer.toString();
  }

  /// اعداد فارسی و عربی را برای پردازش به انگلیسی تبدیل می‌کند.
  static String toEnglish(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final persianIndex = persianDigits.indexOf(char);
      if (persianIndex >= 0) {
        buffer.write(englishDigits[persianIndex]);
        continue;
      }
      final arabicIndex = arabicDigits.indexOf(char);
      if (arabicIndex >= 0) {
        buffer.write(englishDigits[arabicIndex]);
        continue;
      }
      buffer.write(char);
    }
    return buffer.toString();
  }

  /// عدد صحیح را با ارقام فارسی برمی‌گرداند.
  static String intToPersian(int value) => toPersian(value.toString());
}
