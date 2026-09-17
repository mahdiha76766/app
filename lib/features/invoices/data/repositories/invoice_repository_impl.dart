import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../repair_orders/data/repositories/repair_order_repository_impl.dart';
import '../../domain/entities/invoice_list_item.dart';
import '../../domain/entities/invoice_totals.dart';
import '../../domain/entities/payment_transaction.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/services/invoice_calculator.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._db) : _repairs = RepairOrderRepositoryImpl(_db);

  final AppDatabase _db;
  final RepairOrderRepositoryImpl _repairs;

  @override
  Future<InvoiceTotals> calculateTotals(String repairOrderId) {
    return _repairs.calculateInvoiceTotals(repairOrderId);
  }

  @override
  Future<List<InvoiceListItem>> listInvoices({
    String query = '',
    PaymentStatus? paymentStatus,
    DateTime? from,
    DateTime? to,
  }) async {
    final start = from == null
        ? null
        : DateTime(from.year, from.month, from.day);
    final endExclusive = to == null
        ? null
        : DateTime(to.year, to.month, to.day).add(const Duration(days: 1));

    final rows = await (_db.select(_db.repairOrders)
          ..where(
            (t) =>
                (t.status.equals(RepairOrderStatus.readyForDelivery.value) |
                    t.status.equals(RepairOrderStatus.delivered.value)) &
                t.invoiceNumber.isNotNull(),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.completedAt),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();

    final q = query.trim().toLowerCase();
    final items = <InvoiceListItem>[];

    for (final row in rows) {
      final completedAt = row.completedAt ?? row.createdAt;
      if (start != null && completedAt.isBefore(start)) {
        continue;
      }
      if (endExclusive != null && !completedAt.isBefore(endExclusive)) {
        continue;
      }
      if (paymentStatus != null && row.paymentStatus != paymentStatus.value) {
        continue;
      }

      final item = await _toListItem(row);
      if (item == null) {
        continue;
      }
      if (q.isNotEmpty && !_matchesQuery(item, q)) {
        continue;
      }
      items.add(item);
    }
    return items;
  }

  @override
  Future<InvoiceListItem?> getInvoiceItem(String repairOrderId) async {
    final row = await (_db.select(_db.repairOrders)
          ..where((t) => t.id.equals(repairOrderId)))
        .getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _toListItem(row);
  }

  @override
  Future<List<PaymentTransaction>> listPayments(String repairOrderId) async {
    final rows = await (_db.select(_db.paymentTransactions)
          ..where((t) => t.repairOrderId.equals(repairOrderId))
          ..orderBy([(t) => OrderingTerm.desc(t.paidAt)]))
        .get();
    return rows.map(_mapPayment).toList();
  }

  @override
  Future<void> addPayment(PaymentTransaction payment) async {
    InvoiceCalculator.ensureNonNegative(payment.amount);
    if (payment.amount <= 0) {
      throw PaymentValidationException('مبلغ پرداخت باید بیشتر از صفر باشد.');
    }

    final totals = await calculateTotals(payment.repairOrderId);
    InvoiceCalculator.ensureNotExceedingRemaining(
      payment.amount,
      totals.remaining,
    );

    await _db.into(_db.paymentTransactions).insert(
          PaymentTransactionsCompanion.insert(
            id: payment.id,
            repairOrderId: payment.repairOrderId,
            amount: payment.amount,
            paidAt: payment.paidAt,
            method: payment.method.value,
            note: Value(payment.note),
            trackingCode: Value(payment.trackingCode),
            createdAt: payment.createdAt,
          ),
        );
    await syncPaymentState(payment.repairOrderId);
  }

  @override
  Future<void> deletePayment(String paymentId) async {
    final row = await (_db.select(_db.paymentTransactions)
          ..where((t) => t.id.equals(paymentId)))
        .getSingleOrNull();
    if (row == null) {
      return;
    }
    await (_db.delete(_db.paymentTransactions)
          ..where((t) => t.id.equals(paymentId)))
        .go();
    await syncPaymentState(row.repairOrderId);
  }

  @override
  Future<void> syncPaymentState(String repairOrderId) async {
    final payments = await listPayments(repairOrderId);
    final paidSum = payments.fold<int>(0, (sum, p) => sum + p.amount);
    final order = await _repairs.getById(repairOrderId);
    if (order == null) {
      return;
    }
    final totals = await _repairs.calculateInvoiceTotals(repairOrderId);
    final status = InvoiceCalculator.deriveStatus(
      paidAmount: paidSum,
      grandTotal: totals.grandTotal,
    );
    await (_db.update(_db.repairOrders)
          ..where((t) => t.id.equals(repairOrderId)))
        .write(
      RepairOrdersCompanion(
        paidAmount: Value(paidSum),
        paymentStatus: Value(status.value),
      ),
    );
  }

  /// اگر سفارش تکمیل شده ولی تراکنشی ندارد و paidAmount > 0، یک تراکنش بساز.
  Future<void> ensureLegacyPaymentSeeded(String repairOrderId) async {
    final order = await _repairs.getById(repairOrderId);
    if (order == null || order.paidAmount <= 0) {
      return;
    }
    final existing = await listPayments(repairOrderId);
    if (existing.isNotEmpty) {
      return;
    }
    final now = order.completedAt ?? DateTime.now();
    await _db.into(_db.paymentTransactions).insert(
          PaymentTransactionsCompanion.insert(
            id: const Uuid().v4(),
            repairOrderId: repairOrderId,
            amount: order.paidAmount,
            paidAt: now,
            method: PaymentMethod.other.value,
            note: const Value('ثبت اولیه هنگام تکمیل'),
            createdAt: now,
          ),
        );
  }

  Future<InvoiceListItem?> _toListItem(RepairOrderRow row) async {
    final invoiceNumber = row.invoiceNumber;
    if (invoiceNumber == null || invoiceNumber.isEmpty) {
      return null;
    }
    final vehicle = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(row.vehicleId)))
        .getSingleOrNull();
    if (vehicle == null) {
      return null;
    }
    CustomerRow? customer;
    final customerId = row.customerId ?? vehicle.customerId;
    if (customerId != null) {
      customer = await (_db.select(_db.customers)
            ..where((t) => t.id.equals(customerId)))
          .getSingleOrNull();
    }
    final totals = await calculateTotals(row.id);
    final modelParts = <String>[
      if (vehicle.manufacturer?.isNotEmpty == true) vehicle.manufacturer!,
      if (vehicle.model?.isNotEmpty == true) vehicle.model!,
    ];
    return InvoiceListItem(
      repairOrderId: row.id,
      invoiceNumber: invoiceNumber,
      completedAt: row.completedAt ?? row.createdAt,
      vehicleId: vehicle.id,
      plateDisplay: vehicle.plateDisplay,
      plateNormalized: vehicle.plateNormalized,
      vehicleModel: modelParts.isEmpty ? null : modelParts.join(' '),
      customerName: customer?.fullName,
      customerPhone: customer?.phone,
      paymentStatus: PaymentStatus.fromValue(row.paymentStatus),
      totals: totals,
    );
  }

  bool _matchesQuery(InvoiceListItem item, String q) {
    final haystack = [
      item.invoiceNumber,
      item.plateDisplay,
      item.plateNormalized,
      item.customerName ?? '',
      item.customerPhone ?? '',
      item.vehicleModel ?? '',
    ].join(' ').toLowerCase();
    return haystack.contains(q);
  }

  PaymentTransaction _mapPayment(PaymentTransactionRow row) {
    return PaymentTransaction(
      id: row.id,
      repairOrderId: row.repairOrderId,
      amount: row.amount,
      paidAt: row.paidAt,
      method: PaymentMethod.fromValue(row.method),
      note: row.note,
      trackingCode: row.trackingCode,
      createdAt: row.createdAt,
    );
  }
}
