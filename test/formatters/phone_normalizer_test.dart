import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/phone_normalizer.dart';

void main() {
  group('PhoneNormalizer', () {
    test('فرمت‌های رایج را به 09 یکسان می‌کند', () {
      expect(PhoneNormalizer.normalize('09123456789'), '09123456789');
      expect(PhoneNormalizer.normalize('+989123456789'), '09123456789');
      expect(PhoneNormalizer.normalize('989123456789'), '09123456789');
      expect(PhoneNormalizer.normalize('00989123456789'), '09123456789');
      expect(PhoneNormalizer.normalize('9123456789'), '09123456789');
    });

    test('اعداد فارسی را می‌پذیرد', () {
      expect(PhoneNormalizer.normalize('۰۹۱۲۳۴۵۶۷۸۹'), '09123456789');
      expect(PhoneNormalizer.normalize('+۹۸۹۱۲۳۴۵۶۷۸۹'), '09123456789');
    });

    test('شماره با فاصله و خط تیره را مدیریت می‌کند', () {
      expect(PhoneNormalizer.normalize('0912 345 6789'), '09123456789');
      expect(PhoneNormalizer.normalize('0912-345-6789'), '09123456789');
    });

    test('نمایش فارسی برمی‌گرداند', () {
      expect(PhoneNormalizer.formatDisplay('09123456789'), '۰۹۱۲۳۴۵۶۷۸۹');
      expect(PhoneNormalizer.formatDisplay('+989123456789'), '۰۹۱۲۳۴۵۶۷۸۹');
    });

    test('فرمت بین‌المللی برای واتساپ می‌سازد', () {
      expect(PhoneNormalizer.toInternational('09123456789'), '989123456789');
      expect(PhoneNormalizer.toInternational('+989123456789'), '989123456789');
    });

    test('شماره نامعتبر null برمی‌گرداند', () {
      expect(PhoneNormalizer.normalize('123'), isNull);
      expect(PhoneNormalizer.normalize('08123456789'), isNull);
      expect(PhoneNormalizer.toInternational('abc'), isNull);
    });
  });
}
