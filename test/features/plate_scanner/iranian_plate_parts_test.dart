import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/config/iranian_plate_config.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/iranian_plate_parts.dart';

void main() {
  group('IranianPlateParts', () {
    test('نمایش فارسی و normalized درست است', () {
      const parts = IranianPlateParts(
        firstTwoDigits: '12',
        letter: 'ب',
        middleThreeDigits: '345',
        cityCode: '67',
      );

      expect(parts.display, '۱۲ ب ۳۴۵ ایران ۶۷');
      expect(parts.normalized, '12-B-345-67');
      expect(parts.isComplete, isTrue);
    });

    test('config حروف نامعتبر را رد می‌کند', () {
      expect(
        IranianPlateConfig.isValidParts(
          firstTwoDigits: '12',
          letter: 'آ',
          middleThreeDigits: '345',
          cityCode: '67',
        ),
        isFalse,
      );
    });
  });
}
