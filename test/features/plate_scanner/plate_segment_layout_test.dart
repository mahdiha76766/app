import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/plate_segment_layout.dart';

void main() {
  group('PlateSegmentLayout', () {
    const width = 400;
    const height = 100;

    test('نوار آبی وارد OCR نمی‌شود', () {
      final first = PlateSegmentLayout.firstTwoDigitsRect(width, height);
      expect(first.left, greaterThanOrEqualTo(width * PlateSegmentLayout.blueStripRatio));
    });

    test('کد شهر در پایین پنل راست قرار دارد', () {
      final city = PlateSegmentLayout.cityCodeRect(width, height);
      expect(city.left, greaterThan(width * 0.65));
      expect(city.top, greaterThan(height * 0.4));
    });

    test('rect نامعتبر رد می‌شود', () {
      expect(
        PlateSegmentLayout.isValidSegment(
          PlateSegmentLayout.firstTwoDigitsRect(0, 0),
          0,
          0,
        ),
        isFalse,
      );
    });

    test('بخش‌ها داخل تصویر هستند', () {
      for (final rect in [
        PlateSegmentLayout.firstTwoDigitsRect(width, height),
        PlateSegmentLayout.letterRect(width, height),
        PlateSegmentLayout.middleThreeDigitsRect(width, height),
        PlateSegmentLayout.cityCodeRect(width, height),
      ]) {
        expect(PlateSegmentLayout.isValidSegment(rect, width, height), isTrue);
        expect(rect.right, lessThanOrEqualTo(width));
        expect(rect.bottom, lessThanOrEqualTo(height));
      }
    });
  });
}
