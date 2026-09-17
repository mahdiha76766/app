import '../entities/service_category.dart';

abstract class ServiceCategoryRepository {
  Future<List<ServiceCategory>> getActiveCategories();
}
