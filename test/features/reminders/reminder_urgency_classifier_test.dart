import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:mechanic_assistant/features/reminders/domain/reminder_presets.dart';
import 'package:mechanic_assistant/features/reminders/domain/services/reminder_urgency_classifier.dart';

Reminder _reminder({
  DateTime? dueDate,
  int? dueMileage,
  ReminderStatus status = ReminderStatus.pending,
}) {
  return Reminder(
    id: 'r1',
    vehicleId: 'v1',
    title: 'تعویض روغن',
    dueDate: dueDate,
    dueMileage: dueMileage,
    status: status,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  group('ReminderUrgencyClassifier', () {
    final now = DateTime(2026, 7, 20, 10);

    test('تاریخ گذشته یا امروز سررسید است', () {
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(dueDate: DateTime(2026, 7, 19)),
          now: now,
        ),
        ReminderUrgency.due,
      );
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(dueDate: DateTime(2026, 7, 20)),
          now: now,
        ),
        ReminderUrgency.due,
      );
    });

    test('تاریخ تا ۱۴ روز آینده نزدیک است', () {
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(dueDate: DateTime(2026, 7, 30)),
          now: now,
        ),
        ReminderUrgency.near,
      );
    });

    test('تاریخ دورتر آینده است', () {
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(dueDate: DateTime(2026, 9, 1)),
          now: now,
        ),
        ReminderUrgency.future,
      );
    });

    test('کیلومتر رسیده‌شده سررسید است', () {
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(dueMileage: 100000),
          now: now,
          currentMileage: 100500,
        ),
        ReminderUrgency.due,
      );
    });

    test('کیلومتر تا ۵۰۰ باقی‌مانده نزدیک است', () {
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(dueMileage: 100400),
          now: now,
          currentMileage: 100000,
        ),
        ReminderUrgency.near,
      );
    });

    test('اگر یکی از معیارها سررسید باشد due برمی‌گردد', () {
      expect(
        ReminderUrgencyClassifier.classify(
          _reminder(
            dueDate: DateTime(2026, 9, 1),
            dueMileage: 90000,
          ),
          now: now,
          currentMileage: 95000,
        ),
        ReminderUrgency.due,
      );
    });
  });

  group('ReminderPresets', () {
    test('تعویض روغن ۶ ماه و ۵۰۰۰ کیلومتر پیشنهاد می‌دهد', () {
      expect(ReminderPresets.oilChange.monthsLater, 6);
      expect(ReminderPresets.oilChange.kmLater, 5000);
      expect(ReminderPresets.oilChange.dueKind, ReminderDueKind.both);
    });

    test('addMonths تاریخ را درست جابه‌جا می‌کند', () {
      final from = DateTime(2026, 1, 31);
      final result = ReminderPresets.addMonths(from, 1);
      expect(result.year, 2026);
      expect(result.month, 2);
      expect(result.day, 28);
    });
  });
}
