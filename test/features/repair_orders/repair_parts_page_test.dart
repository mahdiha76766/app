import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';
import 'package:mechanic_assistant/features/parts/data/providers.dart';
import 'package:mechanic_assistant/features/parts/domain/entities/part.dart';
import 'package:mechanic_assistant/features/parts/domain/entities/service_category.dart';
import 'package:mechanic_assistant/features/parts/domain/repositories/part_repository.dart';
import 'package:mechanic_assistant/features/parts/domain/repositories/service_category_repository.dart';
import 'package:mechanic_assistant/features/repair_orders/data/providers.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_part.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/repositories/repair_order_repository.dart';
import '../../support/plate_test_helpers.dart';
import 'package:mechanic_assistant/features/repair_orders/presentation/repair_parts_page.dart';
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
      vehicle.id == id ? vehicle : null;

  @override
  Future<List<Vehicle>> getAll() async => [vehicle];

  @override
  Future<List<VehicleListItem>> listWithVisitStats({DateTime? visitsFrom, DateTime? visitsTo}) async => const [];

  @override
  Future<List<Vehicle>> getVisitedToday({DateTime? now}) async => const [];

  @override
  Future<void> upsert(Vehicle vehicle) async {}
}

class _FakePartRepository implements PartRepository {
  _FakePartRepository({
    required this.categoryParts,
    required this.workshopParts,
  });

  final List<Part> categoryParts;
  final List<Part> workshopParts;
  final List<Part> upserted = [];

  @override
  Future<Part?> getById(String id) async => null;

  @override
  Future<List<Part>> searchByTitle(String query, {int limit = 30}) async =>
      const [];

  @override
  Future<List<Part>> getPopularByCategory(
    String categoryId, {
    int limit = 15,
  }) async =>
      categoryParts.take(limit).toList();

  @override
  Future<List<Part>> getPopularWorkshop({int limit = 15}) async =>
      workshopParts.take(limit).toList();

  @override
  Future<int?> getLatestPrice({
    required String normalizedTitle,
    String? vehicleModel,
  }) async =>
      2500000;

  @override
  Future<void> upsert(Part part) async {
    upserted.add(part);
  }

  @override
  Future<void> recordPrice({
    required String id,
    String? partId,
    required String partTitleNormalized,
    String? vehicleModel,
    required int amount,
    String? repairOrderId,
    required DateTime createdAt,
  }) async {}
}

class _FakeCategoryRepository implements ServiceCategoryRepository {
  @override
  Future<List<ServiceCategory>> getActiveCategories() async {
    return const [
      ServiceCategory(
        id: 'cat-brake',
        title: 'ترمز',
        iconKey: 'brake',
        sortOrder: 1,
        isActive: true,
      ),
    ];
  }
}

class _FakeRepairOrderRepository implements RepairOrderRepository {
  _FakeRepairOrderRepository({
    required this.order,
    required this.services,
  });

  final RepairOrder order;
  final List<RepairService> services;
  final List<RepairPart> parts = [];

  @override
  Future<void> create(RepairOrder order) async {}

  @override
  Future<void> update(RepairOrder order) async {}

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
  Future<List<RepairStatusHistoryRow>> listStatusHistory(String repairOrderId) async =>
      const [];

  @override
  Future<RepairPart> addPart(RepairPart part) async {
    parts.add(part);
    return part;
  }

  @override
  Future<void> updatePart(RepairPart part) async {
    final index = parts.indexWhere((item) => item.id == part.id);
    if (index >= 0) {
      parts[index] = part;
    }
  }

  @override
  Future<void> removePart(String repairPartId) async {
    parts.removeWhere((item) => item.id == repairPartId);
  }

  @override
  Future<void> updateService(RepairService service) async {}

  @override
  Future<RepairService> addService(RepairService service) async => service;

  @override
  Future<void> removeService(String repairServiceId) async {}

  @override
  Future<List<RepairPart>> getParts(String repairOrderId) async =>
      List.of(parts);

  @override
  Future<List<RepairService>> getServices(String repairOrderId) async =>
      services;

  @override
  Future<InvoiceTotals> calculateInvoiceTotals(String repairOrderId) async {
    return const InvoiceTotals(
      laborAmount: 0,
      servicesTotal: 0,
      partsTotal: 0,
      discountAmount: 0,
      paidAmount: 0,
    );
  }

  @override
  Future<void> completeRepair(
    String repairOrderId, {
    DateTime? completedAt,
  }) async {}
}

Part _part(String id, String title, {int usage = 0}) {
  final now = DateTime(2026, 7, 20);
  return Part(
    id: id,
    title: title,
    normalizedTitle: title,
    serviceCategoryId: 'cat-brake',
    usageCount: usage,
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late Vehicle vehicle;
  late RepairOrder order;
  late _FakeRepairOrderRepository repairs;
  late _FakePartRepository partsRepo;

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
      laborAmount: 0,
      discountAmount: 0,
      paymentStatus: PaymentStatus.unpaid,
      paidAmount: 0,
      createdAt: now,
    );
    repairs = _FakeRepairOrderRepository(
      order: order,
      services: [
        RepairService(
          id: 'svc-1',
          repairOrderId: 'rep-1',
          title: 'ترمز',
          amount: 0,
          createdAt: now,
        ),
      ],
    );
    partsRepo = _FakePartRepository(
      categoryParts: [
        for (var i = 1; i <= 14; i++)
          _part('p-cat-$i', 'لنت $i', usage: 20 - i),
      ],
      workshopParts: [
        for (var i = 1; i <= 5; i++)
          _part('p-ws-$i', 'روغن $i', usage: 10 - i),
      ],
    );
  });

  Widget buildPage() {
    return ProviderScope(
      overrides: [
        vehicleRepositoryProvider.overrideWithValue(
          _FakeVehicleRepository(vehicle),
        ),
        repairOrderRepositoryProvider.overrideWithValue(repairs),
        partRepositoryProvider.overrideWithValue(partsRepo),
        serviceCategoryRepositoryProvider.overrideWithValue(
          _FakeCategoryRepository(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('fa', 'IR'),
        home: const RepairPartsPage(repairId: 'rep-1'),
      ),
    );
  }

  testWidgets('هدر و سه بخش قطعات را نشان می‌دهد و لیست را به ۱۲ محدود می‌کند',
      (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    expect(find.text('پژو ۲۰۶'), findsOneWidget);
    expectIranianPlate45B12311Visible();
    expect(find.text('ترمز'), findsWidgets);
    expect(find.text('قطعات پرکاربرد ترمز'), findsOneWidget);
    expect(find.text('قطعات پرتکرار این تعمیرگاه'), findsOneWidget);
    expect(find.text('جستجوی قطعه'), findsOneWidget);
    expect(find.text('افزودن قطعه جدید'), findsOneWidget);
    expect(find.text('مشاهده همه'), findsOneWidget);

    expect(find.text('لنت 1'), findsOneWidget);
    expect(find.text('لنت 12'), findsOneWidget);
    expect(find.text('لنت 13'), findsNothing);
  });

  testWidgets('لمس قطعه آن را اضافه و شیت قیمت را باز می‌کند', (tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();

    await tester.tap(find.text('لنت 1'));
    await tester.pumpAndSettle();

    expect(repairs.parts, hasLength(1));
    expect(find.textContaining('لنت 1'), findsWidgets);
    expect(find.textContaining('آخرین بار'), findsOneWidget);
    expect(find.text('تأیید'), findsWidgets);
  });
}
