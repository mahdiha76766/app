import '../entities/part.dart';

abstract class PartRepository {
  Future<Part?> getById(String id);

  Future<List<Part>> searchByTitle(String query, {int limit = 30});

  Future<List<Part>> getPopularByCategory(
    String categoryId, {
    int limit = 15,
  });

  /// قطعات پرتکرار کل تعمیرگاه (بر اساس usageCount).
  Future<List<Part>> getPopularWorkshop({int limit = 15});

  /// آخرین قیمت: اول با مدل خودرو + عنوان نرمال، در غیر این صورت فقط عنوان.
  Future<int?> getLatestPrice({
    required String normalizedTitle,
    String? vehicleModel,
  });

  Future<void> upsert(Part part);

  Future<void> recordPrice({
    required String id,
    String? partId,
    required String partTitleNormalized,
    String? vehicleModel,
    required int amount,
    String? repairOrderId,
    required DateTime createdAt,
  });
}
