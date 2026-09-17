import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/home_dashboard.dart';
import '../domain/repositories/home_repository.dart';
import 'repositories/home_repository_impl.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(appDatabaseProvider));
});

final homeDashboardProvider =
    FutureProvider.autoDispose<HomeDashboard>((ref) async {
  return ref.watch(homeRepositoryProvider).getDashboard();
});
