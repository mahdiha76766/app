import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../formatters/money_formatter.dart';
import '../formatters/persian_digit_formatter.dart';
import '../theme_constants.dart';
import 'price_keypad_logic.dart';

/// باز کردن صفحه‌کلید حرفه‌ای قیمت و برگرداندن مبلغ تومان.
///
/// [lastPrice] فقط نمایش داده می‌شود و بدون لمس «همان قیمت قبلی»
/// به‌صورت خودکار اعمال نمی‌شود.
Future<int?> showPriceKeypadBottomSheet({
  required BuildContext context,
  required String partTitle,
  String? vehicleModel,
  int? lastPrice,
  int? initialAmount,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return PriceKeypadBottomSheet(
        partTitle: partTitle,
        vehicleModel: vehicleModel,
        lastPrice: lastPrice,
        initialAmount: initialAmount,
      );
    },
  );
}

/// Bottom sheet ورود قیمت با صفحه‌کلید داخل‌اپ (بدون کیبورد سیستم).
class PriceKeypadBottomSheet extends StatefulWidget {
  const PriceKeypadBottomSheet({
    super.key,
    required this.partTitle,
    this.vehicleModel,
    this.lastPrice,
    this.initialAmount,
    this.logic,
    this.enableHaptics = true,
  });

  final String partTitle;
  final String? vehicleModel;
  final int? lastPrice;
  final int? initialAmount;

  /// برای تست؛ در حالت عادی ساخته می‌شود.
  final PriceKeypadLogic? logic;
  final bool enableHaptics;

  @override
  State<PriceKeypadBottomSheet> createState() => _PriceKeypadBottomSheetState();
}

class _PriceKeypadBottomSheetState extends State<PriceKeypadBottomSheet> {
  late final PriceKeypadLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = widget.logic ??
        PriceKeypadLogic(
          lastPrice: widget.lastPrice,
          initialAmount: widget.initialAmount,
        );
  }

  void _haptic() {
    if (!widget.enableHaptics) {
      return;
    }
    HapticFeedback.lightImpact();
  }

  void _mutate(VoidCallback action) {
    setState(action);
  }

  Future<void> _onConfirm() async {
    if (!_logic.canConfirm) {
      return;
    }
    if (_logic.needsLargeAmountConfirmation) {
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('تأیید مبلغ بالا'),
            content: Text(
              'مبلغ ${MoneyFormatter.format(_logic.amount)} بسیار بالاست.\n'
              'آیا از ثبت آن مطمئن هستید؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('انصراف'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('بله، ثبت شود'),
              ),
            ],
          );
        },
      );
      if (accepted != true || !mounted) {
        return;
      }
    }
    Navigator.of(context).pop(_logic.amount);
  }

  String get _headerTitle {
    final model = widget.vehicleModel?.trim();
    if (model == null || model.isEmpty) {
      return widget.partTitle;
    }
    return '${widget.partTitle} - $model';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final amount = _logic.amount;
    final isThousand = _logic.mode == PriceInputMode.thousandToman;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 16 + bottom),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _headerTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _logic.hasLastPrice
                    ? 'آخرین بار:\n${MoneyFormatter.format(_logic.lastPrice!)}'
                    : 'آخرین بار:\nثبت نشده',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                amount <= 0 ? '—' : MoneyFormatter.format(amount),
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 36,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isThousand
                    ? (_logic.digits.isEmpty
                        ? 'ورود بر حسب هزار تومان'
                        : 'ورودی: ${PersianDigitFormatter.toPersian(_logic.digits)} هزار تومان')
                    : 'ورود تومان کامل',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: FilterChip(
                  selected: !isThousand,
                  label: Text(
                    isThousand ? 'تغییر به تومان کامل' : 'تغییر به هزار تومان',
                  ),
                  onSelected: (_) {
                    _haptic();
                    _mutate(_logic.toggleMode);
                  },
                ),
              ),
              const SizedBox(height: 12),
              _QuickActions(
                hasLastPrice: _logic.hasLastPrice,
                onApplyLast: !_logic.hasLastPrice
                    ? null
                    : () {
                        _haptic();
                        _mutate(_logic.applyLastPrice);
                      },
                onAdjust: (delta) {
                  _haptic();
                  _mutate(() => _logic.adjustBy(delta));
                },
              ),
              const SizedBox(height: 12),
              _PriceKeypadPad(
                onDigit: (digit) {
                  _haptic();
                  _mutate(() => _logic.appendDigit(digit));
                },
                onClear: () {
                  _haptic();
                  _mutate(_logic.clear);
                },
                onConfirm: _onConfirm,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: AppTapTargets.priceKeypad,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                    disabledBackgroundColor:
                        theme.colorScheme.secondary.withValues(alpha: 0.35),
                    textStyle: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: _logic.canConfirm ? _onConfirm : null,
                  child: const Text('تأیید'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.hasLastPrice,
    required this.onApplyLast,
    required this.onAdjust,
  });

  final bool hasLastPrice;
  final VoidCallback? onApplyLast;
  final ValueChanged<int> onAdjust;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        ActionChip(
          onPressed: hasLastPrice ? onApplyLast : null,
          label: const Text('همان قیمت قبلی'),
        ),
        for (final delta in PriceKeypadLogic.quickIncrements)
          ActionChip(
            onPressed: () => onAdjust(delta),
            label: Text('+${_labelThousands(delta)}'),
          ),
        for (final delta in PriceKeypadLogic.quickDecrements)
          ActionChip(
            onPressed: () => onAdjust(-delta),
            label: Text('-${_labelThousands(delta)}'),
          ),
      ],
    );
  }

  static String _labelThousands(int amount) {
    final thousands = amount ~/ 1000;
    return '${PersianDigitFormatter.toPersian('$thousands')} هزار';
  }
}

class _PriceKeypadPad extends StatelessWidget {
  const _PriceKeypadPad({
    required this.onDigit,
    required this.onClear,
    required this.onConfirm,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onClear;
  final VoidCallback onConfirm;

  static const _rows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (final row in _rows) ...[
          Row(
            children: [
              for (final digit in row)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: _PadButton(
                      key: ValueKey('price-key-$digit'),
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
                child: _PadButton(
                  key: const ValueKey('price-key-clear'),
                  onPressed: onClear,
                  child: Text('پاک', style: theme.textTheme.titleMedium),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _PadButton(
                  key: const ValueKey('price-key-0'),
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
                child: _PadButton(
                  key: const ValueKey('price-key-confirm'),
                  onPressed: onConfirm,
                  filled: true,
                  child: Text(
                    'تأیید',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({
    super.key,
    required this.child,
    this.onPressed,
    this.filled = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = filled
        ? theme.colorScheme.secondary
        : theme.colorScheme.surface;

    return SizedBox(
      height: AppTapTargets.priceKeypad,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: filled
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.outline.withValues(alpha: 0.45),
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
