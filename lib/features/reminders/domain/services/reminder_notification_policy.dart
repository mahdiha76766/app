import '../../domain/entities/reminder.dart';
import '../../../../core/database/enums.dart';

/// تصمیم‌گیری اعلان بدون وابستگی به پلاگین سیستم‌عامل.
abstract final class ReminderNotificationPolicy {
  /// آیا باید اعلان تاریخی زمان‌بندی/نمایش شود؟
  static bool shouldNotifyForDate(Reminder reminder, {required DateTime now}) {
    if (reminder.status != ReminderStatus.pending) return false;
    if (reminder.dueDate == null) return false;
    // جلوگیری از اعلان تکراری تاریخی
    if (reminder.lastNotificationKind == 'date' &&
        reminder.lastNotifiedAt != null) {
      // اگر سررسید آینده است، زمان‌بندی مجدد پس از ویرایش مجاز است
      // (سرویس قبلاً cancel می‌کند). برای سررسید گذشته تکرار نکن.
      if (!reminder.dueDate!.isAfter(now)) {
        return false;
      }
    }
    return true;
  }

  /// آیا اعلان کارکرد باید نشان داده شود؟
  static bool shouldNotifyForMileage(
    Reminder reminder, {
    required int currentMileage,
  }) {
    if (reminder.status != ReminderStatus.pending) return false;
    final dueKm = reminder.dueMileage;
    if (dueKm == null) return false;
    if (currentMileage < dueKm) return false;
    if (reminder.lastNotificationKind == 'mileage' &&
        reminder.lastNotifiedAt != null) {
      return false;
    }
    return true;
  }

  /// شناسه پایدار اعلان برای یک یادآوری.
  static int stableNotificationId(String reminderId) =>
      reminderId.hashCode & 0x7fffffff;
}
