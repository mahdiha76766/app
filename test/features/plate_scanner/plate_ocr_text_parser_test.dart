import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/plate_ocr_text_parser.dart';

void main() {
  group('PlateOcrTextParser', () {
    test('normalize اعداد فارسی', () {
      expect(
        PlateOcrTextParser.digitsOnly('۵۲'),
        '52',
      );
    });

    test('حذف نوشته ایران از OCR', () {
      expect(
        PlateOcrTextParser.normalizeRaw('۵۲ د ۶۸۹ ایران ۱۱'),
        '52د68911',
      );
    });

    test('ساختار صحیح پلاک', () {
      final parts = PlateOcrTextParser.fromSegments(
        firstTwoDigits: '52',
        letter: 'د',
        middleThreeDigits: '689',
        cityCode: '11',
      );

      expect(parts, isNotNull);
      expect(parts!.display, contains('۵۲'));
      expect(parts.normalized, '52-D-689-11');
    });

    test('candidate نامعتبر رد می‌شود', () {
      final parts = PlateOcrTextParser.fromSegments(
        firstTwoDigits: '5',
        letter: 'د',
        middleThreeDigits: '689',
        cityCode: '11',
      );
      expect(parts, isNull);
    });

    test('parseFreeform پلاک معتبر', () {
      final parts = PlateOcrTextParser.parseFreeform('52د68911');
      expect(parts?.firstTwoDigits, '52');
      expect(parts?.letter, 'د');
      expect(parts?.middleThreeDigits, '689');
      expect(parts?.cityCode, '11');
    });

    test('parseLetter حروف مجاز', () {
      expect(PlateOcrTextParser.parseLetter('د'), 'د');
      expect(PlateOcrTextParser.parseLetter('D'), 'د');
    });
  });
}
