import '../entities/reminder.dart';

/// سرویس نوتیفیکیشن یادآوری — در نسخه اول فقط داخل اپ.
///
/// در مرحله بعد با `flutter_local_notifications` پیاده‌سازی می‌شود.
abstract class ReminderNotificationService {
  Future<void> scheduleReminder(Reminder reminder);

  Future<void> cancelReminder(String reminderId);
}
