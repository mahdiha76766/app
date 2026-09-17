import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'core/database/dev_seed_service.dart';
import 'features/reminders/data/services/local_reminder_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final notifications =
      container.read(localReminderNotificationServiceProvider);
  try {
    await notifications.ensureInitialized();
    await notifications.rescheduleAllPending();
  } catch (error, stackTrace) {
    debugPrint('Reminder notification initialization failed: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
  if (kDebugMode) {
    final db = container.read(appDatabaseProvider);
    await DevSeedService(db).seedIfNeeded();
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MechanicAssistantApp(),
    ),
  );
}
