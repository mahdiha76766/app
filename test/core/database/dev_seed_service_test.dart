import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/dev_seed_service.dart';
import 'package:mechanic_assistant/core/database/enums.dart';

void main() {
  test('DevSeedService داده آزمایشی کافی می‌سازد', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Force seed path even if kDebugMode differs in test by calling private flow via public API.
    // seedIfNeeded only runs body when kDebugMode; in flutter test kDebugMode is true.
    await DevSeedService(db).seedIfNeeded();

    final customers = await db.select(db.customers).get();
    final vehicles = await db.select(db.vehicles).get();
    final repairs = await db.select(db.repairOrders).get();
    final parts = await db.select(db.repairParts).get();
    final prices = await db.select(db.partPriceHistory).get();
    final reminders = await db.select(db.reminders).get();

    final devCustomers =
        customers.where((c) => (c.fullName ?? '').startsWith('dev-')).length;
    expect(devCustomers, greaterThanOrEqualTo(20));
    expect(vehicles.where((v) => v.id.startsWith('dev-')).length,
        greaterThanOrEqualTo(25));
    expect(repairs.where((r) => r.id.startsWith('dev-')).length,
        greaterThanOrEqualTo(50));
    expect(parts.where((p) => p.id.startsWith('dev-')).length,
        greaterThanOrEqualTo(100));
    expect(prices.where((p) => p.id.startsWith('dev-')).length, greaterThan(10));
    expect(
      repairs
          .where(
            (r) =>
                r.id.startsWith('dev-') &&
                r.paymentStatus == PaymentStatus.unpaid.value,
          )
          .length,
      greaterThanOrEqualTo(5),
    );
    expect(reminders.where((r) => r.id.startsWith('dev-')).length,
        greaterThanOrEqualTo(6));

    // Idempotent
    await DevSeedService(db).seedIfNeeded();
    final customersAfter = await db.select(db.customers).get();
    expect(
      customersAfter.where((c) => (c.fullName ?? '').startsWith('dev-')).length,
      devCustomers,
    );
  });
}
