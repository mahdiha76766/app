import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../../core/database/mappers.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/entities/reminder_card.dart';
import '../../domain/entities/reminder_dashboard.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/reminder_urgency_classifier.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> upsert(Reminder reminder) async {
    await _db
        .into(_db.reminders)
        .insertOnConflictUpdate(reminder.toCompanion());
  }

  @override
  Future<List<Reminder>> getPending() async {
    final rows = await (_db.select(_db.reminders)
          ..where((t) => t.status.equals(ReminderStatus.pending.value))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<Reminder>> getDueReminders({DateTime? now}) async {
    final dashboard = await getDashboard(now: now);
    return dashboard.due.map((item) => item.reminder).toList();
  }

  @override
  Future<List<Reminder>> getForVehicle(String vehicleId) async {
    final rows = await (_db.select(_db.reminders)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<ReminderDashboard> getDashboard({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final query = _db.select(_db.reminders).join([
      leftOuterJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.reminders.vehicleId),
      ),
      leftOuterJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.vehicles.customerId),
      ),
    ])
      ..where(_db.reminders.status.equals(ReminderStatus.pending.value));

    final rows = await query.get();
    final due = <ReminderCard>[];
    final near = <ReminderCard>[];
    final future = <ReminderCard>[];

    for (final row in rows) {
      final reminder = row.readTable(_db.reminders).toDomain();
      final vehicle = row.readTableOrNull(_db.vehicles);
      final customer = row.readTableOrNull(_db.customers);
      final card = _toCard(reminder, vehicle, customer);
      final urgency = ReminderUrgencyClassifier.classify(
        reminder,
        now: current,
        currentMileage: vehicle?.lastMileage,
      );
      switch (urgency) {
        case ReminderUrgency.due:
          due.add(card);
        case ReminderUrgency.near:
          near.add(card);
        case ReminderUrgency.future:
          future.add(card);
      }
    }

    int compareCards(ReminderCard a, ReminderCard b) {
      final aDate = a.reminder.dueDate;
      final bDate = b.reminder.dueDate;
      if (aDate != null && bDate != null) {
        return aDate.compareTo(bDate);
      }
      if (aDate != null) {
        return -1;
      }
      if (bDate != null) {
        return 1;
      }
      final aKm = a.reminder.dueMileage ?? 1 << 30;
      final bKm = b.reminder.dueMileage ?? 1 << 30;
      return aKm.compareTo(bKm);
    }

    due.sort(compareCards);
    near.sort(compareCards);
    future.sort(compareCards);

    return ReminderDashboard(due: due, near: near, future: future);
  }

  @override
  Future<void> markDone(String reminderId) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(reminderId)))
        .write(
      RemindersCompanion(status: Value(ReminderStatus.done.value)),
    );
  }

  @override
  Future<Reminder?> markDoneAndMaybeCreateNext(String reminderId) {
    return _db.transaction(() async {
      final row = await (_db.select(_db.reminders)
            ..where((t) => t.id.equals(reminderId)))
          .getSingleOrNull();
      if (row == null) return null;

      final reminder = row.toDomain();
      await (_db.update(_db.reminders)..where((t) => t.id.equals(reminderId)))
          .write(
        RemindersCompanion(status: Value(ReminderStatus.done.value)),
      );

      final intervalDays = reminder.intervalDays;
      final intervalMileage = reminder.intervalMileage;
      if (intervalDays == null && intervalMileage == null) return null;

      final next = Reminder(
        id: const Uuid().v4(),
        vehicleId: reminder.vehicleId,
        repairOrderId: reminder.repairOrderId,
        title: reminder.title,
        dueDate: reminder.dueDate?.add(Duration(days: intervalDays ?? 0)),
        dueMileage: reminder.dueMileage == null
            ? null
            : reminder.dueMileage! + (intervalMileage ?? 0),
        status: ReminderStatus.pending,
        createdAt: DateTime.now(),
        intervalDays: intervalDays,
        intervalMileage: intervalMileage,
      );
      await _db.into(_db.reminders).insert(next.toCompanion());
      return next;
    });
  }

  @override
  Future<void> cancel(String reminderId) async {
    await (_db.update(_db.reminders)..where((t) => t.id.equals(reminderId)))
        .write(
      RemindersCompanion(status: Value(ReminderStatus.cancelled.value)),
    );
  }

  ReminderCard _toCard(
    Reminder reminder,
    VehicleRow? vehicle,
    CustomerRow? customer,
  ) {
    final modelParts = <String>[
      if (vehicle?.manufacturer != null &&
          vehicle!.manufacturer!.trim().isNotEmpty)
        vehicle.manufacturer!.trim(),
      if (vehicle?.model != null && vehicle!.model!.trim().isNotEmpty)
        vehicle.model!.trim(),
    ];
    return ReminderCard(
      reminder: reminder,
      vehicleModel: modelParts.isEmpty ? 'خودرو' : modelParts.join(' '),
      plateDisplay: vehicle?.plateDisplay ?? '—',
      customerName: customer?.fullName,
      phone: customer?.phone,
      currentMileage: vehicle?.lastMileage,
    );
  }
}
