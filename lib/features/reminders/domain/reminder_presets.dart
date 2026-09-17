import 'entities/reminder.dart';

/// پیشنهاد سریع یادآوری سرویس.
class ReminderPreset {
  const ReminderPreset({
    required this.id,
    required this.title,
    required this.dueKind,
    this.monthsLater,
    this.kmLater,
    this.hint,
  });

  final String id;
  final String title;
  final ReminderDueKind dueKind;
  final int? monthsLater;
  final int? kmLater;
  final String? hint;
}

abstract final class ReminderPresets {
  static const oilChange = ReminderPreset(
    id: 'oil',
    title: 'تعویض روغن',
    dueKind: ReminderDueKind.both,
    monthsLater: 6,
    kmLater: 5000,
    hint: '۶ ماه بعد یا ۵۰۰۰ کیلومتر بعد',
  );

  static const timingBelt = ReminderPreset(
    id: 'timing',
    title: 'تسمه تایم',
    dueKind: ReminderDueKind.both,
    hint: 'تاریخ یا کیلومتر را خودتان انتخاب کنید',
  );

  static const insurance = ReminderPreset(
    id: 'insurance',
    title: 'بیمه',
    dueKind: ReminderDueKind.date,
    hint: 'تاریخ مشخص',
  );

  static const inspection = ReminderPreset(
    id: 'inspection',
    title: 'معاینه فنی',
    dueKind: ReminderDueKind.date,
    hint: 'تاریخ مشخص',
  );

  static const all = [oilChange, timingBelt, insurance, inspection];

  static DateTime addMonths(DateTime from, int months) {
    final year = from.year + ((from.month - 1 + months) ~/ 12);
    final month = ((from.month - 1 + months) % 12) + 1;
    final day = from.day.clamp(1, _daysInMonth(year, month));
    return DateTime(year, month, day);
  }

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
