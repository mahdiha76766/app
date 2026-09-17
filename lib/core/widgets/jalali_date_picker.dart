import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../formatters/jalali_date_formatter.dart';
import '../formatters/persian_digit_formatter.dart';

/// انتخابگر تاریخ شمسی — خروجی همان [DateTime] میلادی برای ذخیره در دیتابیس.
Future<DateTime?> showJalaliDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String helpText = 'انتخاب تاریخ',
}) {
  final now = DateTime.now();
  final initial = initialDate ?? now;
  final first = firstDate ?? now.subtract(const Duration(days: 1));
  final last = lastDate ?? now.add(const Duration(days: 365 * 5));

  return showDialog<DateTime>(
    context: context,
    builder: (context) {
      return _JalaliDatePickerDialog(
        initialDate: initial,
        firstDate: first,
        lastDate: last,
        helpText: helpText,
      );
    },
  );
}

class _JalaliDatePickerDialog extends StatefulWidget {
  const _JalaliDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.helpText,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String helpText;

  @override
  State<_JalaliDatePickerDialog> createState() =>
      _JalaliDatePickerDialogState();
}

class _JalaliDatePickerDialogState extends State<_JalaliDatePickerDialog> {
  static const _monthNames = <String>[
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  late Jalali _visibleMonth;
  late Jalali _selected;

  @override
  void initState() {
    super.initState();
    _selected = Jalali.fromDateTime(widget.initialDate.toLocal());
    _visibleMonth = Jalali(_selected.year, _selected.month, 1);
  }

  Jalali get _firstJalali => Jalali.fromDateTime(widget.firstDate.toLocal());
  Jalali get _lastJalali => Jalali.fromDateTime(widget.lastDate.toLocal());

  bool _isBefore(Jalali a, Jalali b) {
    if (a.year != b.year) return a.year < b.year;
    if (a.month != b.month) return a.month < b.month;
    return a.day < b.day;
  }

  bool _isAfter(Jalali a, Jalali b) {
    if (a.year != b.year) return a.year > b.year;
    if (a.month != b.month) return a.month > b.month;
    return a.day > b.day;
  }

  bool _sameDay(Jalali a, Jalali b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _prevMonth() {
    final prev = _visibleMonth.month == 1
        ? Jalali(_visibleMonth.year - 1, 12, 1)
        : Jalali(_visibleMonth.year, _visibleMonth.month - 1, 1);
    if (_isBefore(Jalali(prev.year, prev.month, prev.monthLength), _firstJalali) &&
        !_sameDay(Jalali(prev.year, prev.month, prev.monthLength), _firstJalali) &&
        prev.year * 12 + prev.month <
            _firstJalali.year * 12 + _firstJalali.month) {
      return;
    }
    setState(() => _visibleMonth = prev);
  }

  void _nextMonth() {
    final next = _visibleMonth.month == 12
        ? Jalali(_visibleMonth.year + 1, 1, 1)
        : Jalali(_visibleMonth.year, _visibleMonth.month + 1, 1);
    if (_isAfter(next, _lastJalali) &&
        next.year * 12 + next.month >
            _lastJalali.year * 12 + _lastJalali.month) {
      return;
    }
    setState(() => _visibleMonth = next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = _visibleMonth.monthLength;
    // shamsi weekDay: 1=شنبه ... 7=جمعه
    final firstWeekday = Jalali(_visibleMonth.year, _visibleMonth.month, 1).weekDay;
    final leadingEmpty = firstWeekday - 1;

    return AlertDialog(
      title: Text(widget.helpText),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              JalaliDateFormatter.formatLong(_selected.toDateTime()),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'ماه بعد',
                ),
                Expanded(
                  child: Text(
                    '${_monthNames[_visibleMonth.month - 1]} '
                    '${PersianDigitFormatter.intToPersian(_visibleMonth.year)}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _prevMonth,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'ماه قبل',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(child: Center(child: Text('ش'))),
                Expanded(child: Center(child: Text('ی'))),
                Expanded(child: Center(child: Text('د'))),
                Expanded(child: Center(child: Text('س'))),
                Expanded(child: Center(child: Text('چ'))),
                Expanded(child: Center(child: Text('پ'))),
                Expanded(child: Center(child: Text('ج'))),
              ],
            ),
            const SizedBox(height: 4),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leadingEmpty + daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                if (index < leadingEmpty) {
                  return const SizedBox.shrink();
                }
                final day = index - leadingEmpty + 1;
                final date = Jalali(_visibleMonth.year, _visibleMonth.month, day);
                final enabled = !_isBefore(date, _firstJalali) &&
                    !_isAfter(date, _lastJalali);
                final selected = _sameDay(date, _selected);

                return Material(
                  color: selected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: enabled
                        ? () => setState(() => _selected = date)
                        : null,
                    child: Center(
                      child: Text(
                        PersianDigitFormatter.intToPersian(day),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: !enabled
                              ? theme.colorScheme.onSurface
                                  .withValues(alpha: 0.3)
                              : selected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('انصراف'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(_selected.toDateTime()),
          child: const Text('تأیید'),
        ),
      ],
    );
  }
}
