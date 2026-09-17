import 'persian_digit_formatter.dart';

/// فرمت و پارس مبالغ تومان برای نمایش فارسی.
abstract final class MoneyFormatter {
  static const String _thousandSeparator = '٬';
  static const String _suffix = 'تومان';

  /// مبلغ integer تومان را برای UI فرمت می‌کند.
  ///
  /// مثال: `3200000` → `۳٬۲۰۰٬۰۰۰ تومان`
  static String format(
    int amountToman, {
    bool withSuffix = true,
  }) {
    final absolute = amountToman.abs();
    final grouped = _groupThousands(absolute);
    final persian = PersianDigitFormatter.toPersian(grouped);
    final signed = amountToman < 0 ? '-$persian' : persian;
    if (!withSuffix) {
      return signed;
    }
    return '$signed $_suffix';
  }

  /// ورودی کاربر را به مبلغ تومان (integer) تبدیل می‌کند.
  ///
  /// اگر [millionShortcut] فعال باشد، `3200` به `3200000` تبدیل می‌شود
  /// (ورود بر حسب هزار تومان).
  static int parse(
    String input, {
    bool millionShortcut = false,
  }) {
    final english = PersianDigitFormatter.toEnglish(input);
    final digitsOnly = english.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return 0;
    }

    final value = int.parse(digitsOnly);
    if (!millionShortcut) {
      return value;
    }
    return value * 1000;
  }

  static String _groupThousands(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();
    var count = 0;
    for (var i = raw.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(_thousandSeparator);
      }
      buffer.write(raw[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }
}
