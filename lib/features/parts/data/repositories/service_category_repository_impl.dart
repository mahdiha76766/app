import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/mappers.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/repositories/service_category_repository.dart';

class ServiceCategoryRepositoryImpl implements ServiceCategoryRepository {
  ServiceCategoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<ServiceCategory>> getActiveCategories() async {
    final rows = await (_db.select(_db.serviceCategories)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }
}
