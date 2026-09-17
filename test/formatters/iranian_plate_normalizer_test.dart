import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/iranian_plate_normalizer.dart';

void main() {
  group('IranianPlateNormalizer', () {
    test('از چهار بخش normalize و display می‌سازد', () {
      expect(
        IranianPlateNormalizer.normalizeParts(
          firstTwoDigits: '45',
          middleThreeDigits: '123',
          letter: 'ب',
          cityCode: '11',
        ),
        '45-B-123-11',
      );
      expect(
        IranianPlateNormalizer.formatDisplayParts(
          firstTwoDigits: '45',
          middleThreeDigits: '123',
          letter: 'ب',
          cityCode: '11',
        ),
        '۴۵ ب ۱۲۳ ایران ۱۱',
      );
    });

    test('نمونه استاندارد را نرمال و نمایش می‌دهد', () {
      const display = '۴۵ ب ۱۲۳ ایران ۱۱';
      expect(IranianPlateNormalizer.normalize(display), '45-B-123-11');
      expect(IranianPlateNormalizer.formatDisplay(display), display);
    });

    test('نمونه ۵۲ د ۶۸۹ ایران ۱۱', () {
      const display = '۵۲ د ۶۸۹ ایران ۱۱';
      expect(IranianPlateNormalizer.normalize(display), '52-D-689-11');
      expect(IranianPlateNormalizer.formatDisplay(display), display);
    });

    test('اعداد انگلیسی و بدون فاصله را مدیریت می‌کند', () {
      expect(IranianPlateNormalizer.normalize('45ب123ایران11'), '45-B-123-11');
      expect(IranianPlateNormalizer.normalize('45 B 123 11'), '45-B-123-11');
      expect(
        IranianPlateNormalizer.formatDisplay('45ب123ایران11'),
        '۴۵ ب ۱۲۳ ایران ۱۱',
      );
    });

    test('اعداد عربی و نیم‌فاصله را مدیریت می‌کند', () {
      expect(
        IranianPlateNormalizer.normalize('٤٥‌ب‌١٢٣ ایران ١١'),
        '45-B-123-11',
      );
    });

    test('فرمت نرمال‌شده جدید را می‌پذیرد', () {
      expect(IranianPlateNormalizer.normalize('45-B-123-11'), '45-B-123-11');
      expect(
        IranianPlateNormalizer.formatDisplay('45-B-123-11'),
        '۴۵ ب ۱۲۳ ایران ۱۱',
      );
    });

    test('فرمت قدیمی hyphenated را برای سازگاری می‌خواند', () {
      expect(IranianPlateNormalizer.normalize('11-123-B-45'), '45-B-123-11');
      expect(
        IranianPlateNormalizer.formatDisplay('11-123-B-45'),
        '۴۵ ب ۱۲۳ ایران ۱۱',
      );
    });

    test('حروف پلاک رایج را نگاشت می‌کند', () {
      expect(IranianPlateNormalizer.normalize('12ص34567'), '12-C-345-67');
      expect(
        IranianPlateNormalizer.formatDisplay('12ص34567'),
        '۱۲ ص ۳۴۵ ایران ۶۷',
      );
    });

    test('ورودی نامعتبر را رد می‌کند', () {
      expect(IranianPlateNormalizer.normalize('123'), '');
      expect(IranianPlateNormalizer.isValid('123'), isFalse);
      expect(IranianPlateNormalizer.isValid('۴۵ ب ۱۲۳ ایران ۱۱'), isTrue);
    });
  });
}
