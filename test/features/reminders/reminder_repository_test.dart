import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:mechanic_assistant/features/vehicles/data/repositories/customer_repository_impl.dart';
import 'package:mechanic_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/customer.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';

void main() {
  late AppDatabase db;
  late ReminderRepositoryImpl reminders;
  late VehicleRepositoryImpl vehicles;
  late CustomerRepositoryImpl customers;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    reminders = ReminderRepositoryImpl(db);
    vehicles = VehicleRepositoryImpl(db);
    customers = CustomerRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('داشبورد یادآوری را به سررسید/نزدیک/آینده تقسیم می‌کند', () async {
    final now = DateTime(2026, 7, 20, 12);

    await customers.upsert(
      Customer(
        id: 'cus-1',
        fullName: 'رضا',
        phone: '09120000000',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await vehicles.upsert(
      Vehicle(
        id: 'veh-1',
        customerId: 'cus-1',
        plateNormalized: '11-A-111-11',
        plateDisplay: '۱۱ الف ۱۱۱ ایران ۱۱',
        manufacturer: 'پژو',
        model: '۲۰۶',
        lastMileage: 100000,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await reminders.upsert(
      Reminder(
        id: 'due-1',
        vehicleId: 'veh-1',
        title: 'تعویض روغن',
        dueDate: DateTime(2026, 7, 18),
        status: ReminderStatus.pending,
        createdAt: now,
      ),
    );
    await reminders.upsert(
      Reminder(
        id: 'near-1',
        vehicleId: 'veh-1',
        title: 'معاینه فنی',
        dueDate: DateTime(2026, 7, 28),
        status: ReminderStatus.pending,
        createdAt: now,
      ),
    );
    await reminders.upsert(
      Reminder(
        id: 'future-1',
        vehicleId: 'veh-1',
        title: 'بیمه',
        dueDate: DateTime(2026, 12, 1),
        status: ReminderStatus.pending,
        createdAt: now,
      ),
    );

    final dashboard = await reminders.getDashboard(now: now);

    expect(dashboard.due, hasLength(1));
    expect(dashboard.due.single.reminder.title, 'تعویض روغن');
    expect(dashboard.due.single.customerName, 'رضا');
    expect(dashboard.due.single.phone, '09120000000');
    expect(dashboard.due.single.vehicleModel, 'پژو ۲۰۶');

    expect(dashboard.near, hasLength(1));
    expect(dashboard.near.single.reminder.title, 'معاینه فنی');

    expect(dashboard.future, hasLength(1));
    expect(dashboard.future.single.reminder.title, 'بیمه');
  });
}
