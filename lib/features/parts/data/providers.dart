import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/repositories/part_repository.dart';
import '../domain/repositories/service_category_repository.dart';
import 'repositories/part_repository_impl.dart';
import 'repositories/service_category_repository_impl.dart';

final partRepositoryProvider = Provider<PartRepository>((ref) {
  return PartRepositoryImpl(ref.watch(appDatabaseProvider));
});

final serviceCategoryRepositoryProvider =
    Provider<ServiceCategoryRepository>((ref) {
  return ServiceCategoryRepositoryImpl(ref.watch(appDatabaseProvider));
});
