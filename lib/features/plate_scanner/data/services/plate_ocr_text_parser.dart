import '../../../../core/formatters/iranian_plate_normalizer.dart';
import '../../../../core/formatters/persian_digit_formatter.dart';
import '../../domain/config/iranian_plate_config.dart';
import '../../domain/entities/iranian_plate_parts.dart';

/// پارس و نرمال‌سازی خروجی OCR برای پلاک ایرانی.
abstract final class PlateOcrTextParser {
  static const _commonLetterConfusions = <String, String>{
    'ذ': 'د',
    'ر': 'ز',
    'ة': 'ه',
    'ؤ': 'و',
    'إ': 'ا',
    'أ': 'ا',
    'آ': 'ا',
    'ك': 'ک',
    'ي': 'ی',
    'ى': 'ی',
    'O': 'ث',
    'o': 'ث',
    '0': 'ث',
  };

  /// نرمال‌سازی متن خام OCR.
  static String normalizeRaw(String raw) {
    var value = PersianDigitFormatter.toEnglish(raw);
    value = value
        .replaceAll('\u200c', '')
        .replaceAll('\u200f', '')
        .replaceAll('\u200e', '')
        .replaceAll('ایران', '')
        .replaceAll('IRAN', '')
        .replaceAll(RegExp(r'[\s\-ـ_\n\r\t|/\\.,:;]+'), '')
        .trim();
    return value;
  }

  /// استخراج فقط ارقام.
  static String digitsOnly(String raw) {
    final normalized = normalizeRaw(raw);
    final buffer = StringBuffer();
    for (final char in normalized.split('')) {
      if (RegExp(r'^\d$').hasMatch(char)) {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  /// استخراج حرف مجاز پلاک.
  static String? parseLetter(String raw) {
    final cleaned = normalizeRaw(raw);
    if (cleaned.isEmpty) {
      return null;
    }

    for (final char in cleaned.split('')) {
      final mapped = _commonLetterConfusions[char] ?? char;
      if (IranianPlateConfig.isAllowedLetter(mapped)) {
        return mapped;
      }
      if (RegExp(r'^[A-Za-z]$').hasMatch(char)) {
        final parsed = IranianPlateNormalizer.parseParts('12${char.toUpperCase()}34511');
        if (parsed != null) {
          return parsed.letter;
        }
      }
    }

    for (final entry in _commonLetterConfusions.entries) {
      if (cleaned.contains(entry.key)) {
        final mapped = entry.value;
        if (IranianPlateConfig.isAllowedLetter(mapped)) {
          return mapped;
        }
      }
    }

    return null;
  }

  /// ساخت پلاک از بخش‌های جداگانه.
  static IranianPlateParts? fromSegments({
    required String firstTwoDigits,
    required String letter,
    required String middleThreeDigits,
    required String cityCode,
  }) {
    final first = _fixedDigits(firstTwoDigits, 2);
    final middle = _fixedDigits(middleThreeDigits, 3);
    final city = _fixedDigits(cityCode, 2);
    final parsedLetter = parseLetter(letter);

    if (first == null ||
        middle == null ||
        city == null ||
        parsedLetter == null) {
      return null;
    }

    final parts = IranianPlateParts(
      firstTwoDigits: first,
      letter: parsedLetter,
      middleThreeDigits: middle,
      cityCode: city,
    );

    if (!IranianPlateConfig.isValidParts(
      firstTwoDigits: parts.firstTwoDigits,
      letter: parts.letter,
      middleThreeDigits: parts.middleThreeDigits,
      cityCode: parts.cityCode,
    )) {
      return null;
    }
    return parts;
  }

  /// پارس یک رشته آزاد OCR.
  static IranianPlateParts? parseFreeform(String raw) {
    final normalized = normalizeRaw(raw);
    final parsed = IranianPlateNormalizer.parseParts(normalized);
    if (parsed == null) {
      return null;
    }
    return IranianPlateParts(
      firstTwoDigits: parsed.firstTwoDigits,
      letter: parsed.letter,
      middleThreeDigits: parsed.middleThreeDigits,
      cityCode: parsed.cityCode,
    );
  }

  static String? _fixedDigits(String raw, int length) {
    final digits = digitsOnly(raw);
    if (digits.length < length) {
      return null;
    }
    return digits.substring(0, length);
  }
}
