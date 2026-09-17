import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/database/mappers.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/services/reminder_notification_policy.dart';
import '../../domain/services/reminder_notification_service.dart';

/// اعلان محلی آفلاین برای یادآوری‌های تاریخی.
class LocalReminderNotificationService implements ReminderNotificationService {
  LocalReminderNotificationService(this._db);

  final AppDatabase _db;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Tehran'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'nedicar_reminders',
              'یادآوری سرویس',
              description: 'اعلان یادآوری سرویس خودرو',
              importance: Importance.high,
            ),
          );
    }
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await ensureInitialized();
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? true;
    }
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    await ensureInitialized();
    await cancelReminder(reminder.id);

    final now = DateTime.now();
    if (!ReminderNotificationPolicy.shouldNotifyForDate(reminder, now: now)) {
      return;
    }

    final due = reminder.dueDate!;
    final when = tz.TZDateTime.from(due.toLocal(), tz.local);
    final id = ReminderNotificationPolicy.stableNotificationId(reminder.id);
    if (when.isBefore(tz.TZDateTime.now(tz.local))) {
      await _plugin.show(
        id: id,
        title: 'یادآوری سرویس',
        body: reminder.title,
        notificationDetails: _details(),
        payload: reminder.id,
      );
      await _markNotified(reminder, kind: 'date');
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: 'یادآوری سرویس',
      body: reminder.title,
      scheduledDate: when,
      notificationDetails: _details(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: reminder.id,
    );
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    await ensureInitialized();
    await _plugin.cancel(
      id: ReminderNotificationPolicy.stableNotificationId(reminderId),
    );
  }

  Future<void> rescheduleAllPending() async {
    await ensureInitialized();
    final rows = await (_db.select(_db.reminders)
          ..where((t) => t.status.equals(ReminderStatus.pending.value)))
        .get();
    for (final row in rows) {
      await scheduleReminder(row.toDomain());
    }
  }

  /// بررسی یادآوری‌های کارکرد هنگام ثبت کارکرد جدید.
  Future<void> checkMileageReminders({
    required String vehicleId,
    required int currentMileage,
  }) async {
    await ensureInitialized();
    final rows = await (_db.select(_db.reminders)
          ..where(
            (t) =>
                t.vehicleId.equals(vehicleId) &
                t.status.equals(ReminderStatus.pending.value),
          ))
        .get();
    for (final row in rows) {
      final reminder = row.toDomain();
      if (!ReminderNotificationPolicy.shouldNotifyForMileage(
        reminder,
        currentMileage: currentMileage,
      )) {
        continue;
      }
      await _plugin.show(
        id: ReminderNotificationPolicy.stableNotificationId(reminder.id) ^
            0x1111,
        title: 'یادآوری بر اساس کارکرد',
        body: '${reminder.title} — کارکرد به ${reminder.dueMileage} رسیده است',
        notificationDetails: _details(),
        payload: reminder.id,
      );
      await _markNotified(reminder, kind: 'mileage');
    }
  }

  Future<void> _markNotified(Reminder reminder, {required String kind}) async {
    final updated = reminder.copyWith(
      lastNotifiedAt: DateTime.now(),
      lastNotificationKind: kind,
    );
    await _db.into(_db.reminders).insertOnConflictUpdate(updated.toCompanion());
  }

  NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'nedicar_reminders',
        'یادآوری سرویس',
        channelDescription: 'اعلان یادآوری سرویس خودرو',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}

final localReminderNotificationServiceProvider =
    Provider<LocalReminderNotificationService>((ref) {
  return LocalReminderNotificationService(ref.watch(appDatabaseProvider));
});
