import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:mechanic_assistant/features/repair_orders/data/repositories/repair_order_repository_impl.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/services/repair_workflow.dart';
import 'package:mechanic_assistant/features/vehicles/data/repositories/customer_repository_impl.dart';
import 'package:mechanic_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/customer.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';

void main() {
  late AppDatabase db;
  late RepairOrderRepositoryImpl repairs;
  late ReminderRepositoryImpl reminders;
  late VehicleRepositoryImpl vehicles;
  late CustomerRepositoryImpl customers;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repairs = RepairOrderRepositoryImpl(db);
    reminders = ReminderRepositoryImpl(db);
    vehicles = VehicleRepositoryImpl(db);
    customers = CustomerRepositoryImpl(db);

    final now = DateTime(2026, 7, 20);
    await customers.upsert(
      Customer(
        id: 'c1',
        fullName: 'علی',
        phone: '09120000000',
        createdAt: now,
        updatedAt: now,
      ),
    );
    await vehicles.upsert(
      Vehicle(
        id: 'v1',
        customerId: 'c1',
        plateNormalized: '12-B-345-67',
        plateDisplay: '۱۲ ب ۳۴۵ ایران ۶۷',
        lastMileage: 80000,
        createdAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  Future<RepairOrder> createOpen({
    RepairOrderStatus status = RepairOrderStatus.inRepair,
  }) async {
    final order = RepairOrder(
      id: 'r1',
      vehicleId: 'v1',
      customerId: 'c1',
      status: RepairOrderStatus.accepted,
      laborAmount: 100000,
      discountAmount: 0,
      paymentStatus: PaymentStatus.unpaid,
      paidAmount: 0,
      mileage: 81000,
      createdAt: DateTime(2026, 7, 20),
    );
    await repairs.create(order);
    if (status != RepairOrderStatus.accepted) {
      await repairs.changeStatus(repairOrderId: 'r1', to: status);
    }
    return (await repairs.getById('r1'))!;
  }

  test('completeRepair moves to readyForDelivery and writes history', () async {
    await createOpen();
    await repairs.completeRepair('r1');
    final order = await repairs.getById('r1');
    expect(order!.status, RepairOrderStatus.readyForDelivery);
    expect(order.invoiceNumber, isNotNull);
    expect(order.completedAt, isNotNull);

    final history = await repairs.listStatusHistory('r1');
    expect(history.any((h) => h.toStatus == 'readyForDelivery'), isTrue);

    final logs = await repairs.listMileageLogs('v1');
    expect(logs, isNotEmpty);
    expect(logs.first.mileage, 81000);
  });

  test('deliverRepair separates from complete', () async {
    await createOpen();
    await repairs.completeRepair('r1');
    await repairs.deliverRepair('r1');
    final order = await repairs.getById('r1');
    expect(order!.status, RepairOrderStatus.delivered);
    expect(order.deliveredAt, isNotNull);
    expect(order.countsForFinanceViaStatus, isTrue);
  });

  test('cancelRepair keeps order and excludes finance', () async {
    await createOpen();
    await repairs.cancelRepair('r1', reason: 'انصراف مشتری');
    final order = await repairs.getById('r1');
    expect(order!.status, RepairOrderStatus.cancelled);
    expect(order.cancelReason, 'انصراف مشتری');
    expect(order.status.countsForFinance, isFalse);
    expect(await repairs.getById('r1'), isNotNull);
  });

  test('invalid transition throws', () async {
    await createOpen(status: RepairOrderStatus.accepted);
    expect(
      () => repairs.changeStatus(
        repairOrderId: 'r1',
        to: RepairOrderStatus.delivered,
      ),
      throwsA(isA<InvalidRepairTransitionException>()),
    );
  });

  test('mileage decrease requires allowDecrease', () async {
    await expectLater(
      repairs.recordMileage(vehicleId: 'v1', mileage: 70000),
      throwsA(isA<StateError>()),
    );
    await repairs.recordMileage(
      vehicleId: 'v1',
      mileage: 70000,
      allowDecrease: true,
      note: 'تصحیح',
    );
    final vehicle = await vehicles.getById('v1');
    expect(vehicle!.lastMileage, 70000);
    final logs = await repairs.listMileageLogs('v1');
    expect(logs.first.mileage, 70000);
  });

  test('reminder edit cancel and recreate next', () async {
    final now = DateTime(2026, 7, 20);
    final reminder = Reminder(
      id: 'rem1',
      vehicleId: 'v1',
      title: 'روغن',
      dueDate: now.add(const Duration(days: 30)),
      status: ReminderStatus.pending,
      createdAt: now,
      intervalDays: 90,
      intervalMileage: 5000,
      dueMileage: 85000,
    );
    await reminders.upsert(reminder);

    // ویرایش
    await reminders.upsert(
      reminder.copyWith(dueDate: now.add(const Duration(days: 45))),
    );
    final edited = (await reminders.getPending()).firstWhere((r) => r.id == 'rem1');
    expect(edited.dueDate, now.add(const Duration(days: 45)));

    final next = await reminders.markDoneAndMaybeCreateNext('rem1');
    expect(next, isNotNull);
    expect(next!.status, ReminderStatus.pending);
    expect(next.intervalDays, 90);
    expect(next.dueMileage, 90000);
    expect(next.dueDate, now.add(const Duration(days: 45 + 90)));

    await reminders.cancel(next.id);
    final pending = await reminders.getPending();
    expect(pending.any((r) => r.id == next.id), isFalse);
  });
}

extension on RepairOrder {
  bool get countsForFinanceViaStatus => status.countsForFinance;
}
