import '../../../../core/formatters/iranian_plate_normalizer.dart';

/// تنظیمات پلاک شخصی ایرانی.
abstract final class IranianPlateConfig {
  static const allowedLetters = IranianPlateNormalizer.selectableLetters;

  static bool isAllowedLetter(String letter) =>
      allowedLetters.contains(letter);

  static bool isValidParts({
    required String firstTwoDigits,
    required String letter,
    required String middleThreeDigits,
    required String cityCode,
  }) {
    if (firstTwoDigits.length != 2 || !_isDigits(firstTwoDigits)) {
      return false;
    }
    if (middleThreeDigits.length != 3 || !_isDigits(middleThreeDigits)) {
      return false;
    }
    if (cityCode.length != 2 || !_isDigits(cityCode)) {
      return false;
    }
    if (!isAllowedLetter(letter)) {
      return false;
    }
    return IranianPlateNormalizer.isValid(
      '$firstTwoDigits$letter$middleThreeDigits$cityCode',
    );
  }

  static bool _isDigits(String value) =>
      RegExp(r'^\d{1,3}$').hasMatch(value);
}
