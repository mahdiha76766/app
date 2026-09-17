import '../../../../core/database/enums.dart';
import '../entities/reminder.dart';

/// سطح فوریت یادآوری برای بخش‌های سررسید / نزدیک / آینده.
enum ReminderUrgency {
  due,
  near,
  future,
}

/// قواعد دسته‌بندی یادآوری داخل اپ (بدون نوتیفیکیشن سیستم).
abstract final class ReminderUrgencyClassifier {
  /// پنجره «نزدیک» بر اساس تاریخ (روز).
  static const nearDateDays = 14;

  /// پنجره «نزدیک» بر اساس کیلومتر باقی‌مانده.
  static const nearMileageKm = 500;

  static ReminderUrgency classify(
    Reminder reminder, {
    required DateTime now,
    int? currentMileage,
  }) {
    if (reminder.status != ReminderStatus.pending) {
      return ReminderUrgency.future;
    }

    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final nearUntil = endOfToday.add(const Duration(days: nearDateDays));

    final dateDue =
        reminder.dueDate != null && !reminder.dueDate!.isAfter(endOfToday);
    final mileageDue = reminder.dueMileage != null &&
        currentMileage != null &&
        currentMileage >= reminder.dueMileage!;

    if (dateDue || mileageDue) {
      return ReminderUrgency.due;
    }

    final dateNear = reminder.dueDate != null &&
        reminder.dueDate!.isAfter(endOfToday) &&
        !reminder.dueDate!.isAfter(nearUntil);

    final mileageNear = reminder.dueMileage != null &&
        currentMileage != null &&
        reminder.dueMileage! > currentMileage &&
        (reminder.dueMileage! - currentMileage) <= nearMileageKm;

    if (dateNear || mileageNear) {
      return ReminderUrgency.near;
    }

    return ReminderUrgency.future;
  }
}
