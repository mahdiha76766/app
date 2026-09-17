/// ثابت‌های فرمت پشتیبان NediCar.
abstract final class BackupConstants {
  static const String formatId = 'nedicar-backup';
  static const int backupVersion = 1;
  static const int minSupportedBackupVersion = 1;
  static const int maxSupportedBackupVersion = 1;
  static const String appVersion = '1.0.0+1';
  static const int schemaVersion = 9;
  static const int maxLocalSnapshots = 3;
  static const String resetConfirmPhrase = 'حذف کامل';
}

enum BackupRestoreMode {
  replace,
  merge,
}

class BackupValidationException implements Exception {
  BackupValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BackupCounts {
  const BackupCounts({
    required this.workshops,
    required this.bankAccounts,
    required this.customers,
    required this.vehicles,
    required this.serviceCategories,
    required this.parts,
    required this.repairOrders,
    required this.repairStatusHistories,
    required this.vehicleMileageLogs,
    required this.repairServices,
    required this.repairParts,
    required this.partPriceHistory,
    required this.reminders,
    required this.paymentTransactions,
    required this.assistantMessages,
  });

  final int workshops;
  final int bankAccounts;
  final int customers;
  final int vehicles;
  final int serviceCategories;
  final int parts;
  final int repairOrders;
  final int repairStatusHistories;
  final int vehicleMileageLogs;
  final int repairServices;
  final int repairParts;
  final int partPriceHistory;
  final int reminders;
  final int paymentTransactions;
  final int assistantMessages;

  int get invoices => repairOrders;
  int get repairs => repairOrders;

  Map<String, int> toJson() => {
        'workshops': workshops,
        'bankAccounts': bankAccounts,
        'customers': customers,
        'vehicles': vehicles,
        'serviceCategories': serviceCategories,
        'parts': parts,
        'repairOrders': repairOrders,
        'repairStatusHistories': repairStatusHistories,
        'vehicleMileageLogs': vehicleMileageLogs,
        'repairServices': repairServices,
        'repairParts': repairParts,
        'partPriceHistory': partPriceHistory,
        'reminders': reminders,
        'paymentTransactions': paymentTransactions,
        'assistantMessages': assistantMessages,
      };

  factory BackupCounts.fromJson(Map<String, dynamic>? json) {
    int read(String key) => (json?[key] as num?)?.toInt() ?? 0;
    return BackupCounts(
      workshops: read('workshops'),
      bankAccounts: read('bankAccounts'),
      customers: read('customers'),
      vehicles: read('vehicles'),
      serviceCategories: read('serviceCategories'),
      parts: read('parts'),
      repairOrders: read('repairOrders'),
      repairStatusHistories: read('repairStatusHistories'),
      vehicleMileageLogs: read('vehicleMileageLogs'),
      repairServices: read('repairServices'),
      repairParts: read('repairParts'),
      partPriceHistory: read('partPriceHistory'),
      reminders: read('reminders'),
      paymentTransactions: read('paymentTransactions'),
      assistantMessages: read('assistantMessages'),
    );
  }

  factory BackupCounts.fromData(Map<String, List<Map<String, dynamic>>> data) {
    int len(String key) => data[key]?.length ?? 0;
    return BackupCounts(
      workshops: len('workshops'),
      bankAccounts: len('bankAccounts'),
      customers: len('customers'),
      vehicles: len('vehicles'),
      serviceCategories: len('serviceCategories'),
      parts: len('parts'),
      repairOrders: len('repairOrders'),
      repairStatusHistories: len('repairStatusHistories'),
      vehicleMileageLogs: len('vehicleMileageLogs'),
      repairServices: len('repairServices'),
      repairParts: len('repairParts'),
      partPriceHistory: len('partPriceHistory'),
      reminders: len('reminders'),
      paymentTransactions: len('paymentTransactions'),
      assistantMessages: len('assistantMessages'),
    );
  }
}

class NediCarBackupDocument {
  const NediCarBackupDocument({
    required this.backupVersion,
    required this.appVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.counts,
    required this.data,
  });

  final int backupVersion;
  final String appVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final BackupCounts counts;
  final Map<String, List<Map<String, dynamic>>> data;

  Map<String, dynamic> toJson() => {
        'format': BackupConstants.formatId,
        'backupVersion': backupVersion,
        'appVersion': appVersion,
        'schemaVersion': schemaVersion,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'counts': counts.toJson(),
        'data': data,
      };

  factory NediCarBackupDocument.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    if (rawData is! Map) {
      throw BackupValidationException('ساختار داده پشتیبان ناقص است.');
    }
    final data = <String, List<Map<String, dynamic>>>{};
    for (final entry in rawData.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is! List) {
        throw BackupValidationException('جدول «$key» در فایل پشتیبان نامعتبر است.');
      }
      data[key] = [
        for (final item in value)
          if (item is Map)
            Map<String, dynamic>.from(item)
          else
            throw BackupValidationException(
              'رکورد نامعتبر در جدول «$key».',
            ),
      ];
    }

    final createdRaw = json['createdAt'];
    final createdAt = createdRaw is String
        ? DateTime.tryParse(createdRaw)
        : null;
    if (createdAt == null) {
      throw BackupValidationException('تاریخ ایجاد پشتیبان نامعتبر است.');
    }

    return NediCarBackupDocument(
      backupVersion: (json['backupVersion'] as num?)?.toInt() ?? 0,
      appVersion: json['appVersion']?.toString() ?? '',
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 0,
      createdAt: createdAt,
      counts: BackupCounts.fromJson(
        json['counts'] is Map
            ? Map<String, dynamic>.from(json['counts'] as Map)
            : null,
      ),
      data: data,
    );
  }
}
