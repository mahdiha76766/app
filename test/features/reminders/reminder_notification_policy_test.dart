import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:mechanic_assistant/features/reminders/domain/services/reminder_notification_policy.dart';

Reminder _reminder({
  DateTime? dueDate,
  int? dueMileage,
  String? lastKind,
  DateTime? lastAt,
  ReminderStatus status = ReminderStatus.pending,
}) {
  return Reminder(
    id: 'rem-stable-1',
    vehicleId: 'v1',
    title: 'تعویض روغن',
    dueDate: dueDate,
    dueMileage: dueMileage,
    status: status,
    createdAt: DateTime(2026, 1, 1),
    lastNotifiedAt: lastAt,
    lastNotificationKind: lastKind,
  );
}

void main() {
  group('ReminderNotificationPolicy', () {
    final now = DateTime(2026, 7, 21, 12);

    test('stable notification id is deterministic', () {
      final a = ReminderNotificationPolicy.stableNotificationId('rem-stable-1');
      final b = ReminderNotificationPolicy.stableNotificationId('rem-stable-1');
      expect(a, b);
      expect(a, isNonNegative);
    });

    test('date reminder schedules when pending and dueDate set', () {
      final r = _reminder(dueDate: now.add(const Duration(days: 3)));
      expect(
        ReminderNotificationPolicy.shouldNotifyForDate(r, now: now),
        isTrue,
      );
    });

    test('edit/reschedule: future due after prior notify still allowed', () {
      final r = _reminder(
        dueDate: now.add(const Duration(days: 10)),
        lastKind: 'date',
        lastAt: now.subtract(const Duration(days: 1)),
      );
      expect(
        ReminderNotificationPolicy.shouldNotifyForDate(r, now: now),
        isTrue,
      );
    });

    test('prevents duplicate overdue date notification', () {
      final r = _reminder(
        dueDate: now.subtract(const Duration(days: 1)),
        lastKind: 'date',
        lastAt: now.subtract(const Duration(hours: 2)),
      );
      expect(
        ReminderNotificationPolicy.shouldNotifyForDate(r, now: now),
        isFalse,
      );
    });

    test('mileage notify once when due', () {
      final r = _reminder(dueMileage: 100000);
      expect(
        ReminderNotificationPolicy.shouldNotifyForMileage(
          r,
          currentMileage: 100500,
        ),
        isTrue,
      );
      final notified = r.copyWith(
        lastNotifiedAt: now,
        lastNotificationKind: 'mileage',
      );
      expect(
        ReminderNotificationPolicy.shouldNotifyForMileage(
          notified,
          currentMileage: 101000,
        ),
        isFalse,
      );
    });

    test('cancel/delete conceptually: non-pending never notifies', () {
      final done = _reminder(
        dueDate: now.add(const Duration(days: 1)),
        status: ReminderStatus.done,
      );
      expect(
        ReminderNotificationPolicy.shouldNotifyForDate(done, now: now),
        isFalse,
      );
      final cancelled = _reminder(
        dueMileage: 1,
        status: ReminderStatus.cancelled,
      );
      expect(
        ReminderNotificationPolicy.shouldNotifyForMileage(
          cancelled,
          currentMileage: 10,
        ),
        isFalse,
      );
    });

    test('restart recovery: pending future reminders remain schedulable', () {
      // بعد از Restart، rescheduleAllPending دوباره schedule می‌زند؛
      // برای due آینده حتی اگر lastNotified قبلاً ست شده باشد مجاز است.
      final pending = _reminder(
        dueDate: now.add(const Duration(days: 5)),
        lastKind: 'date',
        lastAt: now.subtract(const Duration(days: 30)),
      );
      expect(
        ReminderNotificationPolicy.shouldNotifyForDate(pending, now: now),
        isTrue,
      );
    });
  });
}
