import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/mappers.dart';
import '../../../../core/formatters/text_normalizer.dart';
import '../../domain/entities/part.dart';
import '../../domain/repositories/part_repository.dart';

class PartRepositoryImpl implements PartRepository {
  PartRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Part?> getById(String id) async {
    final row = await (_db.select(_db.parts)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Part>> searchByTitle(String query, {int limit = 30}) async {
    final normalized = TextNormalizer.normalize(query);
    if (normalized.isEmpty) {
      return const [];
    }

    final rows = await (_db.select(_db.parts)
          ..where(
            (t) =>
                t.isActive.equals(true) &
                (t.normalizedTitle.like('%$normalized%') |
                    t.title.like('%$query%')),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.asc(t.title),
          ])
          ..limit(limit))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<Part>> getPopularByCategory(
    String categoryId, {
    int limit = 15,
  }) async {
    final rows = await (_db.select(_db.parts)
          ..where(
            (t) =>
                t.serviceCategoryId.equals(categoryId) &
                t.isActive.equals(true),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.asc(t.title),
          ])
          ..limit(limit))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<List<Part>> getPopularWorkshop({int limit = 15}) async {
    final rows = await (_db.select(_db.parts)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.asc(t.title),
          ])
          ..limit(limit))
        .get();
    return rows.map((row) => row.toDomain()).toList();
  }

  @override
  Future<int?> getLatestPrice({
    required String normalizedTitle,
    String? vehicleModel,
  }) async {
    final title = TextNormalizer.normalize(normalizedTitle);
    if (title.isEmpty) {
      return null;
    }

    if (vehicleModel != null && vehicleModel.trim().isNotEmpty) {
      final model = vehicleModel.trim();
      final withModel = await (_db.select(_db.partPriceHistory)
            ..where(
              (t) =>
                  t.partTitleNormalized.equals(title) &
                  t.vehicleModel.equals(model),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();
      if (withModel != null) {
        return withModel.amount;
      }
    }

    final anyModel = await (_db.select(_db.partPriceHistory)
          ..where((t) => t.partTitleNormalized.equals(title))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
    return anyModel?.amount;
  }

  @override
  Future<void> upsert(Part part) async {
    await _db.into(_db.parts).insertOnConflictUpdate(part.toCompanion());
  }

  @override
  Future<void> recordPrice({
    required String id,
    String? partId,
    required String partTitleNormalized,
    String? vehicleModel,
    required int amount,
    String? repairOrderId,
    required DateTime createdAt,
  }) async {
    await _db.into(_db.partPriceHistory).insert(
          PartPriceHistoryCompanion.insert(
            id: id,
            partId: Value(partId),
            partTitleNormalized: TextNormalizer.normalize(partTitleNormalized),
            vehicleModel: Value(vehicleModel),
            amount: amount,
            repairOrderId: Value(repairOrderId),
            createdAt: createdAt,
          ),
        );
  }
}
