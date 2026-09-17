import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:uuid/uuid.dart';

import '../../features/invoices/domain/services/invoice_number_formatter.dart';
import 'enums.dart';
import 'seed/app_database_seeder.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Workshops,
    BankAccounts,
    Customers,
    Vehicles,
    ServiceCategories,
    Parts,
    RepairOrders,
    RepairServices,
    RepairParts,
    PartPriceHistory,
    Reminders,
    PaymentTransactions,
    RepairStatusHistories,
    VehicleMileageLogs,
    AssistantMessages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// برای تست با دیتابیس حافظه.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await AppDatabaseSeeder(this).seedIfNeeded();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(workshops, workshops.mechanicName);
          }
          if (from < 3) {
            await m.addColumn(workshops, workshops.morningHour);
            await m.addColumn(workshops, workshops.afternoonHour);
            await m.addColumn(workshops, workshops.nightHour);
          }
          if (from < 4) {
            await m.addColumn(workshops, workshops.enableWhatsApp);
            await m.addColumn(workshops, workshops.enableTelegram);
            await m.addColumn(workshops, workshops.enableSms);
            await m.addColumn(workshops, workshops.nextInvoiceNumber);
            await m.addColumn(repairOrders, repairOrders.invoiceNumber);
          }
          if (from < 5) {
            await m.addColumn(workshops, workshops.includeBankInfoInMessages);
            await m.createTable(bankAccounts);
          }
          if (from < 6) {
            await m.addColumn(bankAccounts, bankAccounts.accountHolderName);
          }
          if (from < 7) {
            await m.addColumn(workshops, workshops.invoiceSeqYear);
            await m.createTable(paymentTransactions);
            await customStatement(
              'CREATE UNIQUE INDEX IF NOT EXISTS '
              'uq_repair_orders_invoice_number '
              'ON repair_orders(invoice_number)',
            );
            await _migrateInvoiceNumbersAndPaymentsV7();
          }
          if (from < 8) {
            await m.addColumn(repairOrders, repairOrders.cancelReason);
            await m.addColumn(repairOrders, repairOrders.deliveredAt);
            await m.createTable(repairStatusHistories);
            await m.createTable(vehicleMileageLogs);
            await m.addColumn(reminders, reminders.lastNotifiedAt);
            await m.addColumn(reminders, reminders.lastNotificationKind);
            await m.addColumn(reminders, reminders.intervalDays);
            await m.addColumn(reminders, reminders.intervalMileage);
            await _migrateRepairStatusesV8();
          }
          if (from < 9) {
            await m.createTable(assistantMessages);
          }
        },
      );

  Future<void> _migrateRepairStatusesV8() async {
    await customStatement(
      "UPDATE repair_orders SET status = 'accepted' WHERE status = 'draft'",
    );
    await customStatement(
      "UPDATE repair_orders SET status = 'inRepair' WHERE status = 'inProgress'",
    );
    await customStatement(
      "UPDATE repair_orders SET status = 'delivered', "
      "delivered_at = COALESCE(completed_at, created_at) "
      "WHERE status = 'completed'",
    );

    // لاگ کارکرد اولیه از تعمیرهای دارای mileage
    final orders = await (select(repairOrders)
          ..where((t) => t.mileage.isNotNull()))
        .get();
    for (final order in orders) {
      final mileage = order.mileage;
      if (mileage == null) continue;
      await into(vehicleMileageLogs).insert(
        VehicleMileageLogsCompanion.insert(
          id: 'mig-${order.id}',
          vehicleId: order.vehicleId,
          repairOrderId: Value(order.id),
          mileage: mileage,
          recordedAt: order.completedAt ?? order.createdAt,
          note: const Value('مهاجرت از کارکرد تعمیر'),
        ),
      );
    }
  }

  /// تبدیل شماره‌های قدیمی/خالی به فرمت ترتیبی و ایجاد تراکنش از paidAmount.
  Future<void> _migrateInvoiceNumbersAndPaymentsV7() async {
    final completed = await (select(repairOrders)
          ..where(
            (t) => t.status.equals(RepairOrderStatus.delivered.value),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.completedAt),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();

    final seqByYear = <int, int>{};

    // ابتدا حداکثر شماره‌های ترتیبی موجود را ثبت کن
    for (final order in completed) {
      final current = order.invoiceNumber;
      if (InvoiceNumberFormatter.isSequentialFormat(current)) {
        final year = InvoiceNumberFormatter.parseYear(current!)!;
        final seq = InvoiceNumberFormatter.parseSequence(current)!;
        final prev = seqByYear[year] ?? 0;
        if (seq > prev) {
          seqByYear[year] = seq;
        }
      }
    }

    for (final order in completed) {
      final current = order.invoiceNumber;
      if (!InvoiceNumberFormatter.isSequentialFormat(current)) {
        final at = order.completedAt ?? order.createdAt;
        final year = InvoiceNumberFormatter.jalaliYearOf(at);
        final next = (seqByYear[year] ?? 0) + 1;
        seqByYear[year] = next;
        final number = InvoiceNumberFormatter.format(
          jalaliYear: year,
          sequence: next,
        );
        await (update(repairOrders)..where((t) => t.id.equals(order.id)))
            .write(RepairOrdersCompanion(invoiceNumber: Value(number)));
      }

      if (order.paidAmount > 0) {
        final existing = await (select(paymentTransactions)
              ..where((t) => t.repairOrderId.equals(order.id)))
            .get();
        if (existing.isEmpty) {
          final paidAt = order.completedAt ?? order.createdAt;
          await into(paymentTransactions).insert(
            PaymentTransactionsCompanion.insert(
              id: const Uuid().v4(),
              repairOrderId: order.id,
              amount: order.paidAmount,
              paidAt: paidAt,
              method: PaymentMethod.other.value,
              note: const Value('مهاجرت از سیستم قبلی'),
              createdAt: paidAt,
            ),
          );
        }
      }
    }

    final currentYear = Jalali.now().year;
    final workshopRows = await select(workshops).get();
    for (final workshop in workshopRows) {
      await (update(workshops)..where((t) => t.id.equals(workshop.id))).write(
        WorkshopsCompanion(
          invoiceSeqYear: Value(currentYear),
          nextInvoiceNumber: Value((seqByYear[currentYear] ?? 0) + 1),
        ),
      );
    }
  }

  /// تخصیص امن شماره فاکتور ترتیبی داخل تراکنش DB.
  Future<String> allocateNextInvoiceNumber({
    required DateTime at,
  }) {
    return transaction(() async {
      final year = InvoiceNumberFormatter.jalaliYearOf(at);
      final workshop = await (select(workshops)..limit(1)).getSingleOrNull();
      if (workshop == null) {
        // بدون کارگاه: از حداکثر موجود + ۱ استفاده کن
        return _allocateFromExistingMax(year);
      }

      var next = workshop.nextInvoiceNumber;
      final storedYear = workshop.invoiceSeqYear;
      if (storedYear != year) {
        next = 1;
      }

      // اطمینان از یکتایی حتی اگر شمارنده عقب باشد
      while (true) {
        final candidate = InvoiceNumberFormatter.format(
          jalaliYear: year,
          sequence: next,
        );
        final clash = await (select(repairOrders)
              ..where((t) => t.invoiceNumber.equals(candidate)))
            .getSingleOrNull();
        if (clash == null) {
          await (update(workshops)..where((t) => t.id.equals(workshop.id)))
              .write(
            WorkshopsCompanion(
              invoiceSeqYear: Value(year),
              nextInvoiceNumber: Value(next + 1),
            ),
          );
          return candidate;
        }
        next += 1;
      }
    });
  }

  Future<String> _allocateFromExistingMax(int year) async {
    final rows = await (select(repairOrders)
          ..where((t) => t.invoiceNumber.isNotNull()))
        .get();
    var maxSeq = 0;
    for (final row in rows) {
      final number = row.invoiceNumber;
      if (InvoiceNumberFormatter.parseYear(number ?? '') == year) {
        final seq = InvoiceNumberFormatter.parseSequence(number!) ?? 0;
        if (seq > maxSeq) {
          maxSeq = seq;
        }
      }
    }
    return InvoiceNumberFormatter.format(
      jalaliYear: year,
      sequence: maxSeq + 1,
    );
  }

  Future<void> deleteAllRepairData() async {
    await batch((b) {
      b.deleteAll(paymentTransactions);
      b.deleteAll(assistantMessages);
      b.deleteAll(repairStatusHistories);
      b.deleteAll(vehicleMileageLogs);
      b.deleteAll(repairParts);
      b.deleteAll(repairServices);
      b.deleteAll(partPriceHistory);
      b.deleteAll(repairOrders);
    });
  }

  Future<void> deleteAllVehicleData() async {
    await batch((b) {
      b.deleteAll(paymentTransactions);
      b.deleteAll(assistantMessages);
      b.deleteAll(repairStatusHistories);
      b.deleteAll(vehicleMileageLogs);
      b.deleteAll(repairParts);
      b.deleteAll(repairServices);
      b.deleteAll(partPriceHistory);
      b.deleteAll(reminders);
      b.deleteAll(repairOrders);
      b.deleteAll(vehicles);
      b.deleteAll(customers);
    });
  }

  Future<void> deleteVehicle(String vehicleId) async {
    final orderIds = await (select(repairOrders)
          ..where((t) => t.vehicleId.equals(vehicleId)))
        .map((row) => row.id)
        .get();
    await batch((b) {
      for (final orderId in orderIds) {
        b.deleteWhere(
          paymentTransactions,
          (t) => t.repairOrderId.equals(orderId),
        );
        b.deleteWhere(
          assistantMessages,
          (t) => t.repairOrderId.equals(orderId),
        );
        b.deleteWhere(
          repairStatusHistories,
          (t) => t.repairOrderId.equals(orderId),
        );
        b.deleteWhere(repairParts, (t) => t.repairOrderId.equals(orderId));
        b.deleteWhere(repairServices, (t) => t.repairOrderId.equals(orderId));
        b.deleteWhere(partPriceHistory, (t) => t.repairOrderId.equals(orderId));
      }
      b.deleteWhere(vehicleMileageLogs, (t) => t.vehicleId.equals(vehicleId));
      b.deleteWhere(repairOrders, (t) => t.vehicleId.equals(vehicleId));
      b.deleteWhere(reminders, (t) => t.vehicleId.equals(vehicleId));
      b.deleteWhere(vehicles, (t) => t.id.equals(vehicleId));
    });
  }

  Future<void> deleteRepairOrder(String repairOrderId) async {
    await batch((b) {
      b.deleteWhere(
        paymentTransactions,
        (t) => t.repairOrderId.equals(repairOrderId),
      );
      b.deleteWhere(
        assistantMessages,
        (t) => t.repairOrderId.equals(repairOrderId),
      );
      b.deleteWhere(
        repairStatusHistories,
        (t) => t.repairOrderId.equals(repairOrderId),
      );
      b.deleteWhere(
        vehicleMileageLogs,
        (t) => t.repairOrderId.equals(repairOrderId),
      );
      b.deleteWhere(repairParts, (t) => t.repairOrderId.equals(repairOrderId));
      b.deleteWhere(
        repairServices,
        (t) => t.repairOrderId.equals(repairOrderId),
      );
      b.deleteWhere(
        partPriceHistory,
        (t) => t.repairOrderId.equals(repairOrderId),
      );
      b.deleteWhere(repairOrders, (t) => t.id.equals(repairOrderId));
    });
  }

  Future<void> resetAll() async {
    await batch((b) {
      b.deleteAll(paymentTransactions);
      b.deleteAll(assistantMessages);
      b.deleteAll(repairStatusHistories);
      b.deleteAll(vehicleMileageLogs);
      b.deleteAll(repairParts);
      b.deleteAll(repairServices);
      b.deleteAll(partPriceHistory);
      b.deleteAll(reminders);
      b.deleteAll(repairOrders);
      b.deleteAll(vehicles);
      b.deleteAll(customers);
      b.deleteAll(bankAccounts);
      b.deleteAll(parts);
      b.deleteAll(serviceCategories);
      b.deleteAll(workshops);
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'mechanic_assistant',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationDocumentsDirectory,
    ),
  );
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
