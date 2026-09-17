import 'persian_digit_formatter.dart';

/// یکسان‌سازی شماره موبایل ایران برای ذخیره و نمایش.
///
/// خروجی استاندارد ذخیره‌سازی: `09123456789`
abstract final class PhoneNormalizer {
  /// شماره را به فرمت `09xxxxxxxxx` تبدیل می‌کند.
  /// اگر معتبر نباشد `null` برمی‌گرداند.
  static String? normalize(String input) {
    final english = PersianDigitFormatter.toEnglish(input).trim();
    var digits = english.replaceAll(RegExp(r'[^\d+]'), '');

    if (digits.startsWith('+')) {
      digits = digits.substring(1);
    }

    if (digits.startsWith('0098')) {
      digits = digits.substring(4);
    } else if (digits.startsWith('098')) {
      digits = digits.substring(3);
    } else if (digits.startsWith('98')) {
      digits = digits.substring(2);
    }

    if (digits.startsWith('9') && digits.length == 10) {
      digits = '0$digits';
    }

    if (!RegExp(r'^09\d{9}$').hasMatch(digits)) {
      return null;
    }
    return digits;
  }

  /// نمایش فارسی شماره نرمال‌شده.
  ///
  /// مثال: `۰۹۱۲۳۴۵۶۷۸۹`
  static String formatDisplay(String input) {
    final normalized = normalize(input);
    if (normalized == null) {
      return PersianDigitFormatter.toPersian(input.trim());
    }
    return PersianDigitFormatter.toPersian(normalized);
  }

  /// فرمت بین‌المللی برای واتساپ و لینک‌ها: `989123456789`
  static String? toInternational(String input) {
    final normalized = normalize(input);
    if (normalized == null) {
      return null;
    }
    return '98${normalized.substring(1)}';
  }
}
