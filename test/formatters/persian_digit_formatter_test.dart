import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/persian_digit_formatter.dart';

void main() {
  group('PersianDigitFormatter', () {
    test('انگلیسی را به فارسی تبدیل می‌کند', () {
      expect(PersianDigitFormatter.toPersian('2026'), '۲۰۲۶');
      expect(PersianDigitFormatter.toPersian('12b34'), '۱۲b۳۴');
    });

    test('عربی را به فارسی تبدیل می‌کند', () {
      expect(PersianDigitFormatter.toPersian('٢٠٢٦'), '۲۰۲۶');
    });

    test('فارسی و عربی را به انگلیسی تبدیل می‌کند', () {
      expect(PersianDigitFormatter.toEnglish('۲۰۲۶'), '2026');
      expect(PersianDigitFormatter.toEnglish('٢٠٢٦'), '2026');
      expect(PersianDigitFormatter.toEnglish('۱۲ب۳۴'), '12ب34');
    });

    test('متن بدون رقم را بدون تغییر نگه می‌دارد', () {
      expect(PersianDigitFormatter.toPersian('تومان'), 'تومان');
      expect(PersianDigitFormatter.toEnglish('تومان'), 'تومان');
    });

    test('intToPersian عدد صحیح را فارسی می‌کند', () {
      expect(PersianDigitFormatter.intToPersian(3200000), '۳۲۰۰۰۰۰');
      expect(PersianDigitFormatter.intToPersian(0), '۰');
    });
  });
}
