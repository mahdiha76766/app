import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/database/mappers.dart';
import '../../../../core/formatters/text_normalizer.dart';
import '../../../invoices/domain/entities/invoice_totals.dart';
import '../../../invoices/domain/services/invoice_calculator.dart';
import '../../domain/entities/repair_order.dart';
import '../../domain/entities/repair_part.dart';
import '../../domain/entities/repair_service.dart';
import '../../domain/repositories/repair_order_repository.dart';
import '../../domain/services/repair_workflow.dart';

class RepairOrderRepositoryImpl implements RepairOrderRepository {
  RepairOrderRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<RepairOrder?> getById(String id) async {
    final row = await (_db.select(_db.repairOrders)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<RepairOrder>> getHistoryForVehicle(String vehicleId) async {
    final rows = await (_db.select(_db.repairOrders)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<void> create(RepairOrder order) async {
    await _db.into(_db.repairOrders).insert(order.toCompanion());
    await _appendStatusHistory(
      repairOrderId: order.id,
      from: null,
      to: order.status,
      at: order.createdAt,
      note: 'ایجاد پذیرش',
    );
  }

  @override
  Future<void> update(RepairOrder order) async {
    await (_db.update(_db.repairOrders)..where((t) => t.id.equals(order.id)))
        .write(order.toCompanion());
  }

  @override
  Future<void> changeStatus({
    required String repairOrderId,
    required RepairOrderStatus to,
    String? note,
    DateTime? at,
  }) async {
    final order = await getById(repairOrderId);
    if (order == null) return;
    RepairWorkflow.ensureCanTransition(order.status, to);
    if (order.status == to) return;

    // پایان تعمیر باید فاکتور و تاریخچه قیمت را هم بسازد.
    if (to == RepairOrderStatus.readyForDelivery) {
      await completeRepair(repairOrderId, completedAt: at);
      return;
    }
    if (to == RepairOrderStatus.delivered) {
      await deliverRepair(repairOrderId, deliveredAt: at);
      return;
    }

    final when = at ?? DateTime.now();
    await (_db.update(_db.repairOrders)..where((t) => t.id.equals(order.id)))
        .write(
      RepairOrdersCompanion(
        status: Value(to.value),
        cancelReason: to == RepairOrderStatus.cancelled
            ? Value(note)
            : const Value.absent(),
      ),
    );
    await _appendStatusHistory(
      repairOrderId: order.id,
      from: order.status,
      to: to,
      at: when,
      note: note,
    );
  }

  @override
  Future<RepairPart> addPart(RepairPart part) async {
    await _db.into(_db.repairParts).insert(part.toCompanion());
    return part;
  }

  @override
  Future<void> updatePart(RepairPart part) async {
    await (_db.update(_db.repairParts)..where((t) => t.id.equals(part.id)))
        .write(part.toCompanion());
  }

  @override
  Future<void> removePart(String repairPartId) async {
    await (_db.delete(_db.repairParts)..where((t) => t.id.equals(repairPartId)))
        .go();
  }

  @override
  Future<RepairService> addService(RepairService service) async {
    await _db.into(_db.repairServices).insert(service.toCompanion());
    return service;
  }

  @override
  Future<void> updateService(RepairService service) async {
    await (_db.update(_db.repairServices)..where((t) => t.id.equals(service.id)))
        .write(service.toCompanion());
  }

  @override
  Future<void> removeService(String repairServiceId) async {
    await (_db.delete(_db.repairServices)
          ..where((t) => t.id.equals(repairServiceId)))
        .go();
  }

  @override
  Future<List<RepairPart>> getParts(String repairOrderId) async {
    final rows = await (_db.select(_db.repairParts)
          ..where((t) => t.repairOrderId.equals(repairOrderId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<List<RepairService>> getServices(String repairOrderId) async {
    final rows = await (_db.select(_db.repairServices)
          ..where((t) => t.repairOrderId.equals(repairOrderId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<InvoiceTotals> calculateInvoiceTotals(String repairOrderId) async {
    final order = await getById(repairOrderId);
    if (order == null) {
      return InvoiceCalculator.compute(
        laborAmount: 0,
        servicesTotal: 0,
        partsTotal: 0,
        discountAmount: 0,
        paidAmount: 0,
      );
    }

    final services = await getServices(repairOrderId);
    final parts = await getParts(repairOrderId);

    final servicesTotal =
        services.fold<int>(0, (sum, item) => sum + item.amount);
    final partsTotal = parts
        .where((item) => item.suppliedBy == PartSuppliedBy.workshop)
        .fold<int>(0, (sum, item) => sum + item.lineTotal);

    final paymentRows = await (_db.select(_db.paymentTransactions)
          ..where((t) => t.repairOrderId.equals(repairOrderId)))
        .get();
    final paidFromTx = paymentRows.fold<int>(0, (sum, row) => sum + row.amount);
    final paidAmount = paymentRows.isEmpty ? order.paidAmount : paidFromTx;

    return InvoiceCalculator.compute(
      laborAmount: order.laborAmount,
      servicesTotal: servicesTotal,
      partsTotal: partsTotal,
      discountAmount: order.discountAmount,
      paidAmount: paidAmount,
    );
  }

  @override
  Future<void> completeRepair(
    String repairOrderId, {
    DateTime? completedAt,
  }) async {
    final order = await getById(repairOrderId);
    if (order == null) return;
    if (order.status == RepairOrderStatus.readyForDelivery ||
        order.status == RepairOrderStatus.delivered) {
      return;
    }

    final doneAt = completedAt ?? DateTime.now();
    RepairWorkflow.ensureCanTransition(
      order.status,
      RepairOrderStatus.readyForDelivery,
    );

    final parts = await getParts(repairOrderId);
    final vehicle = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(order.vehicleId)))
        .getSingleOrNull();

    for (final part in parts) {
      if (part.partId != null) {
        final existing = await (_db.select(_db.parts)
              ..where((t) => t.id.equals(part.partId!)))
            .getSingleOrNull();
        if (existing != null) {
          await (_db.update(_db.parts)..where((t) => t.id.equals(part.partId!)))
              .write(
            PartsCompanion(
              usageCount: Value(existing.usageCount + 1),
              updatedAt: Value(doneAt),
            ),
          );
        }
      }

      if (part.suppliedBy == PartSuppliedBy.workshop && part.unitPrice > 0) {
        await _db.into(_db.partPriceHistory).insert(
              PartPriceHistoryCompanion.insert(
                id: 'complete-${part.id}-${doneAt.microsecondsSinceEpoch}',
                partId: Value(part.partId),
                partTitleNormalized:
                    TextNormalizer.normalize(part.partTitleSnapshot),
                vehicleModel: Value(vehicle?.model),
                amount: part.unitPrice,
                repairOrderId: Value(repairOrderId),
                createdAt: doneAt,
              ),
            );
      }
    }

    var invoiceNo = order.invoiceNumber;
    if (invoiceNo == null || invoiceNo.isEmpty) {
      invoiceNo = await _db.allocateNextInvoiceNumber(at: doneAt);
    }

    await (_db.update(_db.repairOrders)
          ..where((t) => t.id.equals(repairOrderId)))
        .write(
      RepairOrdersCompanion(
        status: Value(RepairOrderStatus.readyForDelivery.value),
        completedAt: Value(doneAt),
        invoiceNumber: Value(invoiceNo),
      ),
    );
    await _appendStatusHistory(
      repairOrderId: repairOrderId,
      from: order.status,
      to: RepairOrderStatus.readyForDelivery,
      at: doneAt,
      note: 'پایان تعمیر — آماده تحویل',
    );

    if (order.paidAmount > 0) {
      final existingPayments = await (_db.select(_db.paymentTransactions)
            ..where((t) => t.repairOrderId.equals(repairOrderId)))
          .get();
      if (existingPayments.isEmpty) {
        final method = switch (order.paymentStatus) {
          PaymentStatus.paid => PaymentMethod.cash,
          PaymentStatus.partial => PaymentMethod.cash,
          PaymentStatus.unpaid => PaymentMethod.other,
        };
        await _db.into(_db.paymentTransactions).insert(
              PaymentTransactionsCompanion.insert(
                id: const Uuid().v4(),
                repairOrderId: repairOrderId,
                amount: order.paidAmount,
                paidAt: doneAt,
                method: method.value,
                note: const Value('ثبت هنگام پایان تعمیر'),
                createdAt: doneAt,
              ),
            );
      }
    }

    if (order.mileage != null) {
      await recordMileage(
        vehicleId: order.vehicleId,
        mileage: order.mileage!,
        repairOrderId: repairOrderId,
        recordedAt: doneAt,
        allowDecrease: true,
      );
    }
  }

  @override
  Future<void> deliverRepair(
    String repairOrderId, {
    DateTime? deliveredAt,
  }) async {
    final order = await getById(repairOrderId);
    if (order == null) return;
    if (order.status == RepairOrderStatus.delivered) return;

    RepairWorkflow.ensureCanTransition(
      order.status,
      RepairOrderStatus.delivered,
    );
    final when = deliveredAt ?? DateTime.now();
    await (_db.update(_db.repairOrders)..where((t) => t.id.equals(order.id)))
        .write(
      RepairOrdersCompanion(
        status: Value(RepairOrderStatus.delivered.value),
        deliveredAt: Value(when),
      ),
    );
    await _appendStatusHistory(
      repairOrderId: order.id,
      from: order.status,
      to: RepairOrderStatus.delivered,
      at: when,
      note: 'تحویل به مشتری',
    );
  }

  @override
  Future<void> cancelRepair(
    String repairOrderId, {
    String? reason,
  }) async {
    final order = await getById(repairOrderId);
    if (order == null) return;
    if (order.status == RepairOrderStatus.cancelled) return;

    RepairWorkflow.ensureCanTransition(
      order.status,
      RepairOrderStatus.cancelled,
    );
    final when = DateTime.now();
    await (_db.update(_db.repairOrders)..where((t) => t.id.equals(order.id)))
        .write(
      RepairOrdersCompanion(
        status: Value(RepairOrderStatus.cancelled.value),
        cancelReason: Value(reason),
      ),
    );
    await _appendStatusHistory(
      repairOrderId: order.id,
      from: order.status,
      to: RepairOrderStatus.cancelled,
      at: when,
      note: reason,
    );
  }

  @override
  Future<void> recordMileage({
    required String vehicleId,
    required int mileage,
    String? repairOrderId,
    DateTime? recordedAt,
    String? note,
    bool allowDecrease = false,
  }) async {
    final vehicle = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(vehicleId)))
        .getSingleOrNull();
    if (vehicle == null) return;

    final prev = vehicle.lastMileage;
    if (prev != null && mileage < prev && !allowDecrease) {
      throw StateError('کارکرد کمتر از آخرین مقدار است.');
    }

    final at = recordedAt ?? DateTime.now();
    await _db.into(_db.vehicleMileageLogs).insert(
          VehicleMileageLogsCompanion.insert(
            id: const Uuid().v4(),
            vehicleId: vehicleId,
            repairOrderId: Value(repairOrderId),
            mileage: mileage,
            recordedAt: at,
            note: Value(note),
          ),
        );
    await (_db.update(_db.vehicles)..where((t) => t.id.equals(vehicleId)))
        .write(
      VehiclesCompanion(
        lastMileage: Value(mileage),
        updatedAt: Value(at),
      ),
    );
  }

  @override
  Future<List<VehicleMileageLogRow>> listMileageLogs(String vehicleId) {
    return (_db.select(_db.vehicleMileageLogs)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .get();
  }

  @override
  Future<List<RepairStatusHistoryRow>> listStatusHistory(String repairOrderId) {
    return (_db.select(_db.repairStatusHistories)
          ..where((t) => t.repairOrderId.equals(repairOrderId))
          ..orderBy([(t) => OrderingTerm.desc(t.changedAt)]))
        .get();
  }

  Future<void> _appendStatusHistory({
    required String repairOrderId,
    required RepairOrderStatus? from,
    required RepairOrderStatus to,
    required DateTime at,
    String? note,
  }) async {
    await _db.into(_db.repairStatusHistories).insert(
          RepairStatusHistoriesCompanion.insert(
            id: const Uuid().v4(),
            repairOrderId: repairOrderId,
            fromStatus: Value(from?.value),
            toStatus: to.value,
            changedAt: at,
            note: Value(note),
          ),
        );
  }
}
