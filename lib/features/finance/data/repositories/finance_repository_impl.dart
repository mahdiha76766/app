import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../repair_orders/data/repositories/repair_order_repository_impl.dart';
import '../../domain/entities/finance_snapshot.dart';
import '../../domain/repositories/finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._db) : _repairs = RepairOrderRepositoryImpl(_db);

  final AppDatabase _db;
  final RepairOrderRepositoryImpl _repairs;

  @override
  Future<FinanceSnapshot> getSnapshot({
    required DateTime from,
    required DateTime to,
  }) async {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));

    final rows = await (_db.select(_db.repairOrders)
          ..where(
            (t) =>
                (t.status.equals(RepairOrderStatus.readyForDelivery.value) |
                    t.status.equals(RepairOrderStatus.delivered.value)) &
                t.completedAt.isBiggerOrEqualValue(start) &
                t.completedAt.isSmallerThanValue(end),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.completedAt)]))
        .get();

    var laborTotal = 0;
    var partsTotal = 0;
    var discountTotal = 0;
    var invoicedTotal = 0;
    var receivedTotal = 0;
    var outstandingTotal = 0;
    final byDay = <DateTime, FinanceDayPoint>{};

    for (final row in rows) {
      final totals = await _repairs.calculateInvoiceTotals(row.id);
      laborTotal += totals.laborAmount;
      partsTotal += totals.partsTotal;
      discountTotal += totals.discountAmount;
      invoicedTotal += totals.grandTotal;
      receivedTotal += totals.paidAmount;
      outstandingTotal += totals.remaining;

      final completed = row.completedAt ?? row.createdAt;
      final dayKey = DateTime(completed.year, completed.month, completed.day);
      final existing = byDay[dayKey];
      byDay[dayKey] = FinanceDayPoint(
        day: dayKey,
        invoicedTotal: (existing?.invoicedTotal ?? 0) + totals.grandTotal,
        receivedTotal: (existing?.receivedTotal ?? 0) + totals.paidAmount,
        repairCount: (existing?.repairCount ?? 0) + 1,
      );
    }

    final days = byDay.values.toList()
      ..sort((a, b) => a.day.compareTo(b.day));

    return FinanceSnapshot(
      invoicedTotal: invoicedTotal,
      receivedTotal: receivedTotal,
      outstandingTotal: outstandingTotal,
      laborTotal: laborTotal,
      partsTotal: partsTotal,
      discountTotal: discountTotal,
      repairCount: rows.length,
      daily: days,
    );
  }
}
