import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../reminders/data/repositories/reminder_repository_impl.dart';
import '../../../repair_orders/data/repositories/repair_order_repository_impl.dart';
import '../../../vehicles/data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/active_repair.dart';
import '../../domain/entities/home_dashboard.dart';
import '../../domain/entities/recent_visit.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._db)
      : _vehicles = VehicleRepositoryImpl(_db),
        _reminders = ReminderRepositoryImpl(_db),
        _repairOrders = RepairOrderRepositoryImpl(_db);

  final AppDatabase _db;
  final VehicleRepositoryImpl _vehicles;
  final ReminderRepositoryImpl _reminders;
  final RepairOrderRepositoryImpl _repairOrders;

  Expression<bool> _countsForFinance($RepairOrdersTable t) =>
      t.status.equals(RepairOrderStatus.readyForDelivery.value) |
      t.status.equals(RepairOrderStatus.delivered.value);

  Expression<bool> _isOpen($RepairOrdersTable t) =>
      t.status.isNotValue(RepairOrderStatus.delivered.value) &
      t.status.isNotValue(RepairOrderStatus.cancelled.value);

  @override
  Future<HomeDashboard> getDashboard({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final start = DateTime(current.year, current.month, current.day);
    final end = start.add(const Duration(days: 1));

    final todayVehicles = await _vehicles.getVisitedToday(now: current);
    final dueReminders = await _reminders.getDueReminders(now: current);

    final debtOrders = await (_db.select(_db.repairOrders)
          ..where(
            (t) =>
                _countsForFinance(t) &
                (t.paymentStatus.equals(PaymentStatus.unpaid.value) |
                    t.paymentStatus.equals(PaymentStatus.partial.value)),
          ))
        .get();

    final completedToday = await (_db.select(_db.repairOrders)
          ..where(
            (t) =>
                _countsForFinance(t) &
                t.completedAt.isNotNull() &
                t.completedAt.isBiggerOrEqualValue(start) &
                t.completedAt.isSmallerThanValue(end),
          ))
        .get();

    var todayIncome = 0;
    for (final order in completedToday) {
      final totals = await _repairOrders.calculateInvoiceTotals(order.id);
      todayIncome += totals.paidAmount;
    }

    final activeRows = await (_db.select(_db.repairOrders)
          ..where(_isOpen)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    // اولویت نمایش: منتظر قطعه، آماده تحویل، سپس بقیه
    int statusRank(RepairOrderStatus s) => switch (s) {
          RepairOrderStatus.waitingForParts => 0,
          RepairOrderStatus.readyForDelivery => 1,
          RepairOrderStatus.inRepair => 2,
          RepairOrderStatus.awaitingReview => 3,
          RepairOrderStatus.accepted => 4,
          _ => 5,
        };

    final activeRepairs = <ActiveRepair>[];
    for (final order in activeRows) {
      final vehicle = await (_db.select(_db.vehicles)
            ..where((t) => t.id.equals(order.vehicleId)))
          .getSingleOrNull();
      final modelParts = <String>[
        if (vehicle?.manufacturer != null && vehicle!.manufacturer!.isNotEmpty)
          vehicle.manufacturer!,
        if (vehicle?.model != null && vehicle!.model!.isNotEmpty) vehicle.model!,
      ];
      final vehicleModel = modelParts.isEmpty
          ? (vehicle?.plateDisplay ?? 'خودرو')
          : modelParts.join(' ');
      final status = RepairOrderStatus.fromValue(order.status);
      activeRepairs.add(
        ActiveRepair(
          repairOrderId: order.id,
          vehicleId: order.vehicleId,
          vehicleModel: vehicleModel,
          plateDisplay: vehicle?.plateDisplay ?? '—',
          status: status,
          statusLabel: status.labelFa,
          updatedAt: order.createdAt,
          isDraft: status == RepairOrderStatus.accepted,
        ),
      );
    }
    activeRepairs.sort((a, b) {
      final byStatus = statusRank(a.status).compareTo(statusRank(b.status));
      if (byStatus != 0) return byStatus;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    final recentRows = await (_db.select(_db.repairOrders)
          ..where(
            (t) =>
                t.status.equals(RepairOrderStatus.delivered.value) |
                t.status.equals(RepairOrderStatus.readyForDelivery.value),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.completedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(5))
        .get();

    final recentVisits = <RecentVisit>[];
    for (final order in recentRows) {
      final vehicle = await (_db.select(_db.vehicles)
            ..where((t) => t.id.equals(order.vehicleId)))
          .getSingleOrNull();

      final services = await _repairOrders.getServices(order.id);
      final totals = await _repairOrders.calculateInvoiceTotals(order.id);

      final modelParts = <String>[
        if (vehicle?.manufacturer != null && vehicle!.manufacturer!.isNotEmpty)
          vehicle.manufacturer!,
        if (vehicle?.model != null && vehicle!.model!.isNotEmpty) vehicle.model!,
      ];
      final vehicleModel = modelParts.isEmpty
          ? (vehicle?.plateDisplay ?? 'خودرو')
          : modelParts.join(' ');

      final serviceType = services.isEmpty
          ? (order.complaintText?.trim().isNotEmpty == true
              ? order.complaintText!.trim()
              : 'بدون خدمت')
          : services.map((item) => item.title).join('، ');

      recentVisits.add(
        RecentVisit(
          repairOrderId: order.id,
          vehicleId: order.vehicleId,
          vehicleModel: vehicleModel,
          serviceType: serviceType,
          invoiceTotal: totals.grandTotal,
          visitDate: order.completedAt ?? order.createdAt,
        ),
      );
    }

    return HomeDashboard(
      todayVehicleCount: todayVehicles.length,
      todayIncome: todayIncome,
      dueReminderCount: dueReminders.length,
      unpaidDebtCount: debtOrders.length,
      activeRepairs: activeRepairs,
      recentVisits: recentVisits,
    );
  }
}
