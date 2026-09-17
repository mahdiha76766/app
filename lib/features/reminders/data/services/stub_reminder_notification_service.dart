import '../../domain/entities/reminder.dart';
import '../../domain/services/reminder_notification_service.dart';

/// پیاده‌سازی موقتی بدون نوتیفیکیشن سیستم.
class StubReminderNotificationService implements ReminderNotificationService {
  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    // نسخه اول: فقط ذخیره در دیتابیس و نمایش داخل اپ.
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    // نسخه اول: بدون نوتیفیکیشن زمان‌بندی‌شده.
  }
}
