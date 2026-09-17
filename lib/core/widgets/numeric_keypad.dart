import 'package:flutter/material.dart';

import '../formatters/persian_digit_formatter.dart';
import '../theme_constants.dart';

/// صفحه‌کلید عددی بزرگ داخل اپ برای ورود اعداد.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onClear,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback? onClear;

  static const _digits = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in _digits) ...[
          Row(
            children: [
              for (final digit in row)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: _KeypadButton(
                      onPressed: () => onDigit(digit),
                      child: Text(
                        PersianDigitFormatter.toPersian(digit),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _KeypadButton(
                  onPressed: onClear,
                  child: Text(
                    'پاک',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _KeypadButton(
                  onPressed: () => onDigit('0'),
                  child: Text(
                    PersianDigitFormatter.toPersian('0'),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _KeypadButton(
                  onPressed: onBackspace,
                  child: const Icon(Icons.backspace_outlined, size: 28),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.child,
    this.onPressed,
  });

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: AppTapTargets.large,
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.45),
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// باز کردن صفحه‌کلید عددی در bottom sheet و برگرداندن مقدار نهایی.
Future<String?> showNumericKeypadSheet({
  required BuildContext context,
  required String title,
  required int maxLength,
  String initialValue = '',
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _NumericKeypadSheet(
        title: title,
        maxLength: maxLength,
        initialValue: initialValue,
      );
    },
  );
}

class _NumericKeypadSheet extends StatefulWidget {
  const _NumericKeypadSheet({
    required this.title,
    required this.maxLength,
    required this.initialValue,
  });

  final String title;
  final int maxLength;
  final String initialValue;

  @override
  State<_NumericKeypadSheet> createState() => _NumericKeypadSheetState();
}

class _NumericKeypadSheetState extends State<_NumericKeypadSheet> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = PersianDigitFormatter.toEnglish(widget.initialValue)
        .replaceAll(RegExp(r'[^0-9]'), '');
  }

  void _append(String digit) {
    if (_value.length >= widget.maxLength) {
      return;
    }
    setState(() => _value = '$_value$digit');
    if (_value.length >= widget.maxLength) {
      Navigator.of(context).pop(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Container(
            height: AppTapTargets.large,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Text(
              _value.isEmpty
                  ? '—'
                  : PersianDigitFormatter.toPersian(_value),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          NumericKeypad(
            onDigit: _append,
            onBackspace: () {
              if (_value.isEmpty) {
                return;
              }
              setState(() => _value = _value.substring(0, _value.length - 1));
            },
            onClear: () => setState(() => _value = ''),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_value),
            child: const Text('تأیید'),
          ),
        ],
      ),
    );
  }
}
