class MileageValidationException implements Exception {
  MileageValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

class MileageChangePreview {
  const MileageChangePreview({
    required this.previousMileage,
    required this.newMileage,
    required this.delta,
    required this.isDecrease,
  });

  final int? previousMileage;
  final int newMileage;
  final int? delta;
  final bool isDecrease;
}

abstract final class MileageValidator {
  static MileageChangePreview preview({
    required int? previousMileage,
    required int newMileage,
  }) {
    if (newMileage < 0) {
      throw MileageValidationException('کارکرد نمی‌تواند منفی باشد.');
    }
    final prev = previousMileage;
    if (prev == null) {
      return MileageChangePreview(
        previousMileage: null,
        newMileage: newMileage,
        delta: null,
        isDecrease: false,
      );
    }
    return MileageChangePreview(
      previousMileage: prev,
      newMileage: newMileage,
      delta: newMileage - prev,
      isDecrease: newMileage < prev,
    );
  }

  static void ensureAllowed({
    required int? previousMileage,
    required int newMileage,
    required bool allowDecrease,
  }) {
    final p = preview(
      previousMileage: previousMileage,
      newMileage: newMileage,
    );
    if (p.isDecrease && !allowDecrease) {
      throw MileageValidationException(
        'کارکرد جدید کمتر از آخرین کارکرد است. برای ثبت باید تأیید کنید.',
      );
    }
  }
}
