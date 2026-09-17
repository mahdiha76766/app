import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../domain/backup_models.dart';
import '../domain/safe_backup_log.dart';

/// ساخت، اعتبارسنجی و بازیابی پشتیبان محلی.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const _tableKeys = <String>[
    'workshops',
    'bankAccounts',
    'customers',
    'vehicles',
    'serviceCategories',
    'parts',
    'repairOrders',
    'repairStatusHistories',
    'vehicleMileageLogs',
    'repairServices',
    'repairParts',
    'partPriceHistory',
    'reminders',
    'paymentTransactions',
    'assistantMessages',
  ];

  Future<NediCarBackupDocument> createDocument({DateTime? now}) async {
    final data = await _exportAllTables();
    final counts = BackupCounts.fromData(data);
    return NediCarBackupDocument(
      backupVersion: BackupConstants.backupVersion,
      appVersion: BackupConstants.appVersion,
      schemaVersion: BackupConstants.schemaVersion,
      createdAt: now ?? DateTime.now().toUtc(),
      counts: counts,
      data: data,
    );
  }

  Future<File> exportToFile({Directory? directory, DateTime? now}) async {
    final doc = await createDocument(now: now);
    final dir = directory ?? await getTemporaryDirectory();
    final stamp = _fileStamp(now ?? DateTime.now());
    final file = File(p.join(dir.path, 'nedicar-backup-$stamp.json'));
    final encoded = const JsonEncoder.withIndent('  ').convert(doc.toJson());
    await file.writeAsString(encoded, flush: true);
    SafeBackupLog.info(
      'backup exported tables=${doc.counts.vehicles}v/${doc.counts.repairs}r',
    );
    return file;
  }

  /// Parse + validate بدون اعمال روی دیتابیس.
  NediCarBackupDocument parseAndValidate(String rawJson) {
    if (rawJson.trim().isEmpty) {
      throw BackupValidationException('فایل پشتیبان خالی است.');
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } catch (_) {
      throw BackupValidationException(
        'فایل پشتیبان خراب است و قابل خواندن نیست.',
      );
    }

    if (decoded is! Map) {
      throw BackupValidationException('ساختار فایل پشتیبان نامعتبر است.');
    }

    final json = Map<String, dynamic>.from(decoded);
    final format = json['format']?.toString();
    if (format != BackupConstants.formatId) {
      throw BackupValidationException(
        'این فایل پشتیبان NediCar نیست.',
      );
    }

    final version = (json['backupVersion'] as num?)?.toInt() ?? 0;
    if (version < BackupConstants.minSupportedBackupVersion ||
        version > BackupConstants.maxSupportedBackupVersion) {
      throw BackupValidationException(
        'نسخه پشتیبان ($version) با این نسخه برنامه سازگار نیست.',
      );
    }

    final doc = NediCarBackupDocument.fromJson(json);
    for (final key in _tableKeys) {
      doc.data.putIfAbsent(key, () => <Map<String, dynamic>>[]);
    }
    _validateRecordShapes(doc.data);
    return doc;
  }

  Future<NediCarBackupDocument> validateFile(File file) async {
    if (!await file.exists()) {
      throw BackupValidationException('فایل پشتیبان پیدا نشد.');
    }
    final raw = await file.readAsString();
    return parseAndValidate(raw);
  }

  Future<void> restore(
    NediCarBackupDocument document, {
    required BackupRestoreMode mode,
  }) async {
    // مهاجرت آینده: اگر schemaVersion قدیمی‌تر بود، data را تبدیل کن
    final migrated = _migrateDocumentIfNeeded(document);

    try {
      await _db.transaction(() async {
        if (mode == BackupRestoreMode.replace) {
          await _clearAllUserDataInTransaction();
        }
        await _importAll(migrated.data, merge: mode == BackupRestoreMode.merge);
      });
      SafeBackupLog.info(
        'restore ok mode=${mode.name} vehicles=${migrated.counts.vehicles}',
      );
    } catch (e) {
      SafeBackupLog.error('restore failed; transaction rolled back', e);
      rethrow;
    }
  }

  NediCarBackupDocument _migrateDocumentIfNeeded(NediCarBackupDocument doc) {
    // backupVersion 1 / schema تا 7 فعلاً بدون تبدیل
    if (doc.schemaVersion > BackupConstants.schemaVersion) {
      throw BackupValidationException(
        'این پشتیبان مربوط به نسخه جدیدتر برنامه است و قابل بازیابی نیست.',
      );
    }
    return doc;
  }

  void _validateRecordShapes(Map<String, List<Map<String, dynamic>>> data) {
    for (final key in _tableKeys) {
      for (final row in data[key] ?? const []) {
        if (!row.containsKey('id') || row['id'] == null) {
          throw BackupValidationException(
            'رکوردی بدون شناسه در «$key» یافت شد.',
          );
        }
      }
    }
  }

  Future<Map<String, List<Map<String, dynamic>>>> _exportAllTables() async {
    Future<List<Map<String, dynamic>>> mapRows<T extends DataClass>(
      Future<List<T>> Function() query,
      Map<String, dynamic> Function(T row) toJson,
    ) async {
      final rows = await query();
      return [for (final row in rows) toJson(row)];
    }

    return {
      'workshops': await mapRows(
        () => _db.select(_db.workshops).get(),
        (r) => r.toJson(),
      ),
      'bankAccounts': await mapRows(
        () => _db.select(_db.bankAccounts).get(),
        (r) => r.toJson(),
      ),
      'customers': await mapRows(
        () => _db.select(_db.customers).get(),
        (r) => r.toJson(),
      ),
      'vehicles': await mapRows(
        () => _db.select(_db.vehicles).get(),
        (r) => r.toJson(),
      ),
      'serviceCategories': await mapRows(
        () => _db.select(_db.serviceCategories).get(),
        (r) => r.toJson(),
      ),
      'parts': await mapRows(
        () => _db.select(_db.parts).get(),
        (r) => r.toJson(),
      ),
      'repairOrders': await mapRows(
        () => _db.select(_db.repairOrders).get(),
        (r) => r.toJson(),
      ),
      'repairStatusHistories': await mapRows(
        () => _db.select(_db.repairStatusHistories).get(),
        (r) => r.toJson(),
      ),
      'vehicleMileageLogs': await mapRows(
        () => _db.select(_db.vehicleMileageLogs).get(),
        (r) => r.toJson(),
      ),
      'repairServices': await mapRows(
        () => _db.select(_db.repairServices).get(),
        (r) => r.toJson(),
      ),
      'repairParts': await mapRows(
        () => _db.select(_db.repairParts).get(),
        (r) => r.toJson(),
      ),
      'partPriceHistory': await mapRows(
        () => _db.select(_db.partPriceHistory).get(),
        (r) => r.toJson(),
      ),
      'reminders': await mapRows(
        () => _db.select(_db.reminders).get(),
        (r) => r.toJson(),
      ),
      'paymentTransactions': await mapRows(
        () => _db.select(_db.paymentTransactions).get(),
        (r) => r.toJson(),
      ),
      'assistantMessages': await mapRows(
        () => _db.select(_db.assistantMessages).get(),
        (r) => r.toJson(),
      ),
    };
  }

  Future<void> _clearAllUserDataInTransaction() async {
    await _db.delete(_db.paymentTransactions).go();
    await _db.delete(_db.assistantMessages).go();
    await _db.delete(_db.repairParts).go();
    await _db.delete(_db.repairServices).go();
    await _db.delete(_db.partPriceHistory).go();
    await _db.delete(_db.reminders).go();
    await _db.delete(_db.repairStatusHistories).go();
    await _db.delete(_db.vehicleMileageLogs).go();
    await _db.delete(_db.repairOrders).go();
    await _db.delete(_db.vehicles).go();
    await _db.delete(_db.customers).go();
    await _db.delete(_db.bankAccounts).go();
    await _db.delete(_db.parts).go();
    await _db.delete(_db.serviceCategories).go();
    await _db.delete(_db.workshops).go();
  }

  Future<void> _importAll(
    Map<String, List<Map<String, dynamic>>> data, {
    required bool merge,
  }) async {
    Future<void> upsertAll<T extends Table, D>(
      TableInfo<T, D> table,
      List<Map<String, dynamic>> rows,
      Insertable<D> Function(Map<String, dynamic> json) companion,
    ) async {
      for (final row in rows) {
        final entity = companion(row);
        if (merge) {
          await _db.into(table).insertOnConflictUpdate(entity);
        } else {
          await _db.into(table).insert(entity);
        }
      }
    }

    await upsertAll(
      _db.workshops,
      data['workshops'] ?? const [],
      (j) => WorkshopRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.bankAccounts,
      data['bankAccounts'] ?? const [],
      (j) => BankAccountRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.customers,
      data['customers'] ?? const [],
      (j) => CustomerRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.serviceCategories,
      data['serviceCategories'] ?? const [],
      (j) => ServiceCategoryRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.parts,
      data['parts'] ?? const [],
      (j) => PartRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.vehicles,
      data['vehicles'] ?? const [],
      (j) => VehicleRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.repairOrders,
      data['repairOrders'] ?? const [],
      (j) => RepairOrderRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.repairStatusHistories,
      data['repairStatusHistories'] ?? const [],
      (j) => RepairStatusHistoryRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.vehicleMileageLogs,
      data['vehicleMileageLogs'] ?? const [],
      (j) => VehicleMileageLogRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.repairServices,
      data['repairServices'] ?? const [],
      (j) => RepairServiceRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.repairParts,
      data['repairParts'] ?? const [],
      (j) => RepairPartRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.partPriceHistory,
      data['partPriceHistory'] ?? const [],
      (j) => PartPriceHistoryRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.reminders,
      data['reminders'] ?? const [],
      (j) => ReminderRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.paymentTransactions,
      data['paymentTransactions'] ?? const [],
      (j) => PaymentTransactionRow.fromJson(j).toCompanion(true),
    );
    await upsertAll(
      _db.assistantMessages,
      data['assistantMessages'] ?? const [],
      (j) => AssistantMessageRow.fromJson(j).toCompanion(true),
    );
  }

  String _fileStamp(DateTime dt) {
    final local = dt.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)}_'
        '${two(local.hour)}${two(local.minute)}${two(local.second)}';
  }
}
