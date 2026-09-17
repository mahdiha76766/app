import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/jalali_date_formatter.dart';

void main() {
  group('JalaliDateFormatter', () {
    // 2026-07-20 ≈ 1405/04/29
    final date = DateTime(2026, 7, 20, 14, 30);

    test('تاریخ فشرده شمسی با ارقام فارسی برمی‌گرداند', () {
      expect(JalaliDateFormatter.format(date), '۱۴۰۵/۰۴/۲۹');
    });

    test('تاریخ بلند شمسی برمی‌گرداند', () {
      expect(JalaliDateFormatter.formatLong(date), '۲۹ تیر ۱۴۰۵');
    });

    test('تاریخ همراه ساعت فارسی برمی‌گرداند', () {
      expect(JalaliDateFormatter.formatWithTime(date), '۱۴۰۵/۰۴/۲۹ - ۱۴:۳۰');
    });
  });
}
