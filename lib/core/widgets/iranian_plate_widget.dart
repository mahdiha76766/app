import 'package:flutter/material.dart';

import '../formatters/iranian_plate_normalizer.dart';
import '../formatters/persian_digit_formatter.dart';
import '../theme_constants.dart';

/// مقدار چهاربخشی پلاک ایرانی.
class IranianPlateValue {
  factory IranianPlateValue.fromAny(String input) {
    final parts = IranianPlateNormalizer.parseParts(input);
    if (parts == null) {
      return const IranianPlateValue();
    }
    return IranianPlateValue(
      firstTwoDigits: parts.firstTwoDigits,
      letter: parts.letter,
      middleThreeDigits: parts.middleThreeDigits,
      cityCode: parts.cityCode,
    );
  }

  const IranianPlateValue({
    this.firstTwoDigits = '',
    this.letter = '',
    this.middleThreeDigits = '',
    this.cityCode = '',
  });

  final String firstTwoDigits;
  final String letter;
  final String middleThreeDigits;
  final String cityCode;

  bool get isComplete =>
      firstTwoDigits.length == 2 &&
      middleThreeDigits.length == 3 &&
      letter.isNotEmpty &&
      cityCode.length == 2;

  String get rawCompact =>
      '$firstTwoDigits$letter$middleThreeDigits$cityCode';

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

  IranianPlateValue copyWith({
    String? firstTwoDigits,
    String? letter,
    String? middleThreeDigits,
    String? cityCode,
  }) {
    return IranianPlateValue(
      firstTwoDigits: firstTwoDigits ?? this.firstTwoDigits,
      letter: letter ?? this.letter,
      middleThreeDigits: middleThreeDigits ?? this.middleThreeDigits,
      cityCode: cityCode ?? this.cityCode,
    );
  }
}

/// نمایش ثابت LTR پلاک — مستقل از RTL کل برنامه.
class IranianPlateWidget extends StatelessWidget {
  const IranianPlateWidget({
    super.key,
    required this.value,
    this.compact = false,
    this.onFirstTwoDigitsTap,
    this.onLetterTap,
    this.onMiddleThreeDigitsTap,
    this.onCityCodeTap,
  });

  final IranianPlateValue value;
  final bool compact;

  final VoidCallback? onFirstTwoDigitsTap;
  final VoidCallback? onLetterTap;
  final VoidCallback? onMiddleThreeDigitsTap;
  final VoidCallback? onCityCodeTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? 6 : 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1B1B1B), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _BlueStrip(key: Key('plate_blue_strip')),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: _PlateDigitSegment(
                key: const Key('plate_first_two_digits'),
                label: '۲ رقم',
                value: value.firstTwoDigits,
                maxLength: 2,
                onTap: onFirstTwoDigitsTap,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: _PlateLetterSegment(
                key: const Key('plate_letter'),
                value: value.letter,
                onTap: onLetterTap,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: _PlateDigitSegment(
                key: const Key('plate_middle_three_digits'),
                label: '۳ رقم',
                value: value.middleThreeDigits,
                maxLength: 3,
                onTap: onMiddleThreeDigitsTap,
              ),
            ),
            const SizedBox(width: 6),
            _CityCodePanel(
              key: const Key('plate_city_code_panel'),
              cityCode: value.cityCode,
              compact: compact,
              onTap: onCityCodeTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// نمایش LTR پلاک در صفحات RTL — ویجت واقعی یا متن ثابت.
class PlateDisplayLtr extends StatelessWidget {
  const PlateDisplayLtr({
    super.key,
    required this.plateDisplay,
    this.plateNormalized,
    this.style,
    this.compact = false,
  });

  final String plateDisplay;
  final String? plateNormalized;
  final TextStyle? style;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final parsed = IranianPlateValue.fromAny(
      plateNormalized ?? plateDisplay,
    );
    if (parsed.isComplete) {
      return IranianPlateWidget(value: parsed, compact: compact);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(
        plateDisplay,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _BlueStrip extends StatelessWidget {
  const _BlueStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: AppTapTargets.plateSegment,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF0B3D91),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'I.R.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'IRAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityCodePanel extends StatelessWidget {
  const _CityCodePanel({
    super.key,
    required this.cityCode,
    this.compact = false,
    this.onTap,
  });

  final String cityCode;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Container(
      width: compact ? 50 : 56,
      height: AppTapTargets.plateSegment,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ایران',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: compact ? 10 : 11,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              cityCode.isEmpty
                  ? '– –'
                  : PersianDigitFormatter.toPersian(cityCode),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                fontSize: compact ? 16 : null,
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
    );
  }
}

class _PlateDigitSegment extends StatelessWidget {
  const _PlateDigitSegment({
    super.key,
    required this.label,
    required this.value,
    required this.maxLength,
    this.onTap,
  });

  final String label;
  final String value;
  final int maxLength;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.isEmpty
                ? List.filled(maxLength, '–').join()
                : PersianDigitFormatter.toPersian(value),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ],
        ],
      ),
    );

    return SizedBox(
      height: AppTapTargets.plateSegment,
      child: onTap == null
          ? child
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: child,
              ),
            ),
    );
  }
}

class _PlateLetterSegment extends StatelessWidget {
  const _PlateLetterSegment({
    super.key,
    required this.value,
    this.onTap,
  });

  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFBDBDBD)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value.isEmpty ? 'حرف' : value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: value.isEmpty
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.45)
                      : theme.colorScheme.onSurface,
                ),
              ),
              if (onTap != null)
                Text(
                  'انتخاب',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      height: AppTapTargets.plateSegment,
      child: onTap == null
          ? child
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10),
                child: child,
              ),
            ),
    );
  }
}
