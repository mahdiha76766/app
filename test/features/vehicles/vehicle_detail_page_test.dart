import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/parts/data/providers.dart';
import 'package:mechanic_assistant/features/parts/domain/entities/service_category.dart';
import 'package:mechanic_assistant/features/parts/domain/repositories/service_category_repository.dart';
import 'package:mechanic_assistant/features/repair_orders/data/providers.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_part.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/repositories/repair_order_repository.dart';
import 'package:mechanic_assistant/features/repair_orders/presentation/repair_intake_page.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';
import 'package:mechanic_assistant/features/vehicles/data/providers.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/customer.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_profile.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_repair_summary.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_list_item.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/vehicle_profile_repository.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:mechanic_assistant/features/vehicles/presentation/vehicle_detail_page.dart';
import '../../support/plate_test_helpers.dart';

class _FakeProfileRepository implements VehicleProfileRepository {
  _FakeProfileRepository(this.profile);

  final VehicleProfile profile;

  @override
  Future<VehicleProfile?> getByVehicleId(
    String vehicleId, {
    int recentLimit = 3,
  }) async {
    if (profile.vehicle.id != vehicleId) {
      return null;
    }
    return profile;
  }
}

class _FakeRepairOrderRepository implements RepairOrderRepository {
  RepairOrder? created;
  RepairOrder? updated;

  @override
  Future<void> create(RepairOrder order) async {
    created = order;
  }

  @override
  Future<void> update(RepairOrder order) async {
    updated = order;
  }

  @override
  Future<RepairOrder?> getById(String id) async {
    return created?.id == id
        ? created
        : updated?.id == id
            ? updated
            : RepairOrder(
                id: id,
                vehicleId: 'veh-1',
                status: RepairOrderStatus.accepted,
                laborAmount: 0,
                discountAmount: 0,
                paymentStatus: PaymentStatus.unpaid,
                paidAmount: 0,
                createdAt: DateTime(2026, 7, 20),
              );
  }

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
  Future<List<RepairPart>> getParts(String repairOrderId) async => const [];

  @override
  Future<List<RepairService>> getServices(String repairOrderId) async =>
      const [];

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
  Future<void> completeRepair(String repairOrderId, {DateTime? completedAt}) async {}
}

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
      ServiceCategory(
        id: 'cat-engine',
        title: 'موتور',
        iconKey: 'engine',
        sortOrder: 2,
        isActive: true,
      ),
    ];
  }
}

void main() {
  final now = DateTime(2026, 7, 20);
  final profile = VehicleProfile(
    vehicle: Vehicle(
      id: 'veh-1',
      plateNormalized: '45-B-123-11',
      plateDisplay: '۴۵ ب ۱۲۳ ایران ۱۱',
      model: 'پژو ۲۰۶',
      lastMileage: 85000,
      customerId: 'cus-1',
      createdAt: now,
      updatedAt: now,
    ),
    customer: Customer(
      id: 'cus-1',
      fullName: 'علی رضایی',
      phone: '09123456789',
      createdAt: now,
      updatedAt: now,
    ),
    lastVisitAt: now,
    recentRepairs: [
      VehicleRepairSummary(
        repairOrderId: 'ro-1',
        servicesTitle: 'تعویض لنت',
        mainParts: 'لنت جلو',
        finalAmount: 3200000,
        visitDate: now,
        mileage: 84000,
      ),
    ],
  );

  testWidgets('پرونده خودرو اطلاعات و سابقه را نشان می‌دهد', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleProfileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(profile),
          ),
          repairOrderRepositoryProvider.overrideWithValue(
            _FakeRepairOrderRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const VehicleDetailPage(
            vehicleId: 'veh-1',
            showScanSuccess: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('پلاک با موفقیت شناسایی شد'), findsOneWidget);
    expectIranianPlate45B12311Visible();
    expect(find.text('پژو ۲۰۶'), findsOneWidget);
    expect(find.text('علی رضایی'), findsOneWidget);
    expect(find.text('تعویض لنت'), findsOneWidget);
    expect(find.text('لنت جلو'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('شروع پذیرش'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('شروع پذیرش'), findsOneWidget);
    expect(find.text('ویرایش اطلاعات'), findsOneWidget);
  });

  testWidgets('شروع پذیرش draft می‌سازد و به intake می‌رود', (tester) async {
    final repairs = _FakeRepairOrderRepository();
    final router = GoRouter(
      initialLocation: '/vehicle/veh-1',
      routes: [
        GoRoute(
          path: '/vehicle/:vehicleId',
          builder: (context, state) => VehicleDetailPage(
            vehicleId: state.pathParameters['vehicleId']!,
            showScanSuccess: true,
          ),
        ),
        GoRoute(
          path: '/repair/:repairId/intake',
          builder: (context, state) => RepairIntakePage(
            repairId: state.pathParameters['repairId']!,
          ),
        ),
        GoRoute(
          path: '/repair/:repairId/parts',
          builder: (context, state) => const Scaffold(
            body: Text('parts'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleProfileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(profile),
          ),
          repairOrderRepositoryProvider.overrideWithValue(repairs),
          vehicleRepositoryProvider.overrideWithValue(
            _FakeVehicleRepository(profile.vehicle),
          ),
          serviceCategoryRepositoryProvider.overrideWithValue(
            _FakeCategoryRepository(),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('شروع پذیرش'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('شروع پذیرش'));
    await tester.pumpAndSettle();

    expect(repairs.created, isNotNull);
    expect(repairs.created!.status, RepairOrderStatus.accepted);
    expect(find.text('پذیرش خودرو'), findsOneWidget);
    expect(find.text('ترمز'), findsOneWidget);
    expect(find.text('موتور'), findsOneWidget);
    expect(find.text('ضبط صدا (به‌زودی)'), findsOneWidget);
  });
}
