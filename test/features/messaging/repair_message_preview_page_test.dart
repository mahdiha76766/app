import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';
import 'package:mechanic_assistant/features/messaging/data/providers.dart';
import 'package:mechanic_assistant/features/messaging/domain/services/customer_message_sender.dart';
import 'package:mechanic_assistant/features/messaging/presentation/repair_message_preview_page.dart';
import 'package:mechanic_assistant/features/reminders/data/providers.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder.dart';
import 'package:mechanic_assistant/features/reminders/domain/entities/reminder_dashboard.dart';
import 'package:mechanic_assistant/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:mechanic_assistant/features/repair_orders/data/providers.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_part.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/repositories/repair_order_repository.dart';
import 'package:mechanic_assistant/features/settings/data/providers.dart';
import 'package:mechanic_assistant/features/settings/domain/entities/bank_account.dart';
import 'package:mechanic_assistant/features/settings/domain/entities/workshop.dart';
import 'package:mechanic_assistant/features/settings/domain/repositories/bank_account_repository.dart';
import 'package:mechanic_assistant/features/settings/domain/repositories/workshop_repository.dart';
import 'package:mechanic_assistant/features/vehicles/data/providers.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/customer.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_list_item.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/customer_repository.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';

class _FakeVehicleRepo implements VehicleRepository {
  _FakeVehicleRepo(this.vehicle);
  final Vehicle vehicle;
  @override
  Future<Vehicle?> findByPlateNormalized(String plateNormalized) async => null;
  @override
  Future<Vehicle?> getById(String id) async => vehicle;
  @override
  Future<List<Vehicle>> getAll() async => [vehicle];

  @override
  Future<List<VehicleListItem>> listWithVisitStats({DateTime? visitsFrom, DateTime? visitsTo}) async => const [];
  @override
  Future<List<Vehicle>> getVisitedToday({DateTime? now}) async => const [];
  @override
  Future<void> upsert(Vehicle vehicle) async {}
}

class _FakeCustomerRepo implements CustomerRepository {
  _FakeCustomerRepo(this.customer);
  final Customer? customer;
  @override
  Future<Customer?> getById(String id) async =>
      customer?.id == id ? customer : null;
  @override
  Future<void> upsert(Customer customer) async {}
}

class _FakeWorkshopRepo implements WorkshopRepository {
  @override
  Future<Workshop?> getWorkshop() async => Workshop(
        id: 'ws-1',
        name: 'تعمیرگاه تست',
        createdAt: DateTime(2026, 7, 20),
      );
  @override
  Future<void> saveWorkshop(Workshop workshop) async {}
}

class _FakeBankAccountRepo implements BankAccountRepository {
  @override
  Future<List<BankAccount>> listForWorkshop(String workshopId) async =>
      const [];

  @override
  Future<void> upsert(BankAccount account) async {}

  @override
  Future<void> delete(String id) async {}
}

class _FakeRepairRepo implements RepairOrderRepository {
  _FakeRepairRepo(this.order);
  final RepairOrder order;

  @override
  Future<void> create(RepairOrder order) async {}
  @override
  Future<void> update(RepairOrder order) async {}
  @override
  Future<RepairOrder?> getById(String id) async => order;
  @override
  Future<List<RepairOrder>> getHistoryForVehicle(String vehicleId) async =>
      const [];
  @override
  Future<void> changeStatus({
    required String repairOrderId,
    required RepairOrderStatus to,
    String? note,
    DateTime? at,
  }) async {}
  @override
  Future<void> deliverRepair(String repairOrderId, {DateTime? deliveredAt}) async {}
  @override
  Future<void> cancelRepair(String repairOrderId, {String? reason}) async {}
  @override
  Future<void> recordMileage({
    required String vehicleId,
    required int mileage,
    String? repairOrderId,
    DateTime? recordedAt,
    String? note,
    bool allowDecrease = false,
  }) async {}
  @override
  Future<List<VehicleMileageLogRow>> listMileageLogs(String vehicleId) async =>
      const [];
  @override
  Future<List<RepairStatusHistoryRow>> listStatusHistory(String repairOrderId) async =>
      const [];
  @override
  Future<RepairPart> addPart(RepairPart part) async => part;
  @override
  Future<void> updatePart(RepairPart part) async {}
  @override
  Future<void> removePart(String repairPartId) async {}
  @override
  Future<void> updateService(RepairService service) async {}

  @override
  Future<RepairService> addService(RepairService service) async => service;
  @override
  Future<void> removeService(String repairServiceId) async {}
  @override
  Future<List<RepairPart>> getParts(String repairOrderId) async => [
        RepairPart(
          id: 'rp-1',
          repairOrderId: order.id,
          partTitleSnapshot: 'لنت جلو',
          quantity: 1,
          unitPrice: 1000000,
          suppliedBy: PartSuppliedBy.workshop,
          createdAt: order.createdAt,
        ),
      ];
  @override
  Future<List<RepairService>> getServices(String repairOrderId) async => [
        RepairService(
          id: 'svc-1',
          repairOrderId: order.id,
          title: 'تعویض لنت',
          amount: 0,
          createdAt: order.createdAt,
        ),
      ];
  @override
  Future<InvoiceTotals> calculateInvoiceTotals(String repairOrderId) async =>
      const InvoiceTotals(
        laborAmount: 500000,
        servicesTotal: 0,
        partsTotal: 1000000,
        discountAmount: 0,
        paidAmount: 1500000,
      );
  @override
  Future<void> completeRepair(
    String repairOrderId, {
    DateTime? completedAt,
  }) async {}
}

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
  Future<ReminderDashboard> getDashboard({DateTime? now}) async =>
      const ReminderDashboard(due: [], near: [], future: []);

  @override
  Future<void> markDone(String reminderId) async {}

  @override
  Future<Reminder?> markDoneAndMaybeCreateNext(String reminderId) async => null;

  @override
  Future<void> cancel(String reminderId) async {}
}

class _FakeSender implements CustomerMessageSender {
  String? lastMessage;
  String? lastPhone;
  @override
  Future<CustomerMessageSendResult> openPreparedMessage({
    required String message,
    String? phone,
    CustomerMessageSendChannel preferred =
        CustomerMessageSendChannel.whatsapp,
  }) async {
    lastMessage = message;
    lastPhone = phone;
    return const CustomerMessageSendResult(
      channel: CustomerMessageSendChannel.whatsapp,
    );
  }

  @override
  Future<CustomerMessageSendResult> shareFile({
    required String filePath,
    String? text,
    CustomerMessageSendChannel? preferred,
  }) async {
    return const CustomerMessageSendResult(
      channel: CustomerMessageSendChannel.systemShare,
    );
  }
}

void main() {
  testWidgets('پیش‌نمایش پیام و باز کردن واتساپ بدون ارسال خودکار',
      (tester) async {
    final now = DateTime(2026, 7, 20);
    final sender = _FakeSender();
    final vehicle = Vehicle(
      id: 'veh-1',
      customerId: 'cus-1',
      plateNormalized: '45-B-123-11',
      plateDisplay: '۴۵ ب ۱۲۳ ایران ۱۱',
      manufacturer: 'پژو',
      model: '۲۰۶',
      createdAt: now,
      updatedAt: now,
    );
    final customer = Customer(
      id: 'cus-1',
      fullName: 'علی',
      phone: '09123456789',
      createdAt: now,
      updatedAt: now,
    );
    final order = RepairOrder(
      id: 'rep-1',
      vehicleId: 'veh-1',
      customerId: 'cus-1',
      status: RepairOrderStatus.delivered,
      laborAmount: 500000,
      discountAmount: 0,
      paymentStatus: PaymentStatus.paid,
      paidAmount: 1500000,
      createdAt: now,
      completedAt: now,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(_FakeVehicleRepo(vehicle)),
          customerRepositoryProvider.overrideWithValue(
            _FakeCustomerRepo(customer),
          ),
          workshopRepositoryProvider.overrideWithValue(_FakeWorkshopRepo()),
          bankAccountRepositoryProvider.overrideWithValue(_FakeBankAccountRepo()),
          repairOrderRepositoryProvider.overrideWithValue(
            _FakeRepairRepo(order),
          ),
          reminderRepositoryProvider.overrideWithValue(_FakeReminderRepo()),
          customerMessageSenderProvider.overrideWithValue(sender),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const RepairMessagePreviewPage(repairId: 'rep-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('پیش‌نمایش پیام'), findsOneWidget);
    expect(find.textContaining('سلام علی'), findsOneWidget);
    expect(find.textContaining('پژو ۲۰۶'), findsOneWidget);
    expect(find.text('واتساپ'), findsWidgets);
    expect(sender.lastMessage, isNull);

    await tester.tap(find.text('واتساپ').first);
    await tester.pumpAndSettle();

    expect(sender.lastMessage, contains('سلام علی'));
    expect(sender.lastPhone, '09123456789');
    expect(
      find.textContaining('واتساپ باز شد'),
      findsOneWidget,
    );
  });
}
