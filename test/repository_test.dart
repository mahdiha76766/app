import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/core/formatters/text_normalizer.dart';
import 'package:mechanic_assistant/features/parts/data/repositories/part_repository_impl.dart';
import 'package:mechanic_assistant/features/parts/domain/entities/part.dart';
import 'package:mechanic_assistant/features/repair_orders/data/repositories/repair_order_repository_impl.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_part.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';

void main() {
  late AppDatabase db;
  late VehicleRepositoryImpl vehicles;
  late PartRepositoryImpl parts;
  late RepairOrderRepositoryImpl repairOrders;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    vehicles = VehicleRepositoryImpl(db);
    parts = PartRepositoryImpl(db);
    repairOrders = RepairOrderRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('ذخیره و پیدا کردن خودرو با پلاک', () async {
    final now = DateTime(2026, 7, 20, 10);
    final vehicle = Vehicle(
      id: 'veh-1',
      plateNormalized: TextNormalizer.normalizePlate('۴۵ ب ۱۲۳ ایران ۱۱'),
      plateDisplay: '۴۵ ب ۱۲۳ ایران ۱۱',
      manufacturer: 'پژو',
      model: '۲۰۶',
      createdAt: now,
      updatedAt: now,
    );

    await vehicles.upsert(vehicle);

    final found = await vehicles.findByPlateNormalized(
      TextNormalizer.normalizePlate('45ب123ایران11'),
    );

    expect(found, isNotNull);
    expect(found!.id, 'veh-1');
    expect(found.plateNormalized, '45-B-123-11');
    expect(found.plateDisplay, '۴۵ ب ۱۲۳ ایران ۱۱');
    expect(found.model, '۲۰۶');
  });

  test('آخرین قیمت قطعه با اولویت مدل خودرو', () async {
    final now = DateTime(2026, 7, 20, 10);
    final title = TextNormalizer.normalize('لنت جلو');

    await parts.recordPrice(
      id: 'price-1',
      partTitleNormalized: title,
      vehicleModel: 'پراید',
      amount: 800000,
      createdAt: now,
    );
    await parts.recordPrice(
      id: 'price-2',
      partTitleNormalized: title,
      vehicleModel: '۲۰۶',
      amount: 1200000,
      createdAt: now.add(const Duration(minutes: 1)),
    );
    await parts.recordPrice(
      id: 'price-3',
      partTitleNormalized: title,
      amount: 900000,
      createdAt: now.add(const Duration(minutes: 2)),
    );

    final for206 = await parts.getLatestPrice(
      normalizedTitle: title,
      vehicleModel: '۲۰۶',
    );
    final forPride = await parts.getLatestPrice(
      normalizedTitle: title,
      vehicleModel: 'پراید',
    );
    final withoutModel = await parts.getLatestPrice(
      normalizedTitle: title,
    );
    final unknownModel = await parts.getLatestPrice(
      normalizedTitle: title,
      vehicleModel: 'ساندرو',
    );

    expect(for206, 1200000);
    expect(forPride, 800000);
    expect(withoutModel, 900000);
    expect(unknownModel, 900000);
  });

  test('محاسبه جمع فاکتور و حذف قطعه مشتری از جمع قطعات', () async {
    final now = DateTime(2026, 7, 20, 11);

    await vehicles.upsert(
      Vehicle(
        id: 'veh-2',
        plateNormalized: '21-B-345-67',
        plateDisplay: '۲۱ب ۳۴۵ ایران ۶۷',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repairOrders.create(
      RepairOrder(
        id: 'ro-1',
        vehicleId: 'veh-2',
        status: RepairOrderStatus.inRepair,
        laborAmount: 500000,
        discountAmount: 100000,
        paymentStatus: PaymentStatus.unpaid,
        paidAmount: 0,
        createdAt: now,
      ),
    );

    await repairOrders.addService(
      RepairService(
        id: 'svc-1',
        repairOrderId: 'ro-1',
        title: 'اجرت تعویض لنت',
        amount: 200000,
        createdAt: now,
      ),
    );

    await repairOrders.addPart(
      RepairPart(
        id: 'rp-workshop',
        repairOrderId: 'ro-1',
        partTitleSnapshot: 'لنت جلو',
        quantity: 1,
        unitPrice: 1200000,
        suppliedBy: PartSuppliedBy.workshop,
        createdAt: now,
      ),
    );

    await repairOrders.addPart(
      RepairPart(
        id: 'rp-customer',
        repairOrderId: 'ro-1',
        partTitleSnapshot: 'دیسک ترمز',
        quantity: 2,
        unitPrice: 1500000,
        suppliedBy: PartSuppliedBy.customer,
        createdAt: now,
      ),
    );

    final totals = await repairOrders.calculateInvoiceTotals('ro-1');

    expect(totals.laborAmount, 500000);
    expect(totals.servicesTotal, 200000);
    expect(totals.partsTotal, 1200000);
    expect(totals.discountAmount, 100000);
    // subtotal = parts + labor (اجرت کل)؛ مبلغ خدمات جداگانه در جمع نیست.
    expect(totals.subtotal, 1700000);
    expect(totals.grandTotal, 1600000);
    expect(totals.partsTotal, isNot(3000000));
  });

  test('به‌روزرسانی قطعه تعمیر و قطعات پرتکرار تعمیرگاه', () async {
    final now = DateTime(2026, 7, 20, 12);

    await vehicles.upsert(
      Vehicle(
        id: 'veh-3',
        plateNormalized: '11-A-111-11',
        plateDisplay: '۱۱ الف ۱۱۱ ایران ۱۱',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await parts.upsert(
      Part(
        id: 'part-a',
        title: 'فیلتر روغن',
        normalizedTitle: TextNormalizer.normalize('فیلتر روغن'),
        usageCount: 5,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await parts.upsert(
      Part(
        id: 'part-b',
        title: 'شمع',
        normalizedTitle: TextNormalizer.normalize('شمع'),
        usageCount: 2,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    final popular = await parts.getPopularWorkshop(limit: 12);
    expect(popular.first.id, 'part-a');
    expect(popular.any((item) => item.id == 'part-b'), isTrue);

    await repairOrders.create(
      RepairOrder(
        id: 'ro-2',
        vehicleId: 'veh-3',
        status: RepairOrderStatus.inRepair,
        laborAmount: 0,
        discountAmount: 0,
        paymentStatus: PaymentStatus.unpaid,
        paidAmount: 0,
        createdAt: now,
      ),
    );

    await repairOrders.addPart(
      RepairPart(
        id: 'rp-1',
        repairOrderId: 'ro-2',
        partId: 'part-a',
        partTitleSnapshot: 'فیلتر روغن',
        quantity: 1,
        unitPrice: 0,
        suppliedBy: PartSuppliedBy.workshop,
        createdAt: now,
      ),
    );

    await repairOrders.updatePart(
      RepairPart(
        id: 'rp-1',
        repairOrderId: 'ro-2',
        partId: 'part-a',
        partTitleSnapshot: 'فیلتر روغن',
        quantity: 2,
        unitPrice: 350000,
        suppliedBy: PartSuppliedBy.workshop,
        createdAt: now,
      ),
    );

    final updated = await repairOrders.getParts('ro-2');
    expect(updated.single.quantity, 2);
    expect(updated.single.unitPrice, 350000);
  });

  test('پایان تعمیر: وضعیت، کارکرد، usage و تاریخچه قیمت', () async {
    final now = DateTime(2026, 7, 20, 13);

    await vehicles.upsert(
      Vehicle(
        id: 'veh-4',
        plateNormalized: '22-B-222-22',
        plateDisplay: '۲۲ ب ۲۲۲ ایران ۲۲',
        model: '۲۰۶',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await parts.upsert(
      Part(
        id: 'part-complete',
        title: 'لنت جلو',
        normalizedTitle: TextNormalizer.normalize('لنت جلو'),
        usageCount: 1,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await repairOrders.create(
      RepairOrder(
        id: 'ro-complete',
        vehicleId: 'veh-4',
        status: RepairOrderStatus.inRepair,
        mileage: 125000,
        laborAmount: 400000,
        discountAmount: 0,
        paymentStatus: PaymentStatus.paid,
        paidAmount: 1600000,
        createdAt: now,
      ),
    );

    await repairOrders.addPart(
      RepairPart(
        id: 'rp-complete',
        repairOrderId: 'ro-complete',
        partId: 'part-complete',
        partTitleSnapshot: 'لنت جلو',
        quantity: 1,
        unitPrice: 1200000,
        suppliedBy: PartSuppliedBy.workshop,
        createdAt: now,
      ),
    );

    await repairOrders.addPart(
      RepairPart(
        id: 'rp-customer-complete',
        repairOrderId: 'ro-complete',
        partTitleSnapshot: 'دیسک مشتری',
        quantity: 1,
        unitPrice: 900000,
        suppliedBy: PartSuppliedBy.customer,
        createdAt: now,
      ),
    );

    await repairOrders.completeRepair('ro-complete', completedAt: now);

    final completed = await repairOrders.getById('ro-complete');
    expect(completed!.status, RepairOrderStatus.readyForDelivery);
    expect(completed.completedAt, now);

    final vehicle = await vehicles.getById('veh-4');
    expect(vehicle!.lastMileage, 125000);

    final part = await parts.getById('part-complete');
    expect(part!.usageCount, 2);

    final price = await parts.getLatestPrice(
      normalizedTitle: TextNormalizer.normalize('لنت جلو'),
      vehicleModel: '۲۰۶',
    );
    expect(price, 1200000);

    final totals = await repairOrders.calculateInvoiceTotals('ro-complete');
    expect(totals.partsTotal, 1200000);
    expect(totals.grandTotal, 1600000);
  });
}
