import 'package:shamsi_date/shamsi_date.dart';

import 'persian_digit_formatter.dart';

/// تبدیل DateTime میلادی به متن تاریخ شمسی برای UI.
abstract final class JalaliDateFormatter {
  static const _monthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  /// فرمت فشرده: `۱۴۰۵/۰۴/۲۹`
  static String format(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime.toLocal());
    final raw =
        '${jalali.year.toString().padLeft(4, '0')}/'
        '${jalali.month.toString().padLeft(2, '0')}/'
        '${jalali.day.toString().padLeft(2, '0')}';
    return PersianDigitFormatter.toPersian(raw);
  }

  /// فرمت بلند: `۲۹ تیر ۱۴۰۵`
  static String formatLong(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime.toLocal());
    final day = PersianDigitFormatter.intToPersian(jalali.day);
    final month = _monthNames[jalali.month - 1];
    final year = PersianDigitFormatter.intToPersian(jalali.year);
    return '$day $month $year';
  }

  /// ساعت: `۱۴:۳۰`
  static String formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return PersianDigitFormatter.toPersian('$hour:$minute');
  }

  static const _weekdayNames = <String>[
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];

  /// روز هفته شمسی: `سه‌شنبه`
  static String formatWeekday(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime.toLocal());
    return _weekdayNames[jalali.weekDay - 1];
  }

  /// تاریخ و ساعت: `۱۴۰۵/۰۴/۲۹ - ۱۴:۳۰`
  static String formatWithTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final date = format(local);
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final time = PersianDigitFormatter.toPersian('$hour:$minute');
    return '$date - $time';
  }
}
