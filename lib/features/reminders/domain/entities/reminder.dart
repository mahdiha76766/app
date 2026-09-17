import '../../../../core/database/enums.dart';

/// نوع معیار سررسید یادآوری.
enum ReminderDueKind {
  date,
  mileage,
  both,
}

class Reminder {
  const Reminder({
    required this.id,
    required this.vehicleId,
    this.repairOrderId,
    required this.title,
    this.dueDate,
    this.dueMileage,
    required this.status,
    required this.createdAt,
    this.lastNotifiedAt,
    this.lastNotificationKind,
    this.intervalDays,
    this.intervalMileage,
  });

  final String id;
  final String vehicleId;
  final String? repairOrderId;
  final String title;
  final DateTime? dueDate;
  final int? dueMileage;
  final ReminderStatus status;
  final DateTime createdAt;
  final DateTime? lastNotifiedAt;
  final String? lastNotificationKind;
  final int? intervalDays;
  final int? intervalMileage;

  ReminderDueKind get dueKind {
    final hasDate = dueDate != null;
    final hasMileage = dueMileage != null;
    if (hasDate && hasMileage) {
      return ReminderDueKind.both;
    }
    if (hasMileage) {
      return ReminderDueKind.mileage;
    }
    return ReminderDueKind.date;
  }

  /// شناسه پایدار اعلان محلی.
  int get notificationRequestId => id.hashCode & 0x7fffffff;

  Reminder copyWith({
    String? id,
    String? vehicleId,
    String? repairOrderId,
    String? title,
    DateTime? dueDate,
    int? dueMileage,
    ReminderStatus? status,
    DateTime? createdAt,
    DateTime? lastNotifiedAt,
    String? lastNotificationKind,
    int? intervalDays,
    int? intervalMileage,
    bool clearRepairOrderId = false,
    bool clearDueDate = false,
    bool clearDueMileage = false,
    bool clearLastNotifiedAt = false,
    bool clearLastNotificationKind = false,
    bool clearIntervalDays = false,
    bool clearIntervalMileage = false,
  }) {
    return Reminder(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      repairOrderId: clearRepairOrderId
          ? null
          : (repairOrderId ?? this.repairOrderId),
      title: title ?? this.title,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      dueMileage: clearDueMileage ? null : (dueMileage ?? this.dueMileage),
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastNotifiedAt: clearLastNotifiedAt
          ? null
          : (lastNotifiedAt ?? this.lastNotifiedAt),
      lastNotificationKind: clearLastNotificationKind
          ? null
          : (lastNotificationKind ?? this.lastNotificationKind),
      intervalDays:
          clearIntervalDays ? null : (intervalDays ?? this.intervalDays),
      intervalMileage: clearIntervalMileage
          ? null
          : (intervalMileage ?? this.intervalMileage),
    );
  }
}
