import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/reminders/data/providers.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder_card.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder_dashboard.dart';
import 'package:mechanic_assistant/features/reminders/domain/repositories/reminder_repository.dart';
import '../../support/plate_test_helpers.dart';
import 'package:mechanic_assistant/features/reminders/presentation/reminders_page.dart';

class _FakeReminderRepo implements ReminderRepository {
  @override
  Future<void> upsert(Reminder reminder) async {}

  @override
  Future<List<Reminder>> getDueReminders({DateTime? now}) async => const [];

  @override
  Future<List<Reminder>> getForVehicle(String vehicleId) async => const [];

  @override
  Future<List<Reminder>> getPending() async => const [];

  @override
  Future<ReminderDashboard> getDashboard({DateTime? now}) async {
    final reminder = Reminder(
      id: 'r-due',
      vehicleId: 'v1',
      title: 'تعویض روغن',
      dueDate: DateTime(2026, 7, 15),
      status: ReminderStatus.pending,
      createdAt: DateTime(2026, 1, 1),
    );
    return ReminderDashboard(
      due: [
        ReminderCard(
          reminder: reminder,
          vehicleModel: 'پژو ۲۰۶',
          plateDisplay: '۴۵ ب ۱۲۳ ایران ۱۱',
          customerName: 'علی',
          phone: '09121112233',
          currentMileage: 80000,
        ),
      ],
      near: const [],
      future: const [],
    );
  }

  @override
  Future<void> markDone(String reminderId) async {}

  @override
  Future<Reminder?> markDoneAndMaybeCreateNext(String reminderId) async => null;

  @override
  Future<void> cancel(String reminderId) async {}
}

void main() {
  testWidgets('صفحه یادآوری بخش سررسید و کارت مشتری را نشان می‌دهد',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reminderRepositoryProvider.overrideWithValue(_FakeReminderRepo()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const RemindersPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('سررسیدشده'), findsOneWidget);
    expect(find.text('نزدیک'), findsOneWidget);
    expect(find.text('آینده'), findsOneWidget);
    expect(find.text('علی'), findsOneWidget);
    expect(find.text('پژو ۲۰۶'), findsOneWidget);
    expectIranianPlate45B12311Visible();
    expect(find.textContaining('تعویض روغن'), findsWidgets);
    expect(find.text('واتساپ'), findsOneWidget);
  });
}
