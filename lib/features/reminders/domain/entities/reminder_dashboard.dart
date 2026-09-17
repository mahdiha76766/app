import 'reminder_card.dart';

/// دسته‌بندی یادآوری‌های در انتظار برای صفحه لیست.
class ReminderDashboard {
  const ReminderDashboard({
    required this.due,
    required this.near,
    required this.future,
  });

  final List<ReminderCard> due;
  final List<ReminderCard> near;
  final List<ReminderCard> future;

  bool get isEmpty => due.isEmpty && near.isEmpty && future.isEmpty;
}
