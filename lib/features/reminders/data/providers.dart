import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/reminder_dashboard.dart';
import '../domain/repositories/reminder_repository.dart';
import '../domain/services/reminder_notification_service.dart';
import 'repositories/reminder_repository_impl.dart';
import 'services/local_reminder_notification_service.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepositoryImpl(ref.watch(appDatabaseProvider));
});

final reminderNotificationServiceProvider =
    Provider<ReminderNotificationService>((ref) {
  return ref.watch(localReminderNotificationServiceProvider);
});

final reminderDashboardProvider =
    FutureProvider.autoDispose<ReminderDashboard>((ref) {
  return ref.watch(reminderRepositoryProvider).getDashboard();
});
