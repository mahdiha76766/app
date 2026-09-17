import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/database/mappers.dart';
import '../../../repair_orders/data/repositories/repair_order_repository_impl.dart';
import '../../domain/entities/vehicle_profile.dart';
import '../../domain/entities/vehicle_repair_summary.dart';
import '../../domain/repositories/vehicle_profile_repository.dart';

class VehicleProfileRepositoryImpl implements VehicleProfileRepository {
  VehicleProfileRepositoryImpl(this._db)
      : _repairOrders = RepairOrderRepositoryImpl(_db);

  final AppDatabase _db;
  final RepairOrderRepositoryImpl _repairOrders;

  @override
  Future<VehicleProfile?> getByVehicleId(
    String vehicleId, {
    int recentLimit = 3,
  }) async {
    final vehicleRow = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(vehicleId)))
        .getSingleOrNull();
    if (vehicleRow == null) {
      return null;
    }

    final vehicle = vehicleRow.toDomain();
    final customer = vehicle.customerId == null
        ? null
        : (await (_db.select(_db.customers)
              ..where((t) => t.id.equals(vehicle.customerId!)))
            .getSingleOrNull())
            ?.toDomain();

    final recentOrders = await (_db.select(_db.repairOrders)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.completedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(recentLimit))
        .get();

    final summaries = <VehicleRepairSummary>[];
    DateTime? lastVisitAt;

    for (final order in recentOrders) {
      // فقط تعمیرهای تمام‌شده در سابقه بیاید؛ draft فعلی نباید اینجا دیده شود.
      if (order.status != RepairOrderStatus.delivered.value &&
          order.status != RepairOrderStatus.readyForDelivery.value &&
          order.status != RepairOrderStatus.cancelled.value) {
        continue;
      }
      final services = await _repairOrders.getServices(order.id);
      final parts = await _repairOrders.getParts(order.id);
      final totals = await _repairOrders.calculateInvoiceTotals(order.id);
      final visitDate = order.completedAt ?? order.createdAt;
      lastVisitAt ??= visitDate;

      final complaint = order.complaintText?.trim();
      final servicesTitle = (complaint != null && complaint.isNotEmpty)
          ? complaint
          : (services.isEmpty
              ? 'بدون شرح'
              : services.map((item) => item.title).join('، '));

      final mainParts = parts.isEmpty
          ? 'بدون قطعه'
          : parts.take(3).map((item) => item.partTitleSnapshot).join('، ');

      summaries.add(
        VehicleRepairSummary(
          repairOrderId: order.id,
          servicesTitle: servicesTitle,
          mainParts: mainParts,
          finalAmount: totals.grandTotal,
          visitDate: visitDate,
          mileage: order.mileage,
        ),
      );
    }

    if (lastVisitAt == null) {
      final latest = await (_db.select(_db.repairOrders)
            ..where((t) => t.vehicleId.equals(vehicleId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();
      lastVisitAt = latest?.completedAt ?? latest?.createdAt;
    }

    return VehicleProfile(
      vehicle: vehicle,
      customer: customer,
      lastVisitAt: lastVisitAt,
      recentRepairs: summaries,
    );
  }
}
