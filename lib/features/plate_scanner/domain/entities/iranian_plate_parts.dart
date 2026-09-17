import '../../../../core/formatters/iranian_plate_normalizer.dart';
import '../../../../core/widgets/iranian_plate_input.dart';

/// بخش‌های ساختاریافته پلاک شخصی ایرانی.
class IranianPlateParts {
  const IranianPlateParts({
    required this.firstTwoDigits,
    required this.letter,
    required this.middleThreeDigits,
    required this.cityCode,
  });

  final String firstTwoDigits;
  final String letter;
  final String middleThreeDigits;
  final String cityCode;

  bool get isComplete =>
      firstTwoDigits.length == 2 &&
      letter.isNotEmpty &&
      middleThreeDigits.length == 3 &&
      cityCode.length == 2;

  String get normalized => IranianPlateNormalizer.normalizeParts(
        firstTwoDigits: firstTwoDigits,
        middleThreeDigits: middleThreeDigits,
        letter: letter,
        cityCode: cityCode,
      );

  String get display => IranianPlateNormalizer.formatDisplayParts(
        firstTwoDigits: firstTwoDigits,
        middleThreeDigits: middleThreeDigits,
        letter: letter,
        cityCode: cityCode,
      );

  String get rawCompact =>
      '$firstTwoDigits$letter$middleThreeDigits$cityCode';

  IranianPlateValue toPlateValue() => IranianPlateValue(
        firstTwoDigits: firstTwoDigits,
        middleThreeDigits: middleThreeDigits,
        letter: letter,
        cityCode: cityCode,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IranianPlateParts &&
          firstTwoDigits == other.firstTwoDigits &&
          letter == other.letter &&
          middleThreeDigits == other.middleThreeDigits &&
          cityCode == other.cityCode;

  @override
  int get hashCode => Object.hash(
        firstTwoDigits,
        letter,
        middleThreeDigits,
        cityCode,
      );
}
