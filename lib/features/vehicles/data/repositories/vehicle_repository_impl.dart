import 'package:drift/drift.dart';

import '../../../../core/formatters/iranian_plate_normalizer.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/mappers.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_list_item.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Vehicle?> findByPlateNormalized(String plateNormalized) async {
    for (final key in IranianPlateNormalizer.lookupKeys(plateNormalized)) {
      final row = await (_db.select(_db.vehicles)
            ..where((t) => t.plateNormalized.equals(key)))
          .getSingleOrNull();
      if (row != null) {
        return row.toDomain();
      }
    }
    return null;
  }

  @override
  Future<Vehicle?> getById(String id) async {
    final row = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Vehicle>> getAll() async {
    final rows = await (_db.select(_db.vehicles)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<VehicleListItem>> listWithVisitStats({
    DateTime? visitsFrom,
    DateTime? visitsTo,
  }) async {
    final vehicles = await getAll();
    if (vehicles.isEmpty) {
      return const [];
    }

    final customers = await _db.select(_db.customers).get();
    final customerNames = <String, String>{
      for (final c in customers)
        if (c.fullName != null && c.fullName!.trim().isNotEmpty)
          c.id: c.fullName!.trim(),
    };

    final ordersQuery = _db.select(_db.repairOrders);
    if (visitsFrom != null) {
      ordersQuery.where(
        (t) => t.createdAt.isBiggerOrEqualValue(visitsFrom),
      );
    }
    if (visitsTo != null) {
      final end = DateTime(visitsTo.year, visitsTo.month, visitsTo.day)
          .add(const Duration(days: 1));
      ordersQuery.where((t) => t.createdAt.isSmallerThanValue(end));
    }
    final orders = await ordersQuery.get();

    final counts = <String, int>{};
    final lastVisit = <String, DateTime>{};
    for (final order in orders) {
      counts[order.vehicleId] = (counts[order.vehicleId] ?? 0) + 1;
      final stamp = order.completedAt ?? order.createdAt;
      final prev = lastVisit[order.vehicleId];
      if (prev == null || stamp.isAfter(prev)) {
        lastVisit[order.vehicleId] = stamp;
      }
    }

    final filtered = visitsFrom == null && visitsTo == null
        ? vehicles
        : vehicles.where((v) => (counts[v.id] ?? 0) > 0).toList();

    final items = filtered
        .map(
          (vehicle) => VehicleListItem(
            vehicle: vehicle,
            customerName: vehicle.customerId == null
                ? null
                : customerNames[vehicle.customerId!],
            visitCount: counts[vehicle.id] ?? 0,
            lastVisitAt: lastVisit[vehicle.id],
          ),
        )
        .toList()
      ..sort((a, b) {
        final aDate = a.lastVisitAt ?? a.vehicle.updatedAt;
        final bDate = b.lastVisitAt ?? b.vehicle.updatedAt;
        return bDate.compareTo(aDate);
      });

    return items;
  }

  @override
  Future<List<Vehicle>> getVisitedToday({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final start = DateTime(current.year, current.month, current.day);
    final end = start.add(const Duration(days: 1));

    final query = _db.select(_db.vehicles).join([
      innerJoin(
        _db.repairOrders,
        _db.repairOrders.vehicleId.equalsExp(_db.vehicles.id),
      ),
    ])
      ..where(
        _db.repairOrders.createdAt.isBiggerOrEqualValue(start) &
            _db.repairOrders.createdAt.isSmallerThanValue(end),
      )
      ..orderBy([OrderingTerm.desc(_db.repairOrders.createdAt)]);

    final rows = await query.get();
    final seen = <String>{};
    final vehicles = <Vehicle>[];
    for (final row in rows) {
      final vehicle = row.readTable(_db.vehicles).toDomain();
      if (seen.add(vehicle.id)) {
        vehicles.add(vehicle);
      }
    }
    return vehicles;
  }

  @override
  Future<void> upsert(Vehicle vehicle) async {
    await _db.into(_db.vehicles).insertOnConflictUpdate(vehicle.toCompanion());
  }
}
