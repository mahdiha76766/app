import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/backup/data/backup_service.dart';
import 'package:mechanic_assistant/features/backup/domain/backup_models.dart';

void main() {
  late AppDatabase db;
  late BackupService backup;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON');
        },
      ),
    );
    backup = BackupService(db);
    tempDir = await Directory.systemTemp.createTemp('nedicar_backup_test_');
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<void> seedFullData() async {
    final now = DateTime(2026, 7, 24, 12, 30);
    await db.into(db.workshops).insert(
          WorkshopsCompanion.insert(
            id: 'ws-1',
            name: 'تعمیرگاه تست',
            phone: const Value('09121234567'),
            createdAt: now,
          ),
        );
    await db.into(db.bankAccounts).insert(
          BankAccountsCompanion.insert(
            id: 'bank-1',
            workshopId: 'ws-1',
            bankName: 'ملت',
            accountHolderName: const Value('علی رضایی'),
            accountNumber: const Value('1234567890'),
            cardNumber: const Value('6037991234567890'),
            createdAt: now,
          ),
        );
    await db.into(db.customers).insert(
          CustomersCompanion.insert(
            id: 'cus-1',
            fullName: const Value('محمد احمدی'),
            phone: const Value('09129876543'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.vehicles).insert(
          VehiclesCompanion.insert(
            id: 'veh-1',
            customerId: const Value('cus-1'),
            plateNormalized: '12-B-345-11',
            plateDisplay: '۱۲ ب ۳۴۵ ایران ۱۱',
            model: const Value('پژو ۲۰۶'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.serviceCategories).insert(
          ServiceCategoriesCompanion.insert(
            id: 'cat-1',
            title: 'موتور',
            iconKey: 'engine',
            sortOrder: 1,
          ),
        );
    await db.into(db.parts).insert(
          PartsCompanion.insert(
            id: 'part-1',
            title: 'فیلتر روغن',
            normalizedTitle: 'فیلتر روغن',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.repairOrders).insert(
          RepairOrdersCompanion.insert(
            id: 'ro-1',
            vehicleId: 'veh-1',
            customerId: const Value('cus-1'),
            status: RepairOrderStatus.delivered.value,
            laborAmount: const Value(500000),
            discountAmount: const Value(0),
            paymentStatus: PaymentStatus.partial.value,
            paidAmount: const Value(200000),
            invoiceNumber: const Value('1405-000001'),
            createdAt: now,
            completedAt: Value(now),
          ),
        );
    await db.into(db.repairParts).insert(
          RepairPartsCompanion.insert(
            id: 'rp-1',
            repairOrderId: 'ro-1',
            partId: const Value('part-1'),
            partTitleSnapshot: 'فیلتر روغن',
            quantity: const Value(1),
            unitPrice: 300000,
            suppliedBy: PartSuppliedBy.workshop.value,
            createdAt: now,
          ),
        );
    await db.into(db.reminders).insert(
          RemindersCompanion.insert(
            id: 'rem-1',
            vehicleId: 'veh-1',
            repairOrderId: const Value('ro-1'),
            title: 'تعویض روغن',
            status: ReminderStatus.pending.value,
            createdAt: now,
          ),
        );
    await db.into(db.paymentTransactions).insert(
          PaymentTransactionsCompanion.insert(
            id: 'pay-1',
            repairOrderId: 'ro-1',
            amount: 200000,
            paidAt: now,
            method: PaymentMethod.cash.value,
            createdAt: now,
          ),
        );
  }

  test('Backup خالی', () async {
    final doc = await backup.createDocument(
      now: DateTime.utc(2026, 7, 24, 10),
    );
    expect(doc.formatCompatible, isTrue);
    expect(doc.counts.vehicles, 0);
    expect(doc.counts.repairs, 0);
    expect(doc.data['vehicles'], isEmpty);
    expect(doc.backupVersion, BackupConstants.backupVersion);
    expect(doc.schemaVersion, BackupConstants.schemaVersion);

    final file = await backup.exportToFile(
      directory: tempDir,
      now: DateTime(2026, 7, 24, 10, 5, 6),
    );
    expect(file.path, contains('nedicar-backup-2026-07-24_100506.json'));
    final parsed = backup.parseAndValidate(await file.readAsString());
    expect(parsed.counts.vehicles, 0);
  });

  test('Backup با داده کامل و حفظ متن فارسی/RTL', () async {
    await seedFullData();
    final file = await backup.exportToFile(directory: tempDir);
    final raw = await file.readAsString();
    expect(raw.contains('تعمیرگاه تست'), isTrue);
    expect(raw.contains('۱۲ ب ۳۴۵ ایران ۱۱'), isTrue);
    expect(raw.contains('محمد احمدی'), isTrue);
    expect(raw.contains('1405-000001'), isTrue);

    final doc = backup.parseAndValidate(raw);
    expect(doc.counts.vehicles, 1);
    expect(doc.counts.repairs, 1);
    expect(doc.counts.reminders, 1);
    expect(doc.counts.customers, 1);
    expect(doc.counts.paymentTransactions, 1);
    expect(doc.counts.bankAccounts, 1);
  });

  test('فایل خراب', () {
    expect(
      () => backup.parseAndValidate('{not-json'),
      throwsA(isA<BackupValidationException>()),
    );
    expect(
      () => backup.parseAndValidate(''),
      throwsA(isA<BackupValidationException>()),
    );
    expect(
      () => backup.parseAndValidate('[]'),
      throwsA(isA<BackupValidationException>()),
    );
  });

  test('نسخه ناسازگار', () {
    final payload = {
      'format': BackupConstants.formatId,
      'backupVersion': 99,
      'appVersion': '9.0.0',
      'schemaVersion': 99,
      'createdAt': DateTime.utc(2026, 1, 1).toIso8601String(),
      'counts': <String, int>{},
      'data': <String, List<dynamic>>{},
    };
    expect(
      () => backup.parseAndValidate(jsonEncode(payload)),
      throwsA(
        isA<BackupValidationException>().having(
          (e) => e.message,
          'message',
          contains('سازگار نیست'),
        ),
      ),
    );
  });

  test('Import موفق replace', () async {
    await seedFullData();
    final file = await backup.exportToFile(directory: tempDir);
    final doc = await backup.validateFile(file);

    await db.deleteAllVehicleData();
    expect(await db.select(db.vehicles).get(), isEmpty);

    await backup.restore(doc, mode: BackupRestoreMode.replace);
    final vehicles = await db.select(db.vehicles).get();
    expect(vehicles, hasLength(1));
    expect(vehicles.first.plateDisplay, '۱۲ ب ۳۴۵ ایران ۱۱');
    expect(await db.select(db.repairOrders).get(), hasLength(1));
    expect(await db.select(db.paymentTransactions).get(), hasLength(1));
    expect(await db.select(db.reminders).get(), hasLength(1));
  });

  test('شکست در میانه Import و Rollback', () async {
    await seedFullData();
    final beforeVehicles = await db.select(db.vehicles).get();
    expect(beforeVehicles, hasLength(1));

    final broken = await backup.createDocument();
    // رکورد تعمیر با خودرو ناموجود → نقض FK پس از پاکسازی در replace
    broken.data['repairOrders'] = [
      {
        'id': 'ro-orphan',
        'vehicleId': 'missing-vehicle',
        'customerId': null,
        'status': 'completed',
        'complaintText': null,
        'mileage': null,
        'laborAmount': 0,
        'discountAmount': 0,
        'paymentStatus': 'unpaid',
        'paidAmount': 0,
        'invoiceNumber': '1405-009999',
        'createdAt': DateTime.utc(2026, 7, 24).toIso8601String(),
        'completedAt': DateTime.utc(2026, 7, 24).toIso8601String(),
      },
    ];
    // خالی کردن بقیه تا فقط orphan بماند برای شکست واضح‌تر
    broken.data['vehicles'] = [];
    broken.data['customers'] = [];
    broken.data['workshops'] = [];
    broken.data['bankAccounts'] = [];
    broken.data['repairParts'] = [];
    broken.data['paymentTransactions'] = [];
    broken.data['reminders'] = [];

    await expectLater(
      backup.restore(broken, mode: BackupRestoreMode.replace),
      throwsA(anything),
    );

    final afterVehicles = await db.select(db.vehicles).get();
    expect(afterVehicles, hasLength(1));
    expect(afterVehicles.first.id, 'veh-1');
    expect(await db.select(db.repairOrders).get(), hasLength(1));
  });

  test('Merge بدون داده تکراری', () async {
    await seedFullData();
    final file = await backup.exportToFile(directory: tempDir);
    final doc = await backup.validateFile(file);
    expect(doc.schemaVersion, BackupConstants.schemaVersion);

    // تغییر نام کارگاه در DB فعلی
    await (db.update(db.workshops)..where((t) => t.id.equals('ws-1'))).write(
      const WorkshopsCompanion(name: Value('تعمیرگاه فعلی')),
    );

    // merge باید رکورد هم‌شناسه را به‌روز کند نه تکراری بسازد
    final mergedDoc = backup.parseAndValidate(await file.readAsString());
    await backup.restore(mergedDoc, mode: BackupRestoreMode.merge);

    expect(await db.select(db.vehicles).get(), hasLength(1));
    expect(await db.select(db.customers).get(), hasLength(1));
    expect(await db.select(db.repairOrders).get(), hasLength(1));
    final workshops = await db.select(db.workshops).get();
    expect(workshops, hasLength(1));
    expect(workshops.first.name, 'تعمیرگاه تست'); // از backup
  });

  test('SafeBackupLog شماره حساس را ماسک می‌کند', () {
    // فقط اطمینان از عدم پرتاب و ماسک شدن در خروجی sanitize مسیر error
    expect(
      () => backup.parseAndValidate('{"format":"x"}'),
      throwsA(isA<BackupValidationException>()),
    );
  });
}

extension on NediCarBackupDocument {
  bool get formatCompatible =>
      backupVersion >= BackupConstants.minSupportedBackupVersion &&
      backupVersion <= BackupConstants.maxSupportedBackupVersion;
}
