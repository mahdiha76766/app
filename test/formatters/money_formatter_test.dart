import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/money_formatter.dart';

void main() {
  group('MoneyFormatter', () {
    test('مبلغ را با جداکننده هزارگان فارسی فرمت می‌کند', () {
      expect(MoneyFormatter.format(3200000), '۳٬۲۰۰٬۰۰۰ تومان');
      expect(MoneyFormatter.format(0), '۰ تومان');
      expect(MoneyFormatter.format(500), '۵۰۰ تومان');
      expect(MoneyFormatter.format(1000), '۱٬۰۰۰ تومان');
    });

    test('فرمت بدون پسوند تومان', () {
      expect(
        MoneyFormatter.format(3200000, withSuffix: false),
        '۳٬۲۰۰٬۰۰۰',
      );
    });

    test('اعداد منفی را پشتیبانی می‌کند', () {
      expect(MoneyFormatter.format(-1500), '-۱٬۵۰۰ تومان');
    });

    test('ورودی فارسی و انگلیسی را پارس می‌کند', () {
      expect(MoneyFormatter.parse('3200000'), 3200000);
      expect(MoneyFormatter.parse('۳۲۰۰۰۰۰'), 3200000);
      expect(MoneyFormatter.parse('۳٬۲۰۰٬۰۰۰ تومان'), 3200000);
      expect(MoneyFormatter.parse('3,200,000'), 3200000);
    });

    test('millionShortcut مقدار را در ۱۰۰۰ ضرب می‌کند', () {
      expect(MoneyFormatter.parse('3200', millionShortcut: true), 3200000);
      expect(MoneyFormatter.parse('۳۲۰۰', millionShortcut: true), 3200000);
      expect(MoneyFormatter.parse('1', millionShortcut: true), 1000);
    });

    test('ورودی خالی صفر برمی‌گرداند', () {
      expect(MoneyFormatter.parse(''), 0);
      expect(MoneyFormatter.parse('تومان'), 0);
    });
  });
}
