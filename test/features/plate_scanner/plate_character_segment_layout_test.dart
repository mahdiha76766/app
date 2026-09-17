import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/plate_character_segment_layout.dart';

void main() {
  group('PlateCharacterSegmentLayout', () {
    test('city code segments are on the right side', () {
      const w = 280;
      const h = 64;

      final city1 = PlateCharacterSegmentLayout.cityDigit1Rect(w, h);
      final city2 = PlateCharacterSegmentLayout.cityDigit2Rect(w, h);
      final letter = PlateCharacterSegmentLayout.letterRect(w, h);

      expect(city1.left, greaterThan(letter.right));
      expect(city2.left, greaterThan(city1.left));
      expect(city2.right, greaterThan(city1.right));
    });
  });
}
