import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/core/formatters/money_formatter.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';
import 'package:mechanic_assistant/features/repair_orders/data/providers.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_part.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/repositories/repair_order_repository.dart';
import 'package:mechanic_assistant/features/repair_orders/presentation/repair_summary_page.dart';
import 'package:mechanic_assistant/features/vehicles/data/providers.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_list_item.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';

class _FakeVehicleRepository implements VehicleRepository {
  _FakeVehicleRepository(this.vehicle);
  final Vehicle vehicle;

  @override
  Future<Vehicle?> findByPlateNormalized(String plateNormalized) async => null;

  @override
  Future<Vehicle?> getById(String id) async =>
      id == vehicle.id ? vehicle : null;

  @override
  Future<List<Vehicle>> getAll() async => [vehicle];

  @override
  Future<List<VehicleListItem>> listWithVisitStats({
    DateTime? visitsFrom,
    DateTime? visitsTo,
  }) async =>
      const [];

  @override
  Future<List<Vehicle>> getVisitedToday({DateTime? now}) async => const [];

  @override
  Future<void> upsert(Vehicle vehicle) async {}
}

class _FakeRepairOrderRepository implements RepairOrderRepository {
  _FakeRepairOrderRepository({
    required this.order,
    required List<RepairPart> parts,
    required List<RepairService> services,
  })  : parts = List.of(parts),
        services = List.of(services);

  RepairOrder order;
  final List<RepairPart> parts;
  final List<RepairService> services;
  bool completed = false;

  @override
  Future<void> create(RepairOrder order) async {}

  @override
  Future<void> update(RepairOrder order) async {
    this.order = order;
  }

  @override
  Future<RepairOrder?> getById(String id) async =>
      order.id == id ? order : null;

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
  Future<List<RepairStatusHistoryRow>> listStatusHistory(
    String repairOrderId,
  ) async =>
      const [];

  @override
  Future<RepairPart> addPart(RepairPart part) async {
    parts.add(part);
    return part;
  }

  @override
  Future<void> updatePart(RepairPart part) async {}

  @override
  Future<void> removePart(String repairPartId) async {}

  @override
  Future<void> updateService(RepairService service) async {}

  @override
  Future<RepairService> addService(RepairService service) async {
    services.add(service);
    return service;
  }

  @override
  Future<void> removeService(String repairServiceId) async {
    services.removeWhere((item) => item.id == repairServiceId);
  }

  @override
  Future<List<RepairPart>> getParts(String repairOrderId) async =>
      List.of(parts);

  @override
  Future<List<RepairService>> getServices(String repairOrderId) async =>
      List.of(services);

  @override
  Future<InvoiceTotals> calculateInvoiceTotals(String repairOrderId) async {
    final partsTotal = parts
        .where((item) => item.suppliedBy == PartSuppliedBy.workshop)
        .fold<int>(0, (sum, item) => sum + item.lineTotal);
    return InvoiceTotals(
      laborAmount: order.laborAmount,
      servicesTotal: 0,
      partsTotal: partsTotal,
      discountAmount: order.discountAmount,
      paidAmount: order.paidAmount,
    );
  }

  @override
  Future<void> completeRepair(
    String repairOrderId, {
    DateTime? completedAt,
  }) async {
    completed = true;
    order = order.copyWith(
      status: RepairOrderStatus.readyForDelivery,
      completedAt: completedAt ?? DateTime(2026, 7, 20),
    );
  }
}

void main() {
  late Vehicle vehicle;
  late RepairOrder order;
  late _FakeRepairOrderRepository repairs;

  setUp(() {
    final now = DateTime(2026, 7, 20);
    vehicle = Vehicle(
      id: 'veh-1',
      plateNormalized: '45-B-123-11',
      plateDisplay: '۴۵ ب ۱۲۳ ایران ۱۱',
      manufacturer: 'پژو',
      model: '۲۰۶',
      createdAt: now,
      updatedAt: now,
    );
    order = RepairOrder(
      id: 'rep-1',
      vehicleId: 'veh-1',
      status: RepairOrderStatus.inRepair,
      laborAmount: 500000,
      discountAmount: 0,
      paymentStatus: PaymentStatus.unpaid,
      paidAmount: 0,
      createdAt: now,
    );
    repairs = _FakeRepairOrderRepository(
      order: order,
      parts: [
        RepairPart(
          id: 'rp-1',
          repairOrderId: 'rep-1',
          partTitleSnapshot: 'لنت جلو',
          quantity: 1,
          unitPrice: 1200000,
          suppliedBy: PartSuppliedBy.workshop,
          createdAt: now,
        ),
        RepairPart(
          id: 'rp-2',
          repairOrderId: 'rep-1',
          partTitleSnapshot: 'دیسک مشتری',
          quantity: 1,
          unitPrice: 2000000,
          suppliedBy: PartSuppliedBy.customer,
          createdAt: now,
        ),
      ],
      services: const [],
    );
  });

  Widget buildPage() {
    return ProviderScope(
      overrides: [
        vehicleRepositoryProvider.overrideWithValue(
          _FakeVehicleRepository(vehicle),
        ),
        repairOrderRepositoryProvider.overrideWithValue(repairs),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('fa', 'IR'),
        home: const RepairSummaryPage(repairId: 'rep-1'),
      ),
    );
  }

  testWidgets('خلاصه فاکتور قطعات کارگاه و مشتری را درست نشان می‌دهد',
      (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    expect(find.text('پژو ۲۰۶'), findsOneWidget);
    expect(find.text('خلاصه فاکتور'), findsOneWidget);
    expect(find.textContaining('لنت جلو'), findsOneWidget);
    expect(find.textContaining('دیسک مشتری'), findsOneWidget);
    expect(find.text(MoneyFormatter.format(1200000)), findsWidgets);
    expect(find.text('افزودن تخفیف'), findsOneWidget);
    expect(find.text(MoneyFormatter.format(1700000)), findsOneWidget);
    expect(find.text('پایان تعمیر'), findsOneWidget);
    expect(find.text('در حال تعمیر'), findsOneWidget);
  });

  testWidgets('پایان تعمیر dialog تأیید را نشان می‌دهد', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    await tester.tap(find.text('پایان تعمیر'));
    await tester.pumpAndSettle();

    expect(
      find.text('آیا مطمئن هستید خودرو آماده تحویل می‌شود؟'),
      findsOneWidget,
    );
    expect(find.text('تأیید و پایان'), findsOneWidget);
    expect(repairs.completed, isFalse);

    await tester.tap(find.text('انصراف'));
    await tester.pumpAndSettle();
    expect(repairs.completed, isFalse);
  });
}
