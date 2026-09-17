import '../../../../core/database/app_database.dart';
import '../../../../core/database/mappers.dart';
import '../../domain/entities/workshop.dart';
import '../../domain/repositories/workshop_repository.dart';

class WorkshopRepositoryImpl implements WorkshopRepository {
  WorkshopRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Workshop?> getWorkshop() async {
    final row = await (_db.select(_db.workshops)..limit(1)).getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> saveWorkshop(Workshop workshop) async {
    await _db.into(_db.workshops).insertOnConflictUpdate(workshop.toCompanion());
  }
}
