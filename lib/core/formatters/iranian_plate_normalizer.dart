import 'persian_digit_formatter.dart';

/// نرمال‌سازی و نمایش پلاک ایرانی.
///
/// چیدمان بصری (چپ به راست): نوار آبی | دو رقم | حرف | سه رقم | ایران/کد شهر
/// نمایش: `۵۲ د ۶۸۹ ایران ۱۱`
/// کلید دیتابیس: `52-D-689-11`
abstract final class IranianPlateNormalizer {
  static const _letterToLatin = <String, String>{
    'آ': 'A',
    'ا': 'A',
    'ب': 'B',
    'پ': 'P',
    'ت': 'T',
    'ث': 'O',
    'ج': 'J',
    'د': 'D',
    'ز': 'Z',
    'س': 'S',
    'ش': 'X',
    'ص': 'C',
    'ط': 'Q',
    'ع': 'E',
    'ف': 'F',
    'ق': 'G',
    'ک': 'K',
    'گ': 'K',
    'ل': 'L',
    'م': 'M',
    'ن': 'N',
    'و': 'V',
    'ه': 'H',
    'ی': 'Y',
  };

  static const _latinToLetter = <String, String>{
    'A': 'ا',
    'B': 'ب',
    'P': 'پ',
    'T': 'ت',
    'O': 'ث',
    'J': 'ج',
    'D': 'د',
    'Z': 'ز',
    'S': 'س',
    'X': 'ش',
    'C': 'ص',
    'Q': 'ط',
    'E': 'ع',
    'F': 'ف',
    'G': 'ق',
    'K': 'ک',
    'L': 'ل',
    'M': 'م',
    'N': 'ن',
    'V': 'و',
    'H': 'ه',
    'Y': 'ی',
  };

  static const selectableLetters = <String>[
    'ب',
    'پ',
    'ت',
    'ث',
    'ج',
    'د',
    'ز',
    'س',
    'ش',
    'ص',
    'ط',
    'ع',
    'ف',
    'ق',
    'ک',
    'ل',
    'م',
    'ن',
    'و',
    'ه',
    'ی',
  ];

  /// ساخت کلید جستجو: `52-D-689-11`
  static String normalizeParts({
    required String firstTwoDigits,
    required String middleThreeDigits,
    required String letter,
    required String cityCode,
  }) {
    return normalize('$firstTwoDigits$letter$middleThreeDigits$cityCode');
  }

  /// نمایش فارسی: `۵۲ د ۶۸۹ ایران ۱۱`
  static String formatDisplayParts({
    required String firstTwoDigits,
    required String middleThreeDigits,
    required String letter,
    required String cityCode,
  }) {
    return formatDisplay('$firstTwoDigits$letter$middleThreeDigits$cityCode');
  }

  static String normalize(String input) {
    final parts = _parse(input);
    if (parts == null) {
      return '';
    }
    return _formatNormalized(parts);
  }

  static String formatDisplay(String input) {
    final parts = _parse(input);
    if (parts == null) {
      return input.trim();
    }

    final first = PersianDigitFormatter.toPersian(parts.firstTwoDigits);
    final middle = PersianDigitFormatter.toPersian(parts.middleThreeDigits);
    final city = PersianDigitFormatter.toPersian(parts.cityCode);
    return '$first ${parts.persianLetter} $middle ایران $city';
  }

  static bool isValid(String input) => _parse(input) != null;

  /// استخراج بخش‌های پلاک برای UI.
  static ({
    String firstTwoDigits,
    String letter,
    String middleThreeDigits,
    String cityCode,
  })? parseParts(String input) {
    final parts = _parse(input);
    if (parts == null) {
      return null;
    }
    return (
      firstTwoDigits: parts.firstTwoDigits,
      letter: parts.persianLetter,
      middleThreeDigits: parts.middleThreeDigits,
      cityCode: parts.cityCode,
    );
  }

  /// تبدیل هر فرمت ذخیره‌شده (قدیم/جدید) به کلید یکسان جدید.
  static String toCanonical(String normalized) {
    final parts = _parse(normalized);
    if (parts != null) {
      return _formatNormalized(parts);
    }

    final cleaned = _preprocess(normalized);
    final legacyMatch = _hyphenPattern.firstMatch(cleaned);
    if (legacyMatch != null) {
      final legacyParts = _partsFromLatin(
        firstTwoDigits: legacyMatch.group(4)!,
        middleThreeDigits: legacyMatch.group(2)!,
        latinLetter: legacyMatch.group(3)!,
        cityCode: legacyMatch.group(1)!,
      );
      if (legacyParts != null) {
        return _formatNormalized(legacyParts);
      }
    }
    return cleaned;
  }

  /// کلیدهای ممکن برای جستجو در دیتابیس (سازگاری با فرمت قدیمی).
  static List<String> lookupKeys(String normalizedOrDisplay) {
    final canonical = toCanonical(normalizedOrDisplay);
    final keys = <String>{normalizedOrDisplay.trim()};
    if (canonical.isNotEmpty) {
      keys.add(canonical);
      keys.add(_toLegacyKey(canonical));
    }
    return keys.where((key) => key.isNotEmpty).toList();
  }

  static final _hyphenPattern = RegExp(
    r'^(\d{2})-(\d{3})-([A-Za-z])-(\d{2})$',
  );

  static String _formatNormalized(_PlateParts parts) =>
      '${parts.firstTwoDigits}-${parts.latinLetter}-${parts.middleThreeDigits}-${parts.cityCode}';

  /// فرمت قدیمی: `11-123-B-45` (cityCode-middle-letter-firstTwoDigits)
  static String _toLegacyKey(String canonical) {
    final parts = _parse(canonical);
    if (parts == null) {
      return canonical;
    }
    return '${parts.cityCode}-${parts.middleThreeDigits}-${parts.latinLetter}-${parts.firstTwoDigits}';
  }

  static _PlateParts? _parse(String raw) {
    final cleaned = _preprocess(raw);
    if (cleaned.isEmpty) {
      return null;
    }

    final legacyMatch = _hyphenPattern.firstMatch(cleaned);
    if (legacyMatch != null) {
      final g1 = legacyMatch.group(1)!;
      final g2 = legacyMatch.group(2)!;
      final g3 = legacyMatch.group(3)!.toUpperCase();
      final g4 = legacyMatch.group(4)!;

      final asNew = _partsFromLatin(
        firstTwoDigits: g1,
        middleThreeDigits: g2,
        latinLetter: g3,
        cityCode: g4,
      );
      final asLegacy = _partsFromLatin(
        firstTwoDigits: g4,
        middleThreeDigits: g2,
        latinLetter: g3,
        cityCode: g1,
      );

      if (asNew != null && _formatNormalized(asNew) == cleaned) {
        return asNew;
      }
      if (asLegacy != null &&
          _toLegacyKey(_formatNormalized(asLegacy)) == cleaned) {
        return asLegacy;
      }
      return asNew ?? asLegacy;
    }

    final compact = cleaned
        .replaceAll('ایران', '')
        .replaceAll(RegExp(r'[\s\-ـ_]'), '');

    final freeform = RegExp(
      r'^(\d{2})([A-Za-z\u0600-\u06FF])(\d{3})(\d{2})$',
    ).firstMatch(compact);
    if (freeform == null) {
      return null;
    }

    final letterRaw = freeform.group(2)!;
    final mapped = _mapLetter(letterRaw);
    if (mapped == null) {
      return null;
    }

    return _PlateParts(
      firstTwoDigits: freeform.group(1)!,
      persianLetter: mapped.persian,
      latinLetter: mapped.latin,
      middleThreeDigits: freeform.group(3)!,
      cityCode: freeform.group(4)!,
    );
  }

  static _PlateParts? _partsFromLatin({
    required String firstTwoDigits,
    required String middleThreeDigits,
    required String latinLetter,
    required String cityCode,
  }) {
    final persianLetter = _latinToLetter[latinLetter.toUpperCase()];
    if (persianLetter == null) {
      return null;
    }
    if (firstTwoDigits.length != 2 ||
        middleThreeDigits.length != 3 ||
        cityCode.length != 2) {
      return null;
    }
    return _PlateParts(
      firstTwoDigits: firstTwoDigits,
      persianLetter: persianLetter,
      latinLetter: latinLetter.toUpperCase(),
      middleThreeDigits: middleThreeDigits,
      cityCode: cityCode,
    );
  }

  static String _preprocess(String input) {
    var value = PersianDigitFormatter.toEnglish(input).trim();
    value = value
        .replaceAll('\u200c', ' ')
        .replaceAll('\u200f', '')
        .replaceAll('\u200e', '')
        .replaceAll('ي', 'ی')
        .replaceAll('ى', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ـ', '-')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return value;
  }

  static ({String persian, String latin})? _mapLetter(String letter) {
    final upper = letter.toUpperCase();
    if (_latinToLetter.containsKey(upper)) {
      return (persian: _latinToLetter[upper]!, latin: upper);
    }
    if (_letterToLatin.containsKey(letter)) {
      return (persian: letter, latin: _letterToLatin[letter]!);
    }
    return null;
  }
}

class _PlateParts {
  const _PlateParts({
    required this.firstTwoDigits,
    required this.persianLetter,
    required this.latinLetter,
    required this.middleThreeDigits,
    required this.cityCode,
  });

  final String firstTwoDigits;
  final String persianLetter;
  final String latinLetter;
  final String middleThreeDigits;
  final String cityCode;
}
