import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../formatters/text_normalizer.dart';
import 'app_database.dart';
import 'enums.dart';

/// داده آزمایشی فقط در حالت debug.
///
/// در release هرگز صدا زده نمی‌شود. با وجود حداقل یک مشتری با پیشوند `dev-`
/// دوباره اجرا نمی‌شود.
class DevSeedService {
  DevSeedService(this._db);

  final AppDatabase _db;
  static const _markerPrefix = 'dev-';

  /// اگر قبلاً seed آزمایشی زده شده باشد، کاری نمی‌کند.
  Future<void> seedIfNeeded() async {
    if (!kDebugMode) {
      return;
    }

    final existing = await (_db.select(_db.customers)
          ..where((t) => t.fullName.like('$_markerPrefix%'))
          ..limit(1))
        .get();
    if (existing.isNotEmpty) {
      return;
    }

    await _seed();
  }

  Future<void> _seed() async {
    final now = DateTime.now();
    const workshopId = 'dev-workshop-1';

    await _db.into(_db.workshops).insertOnConflictUpdate(
          WorkshopsCompanion.insert(
            id: workshopId,
            name: 'تعمیرگاه آزمایشی',
            phone: const Value('02112345678'),
            address: const Value('تهران'),
            createdAt: now,
          ),
        );

    final customerIds = <String>[];
    for (var i = 1; i <= 20; i++) {
      final id = '$_markerPrefix-cus-$i';
      customerIds.add(id);
      final isDebtor = i <= 5;
      await _db.into(_db.customers).insertOnConflictUpdate(
            CustomersCompanion.insert(
              id: id,
              fullName: Value('$_markerPrefix مشتری $i'),
              phone: Value('0912${(1000000 + i).toString().substring(1)}'),
              createdAt: now.subtract(Duration(days: 30 - i)),
              updatedAt: now,
            ),
          );
      // debtor flag is on repair orders, not customers — keep ids for later
      if (isDebtor) {
        // marked below via unpaid repairs
      }
    }

    final vehicleIds = <String>[];
    const models = [
      'پراید',
      'پژو ۲۰۶',
      'سمند',
      'دنا',
      'تیبا',
    ];
    for (var i = 1; i <= 25; i++) {
      final id = '$_markerPrefix-veh-$i';
      vehicleIds.add(id);
      final customerId = customerIds[(i - 1) % customerIds.length];
      final firstTwo = (10 + (i % 50)).toString().padLeft(2, '0');
      final middle = (100 + i).toString().padLeft(3, '0');
      final city = (10 + (i % 40)).toString().padLeft(2, '0');
      final plateNormalized = '$firstTwo-B-$middle-$city';
      final plateDisplay =
          '${_fa(firstTwo)} ب ${_fa(middle)} ایران ${_fa(city)}';
      await _db.into(_db.vehicles).insertOnConflictUpdate(
            VehiclesCompanion.insert(
              id: id,
              customerId: Value(customerId),
              plateNormalized: plateNormalized,
              plateDisplay: plateDisplay,
              manufacturer: const Value('ایران‌خودرو'),
              model: Value(models[(i - 1) % models.length]),
              lastMileage: Value(50000 + i * 1200),
              createdAt: now.subtract(Duration(days: 40 - (i % 20))),
              updatedAt: now,
            ),
          );
    }

    // Ensure catalog parts exist for attaching repair parts.
    final catalogParts = await (_db.select(_db.parts)
          ..where((t) => t.isActive.equals(true))
          ..limit(30))
        .get();

    final repairIds = <String>[];
    for (var i = 1; i <= 50; i++) {
      final id = '$_markerPrefix-ro-$i';
      repairIds.add(id);
      final vehicleId = vehicleIds[(i - 1) % vehicleIds.length];
      final customerId = customerIds[(i - 1) % customerIds.length];
      final completed = i <= 40;
      final isDebtor = i <= 5;
      final labor = 400000 + (i % 7) * 50000;
      final discount = i % 10 == 0 ? 100000 : 0;
      final partsEstimate = 800000 + (i % 5) * 200000;
      final grand = labor + partsEstimate - discount;
      final paid = isDebtor
          ? 0
          : (i % 8 == 0 ? grand ~/ 2 : grand);
      final payment = isDebtor
          ? PaymentStatus.unpaid
          : (i % 8 == 0 ? PaymentStatus.partial : PaymentStatus.paid);

      await _db.into(_db.repairOrders).insertOnConflictUpdate(
            RepairOrdersCompanion.insert(
              id: id,
              vehicleId: vehicleId,
              customerId: Value(customerId),
              status: completed
                  ? RepairOrderStatus.delivered.value
                  : RepairOrderStatus.inRepair.value,
              complaintText: Value('شکایت آزمایشی $i'),
              mileage: Value(50000 + i * 1000),
              laborAmount: Value(labor),
              discountAmount: Value(discount),
              paymentStatus: payment.value,
              paidAmount: Value(paid),
              createdAt: now.subtract(Duration(days: i)),
              completedAt: Value(
                completed ? now.subtract(Duration(days: i ~/ 2)) : null,
              ),
            ),
          );

      await _db.into(_db.repairServices).insertOnConflictUpdate(
            RepairServicesCompanion.insert(
              id: '$_markerPrefix-svc-$i',
              repairOrderId: id,
              title: i % 2 == 0 ? 'جلوبندی' : 'سرویس دوره‌ای',
              amount: const Value(0),
              createdAt: now.subtract(Duration(days: i)),
            ),
          );
    }

    // 100+ repair parts across repairs
    var partIndex = 0;
    for (var i = 0; i < 100; i++) {
      final repairId = repairIds[i % repairIds.length];
      final catalog = catalogParts.isEmpty
          ? null
          : catalogParts[i % catalogParts.length];
      final title = catalog?.title ?? 'قطعه آزمایشی ${i + 1}';
      final suppliedBy = i % 7 == 0
          ? PartSuppliedBy.customer
          : PartSuppliedBy.workshop;
      final unitPrice = 200000 + (i % 15) * 100000;
      final created = now.subtract(Duration(hours: i));

      await _db.into(_db.repairParts).insertOnConflictUpdate(
            RepairPartsCompanion.insert(
              id: '$_markerPrefix-rp-$i',
              repairOrderId: repairId,
              partId: Value(catalog?.id),
              partTitleSnapshot: title,
              brandSnapshot: Value(i % 3 == 0 ? 'برند $i' : null),
              quantity: Value(1 + (i % 3)),
              unitPrice: unitPrice,
              suppliedBy: suppliedBy.value,
              createdAt: created,
            ),
          );
      partIndex++;

      if (suppliedBy == PartSuppliedBy.workshop) {
        final model = 'پژو ۲۰۶';
        // چند قیمت تاریخی متفاوت برای یک عنوان
        for (var h = 0; h < 2; h++) {
          await _db.into(_db.partPriceHistory).insertOnConflictUpdate(
                PartPriceHistoryCompanion.insert(
                  id: '$_markerPrefix-price-$i-$h',
                  partId: Value(catalog?.id),
                  partTitleNormalized: TextNormalizer.normalize(title),
                  vehicleModel: Value(h == 0 ? model : 'پراید'),
                  amount: unitPrice + h * 150000,
                  repairOrderId: Value(repairId),
                  createdAt: created.subtract(Duration(days: h + 1)),
                ),
              );
        }
      }
    }

    // Due reminders
    for (var i = 1; i <= 6; i++) {
      final vehicleId = vehicleIds[i - 1];
      await _db.into(_db.reminders).insertOnConflictUpdate(
            RemindersCompanion.insert(
              id: '$_markerPrefix-rem-$i',
              vehicleId: vehicleId,
              repairOrderId: Value(repairIds[i - 1]),
              title: i % 2 == 0 ? 'تعویض روغن' : 'معاینه فنی',
              dueDate: Value(now.subtract(Duration(days: i))),
              dueMileage: Value(i % 2 == 0 ? 60000 + i * 100 : null),
              status: ReminderStatus.pending.value,
              createdAt: now.subtract(Duration(days: 20)),
            ),
          );
    }

    assert(partIndex >= 100);
  }

  static String _fa(String digits) {
    const map = {
      '0': '۰',
      '1': '۱',
      '2': '۲',
      '3': '۳',
      '4': '۴',
      '5': '۵',
      '6': '۶',
      '7': '۷',
      '8': '۸',
      '9': '۹',
    };
    return digits.split('').map((c) => map[c] ?? c).join();
  }
}
