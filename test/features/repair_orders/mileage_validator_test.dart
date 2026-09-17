import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/services/mileage_validator.dart';

void main() {
  group('MileageValidator', () {
    test('computes delta and flags decrease', () {
      final preview = MileageValidator.preview(
        previousMileage: 120000,
        newMileage: 121500,
      );
      expect(preview.delta, 1500);
      expect(preview.isDecrease, isFalse);

      final lower = MileageValidator.preview(
        previousMileage: 120000,
        newMileage: 119000,
      );
      expect(lower.isDecrease, isTrue);
      expect(lower.delta, -1000);
    });

    test('rejects decrease without allowDecrease', () {
      expect(
        () => MileageValidator.ensureAllowed(
          previousMileage: 100,
          newMileage: 90,
          allowDecrease: false,
        ),
        throwsA(isA<MileageValidationException>()),
      );
    });

    test('allows decrease with explicit confirmation flag', () {
      expect(
        () => MileageValidator.ensureAllowed(
          previousMileage: 100,
          newMileage: 90,
          allowDecrease: true,
        ),
        returnsNormally,
      );
    });
  });
}
