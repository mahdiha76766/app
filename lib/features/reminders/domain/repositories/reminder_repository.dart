import '../entities/reminder.dart';
import '../entities/reminder_dashboard.dart';

abstract class ReminderRepository {
  Future<void> upsert(Reminder reminder);

  Future<List<Reminder>> getDueReminders({DateTime? now});

  Future<List<Reminder>> getForVehicle(String vehicleId);

  Future<List<Reminder>> getPending();

  Future<ReminderDashboard> getDashboard({DateTime? now});

  Future<void> markDone(String reminderId);

  /// Marks a reminder done and creates its next occurrence when recurring.
  Future<Reminder?> markDoneAndMaybeCreateNext(String reminderId);

  Future<void> cancel(String reminderId);
}
