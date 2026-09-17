import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/widgets/iranian_plate_input.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_recognition_result.dart';
import 'package:mechanic_assistant/features/plate_scanner/presentation/confirm_plate_screen.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/customer.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_list_item.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle_profile.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/vehicle_profile_repository.dart';
import 'package:mechanic_assistant/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:mechanic_assistant/features/vehicles/data/providers.dart';
import 'package:mechanic_assistant/features/vehicles/presentation/vehicle_detail_page.dart';
import 'package:mechanic_assistant/features/vehicles/presentation/new_vehicle_page.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/new_vehicle_plate_args.dart';
import '../../support/plate_test_helpers.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/repair_orders/data/providers.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_part.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/repositories/repair_order_repository.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';

class _FakeVehicleRepository implements VehicleRepository {
  _FakeVehicleRepository({this.existing});

  final Vehicle? existing;
  Vehicle? upserted;

  @override
  Future<Vehicle?> findByPlateNormalized(String plateNormalized) async {
    if (existing?.plateNormalized == plateNormalized) {
      return existing;
    }
    return null;
  }

  @override
  Future<Vehicle?> getById(String id) async =>
      existing?.id == id ? existing : upserted?.id == id ? upserted : null;

  @override
  Future<List<Vehicle>> getAll() async => [
        ?existing,
        ?upserted,
      ];

  @override
  Future<List<VehicleListItem>> listWithVisitStats({
    DateTime? visitsFrom,
    DateTime? visitsTo,
  }) async =>
      const [];

  @override
  Future<List<Vehicle>> getVisitedToday({DateTime? now}) async => const [];

  @override
  Future<void> upsert(Vehicle vehicle) async {
    upserted = vehicle;
  }
}

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
  @override
  Future<void> create(RepairOrder order) async {}

  @override
  Future<void> update(RepairOrder order) async {}

  @override
  Future<RepairOrder?> getById(String id) async => null;

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

void main() {
  testWidgets('صفحه تأیید بدون لمس کاربر وارد پرونده نمی‌شود', (tester) async {
    final now = DateTime(2026, 7, 20);
    final existing = Vehicle(
      id: 'veh-1',
      plateNormalized: '45-B-123-11',
      plateDisplay: '۴۵ ب ۱۲۳ ایران ۱۱',
      model: 'پژو ۲۰۶',
      createdAt: now,
      updatedAt: now,
    );
    final profile = VehicleProfile(
      vehicle: existing,
      customer: Customer(
        id: 'cus-1',
        fullName: 'علی',
        phone: '09123456789',
        createdAt: now,
        updatedAt: now,
      ),
      lastVisitAt: now,
      recentRepairs: const [],
    );

    final router = GoRouter(
      initialLocation: '/confirm',
      routes: [
        GoRoute(
          path: '/confirm',
          builder: (context, state) => ConfirmPlateScreen(
            result: PlateRecognitionResult(
              rawText: '۴۵ ب ۱۲۳ ایران ۱۱',
              normalizedPlate: '45-B-123-11',
              firstTwoDigits: '45',
              middleThreeDigits: '123',
              letter: 'ب',
              cityCode: '11',
              confidence: 0.9,
              imagePath: '',
            ),
          ),
        ),
        GoRoute(
          path: '/vehicle/:vehicleId',
          builder: (context, state) => VehicleDetailPage(
            vehicleId: state.pathParameters['vehicleId']!,
            showScanSuccess:
                state.uri.queryParameters['fromScan'] == '1',
          ),
        ),
        GoRoute(
          path: '/vehicle/new',
          builder: (context, state) => NewVehiclePage(
            args: state.extra! as NewVehiclePlateArgs,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(
            _FakeVehicleRepository(existing: existing),
          ),
          vehicleProfileRepositoryProvider.overrideWithValue(
            _FakeProfileRepository(profile),
          ),
          repairOrderRepositoryProvider.overrideWithValue(
            _FakeRepairOrderRepository(),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تأیید پلاک'), findsOneWidget);
    expect(find.byType(IranianPlateInput), findsOneWidget);
    expect(find.text('پلاک با موفقیت شناسایی شد'), findsNothing);

    await tester.tap(find.text('تأیید و ادامه'));
    await tester.pumpAndSettle();

    expect(find.text('پلاک با موفقیت شناسایی شد'), findsOneWidget);
    expectIranianPlate45B12311Visible();
  });

  testWidgets('پلاک ناقص بدون تأیید اجازه ادامه نمی‌دهد', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vehicleRepositoryProvider.overrideWithValue(_FakeVehicleRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ConfirmPlateScreen(
            result: PlateRecognitionResult(
              rawText: '',
              normalizedPlate: '',
              firstTwoDigits: '',
              middleThreeDigits: '',
              letter: '',
              cityCode: '',
              confidence: 0,
              imagePath: '',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('تأیید و ادامه'));
    await tester.pump();

    expect(find.text('لطفاً همه بخش‌های پلاک را کامل کنید.'), findsOneWidget);
  });
}
