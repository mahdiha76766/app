import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/vehicle_list_item.dart';
import '../domain/entities/vehicle_profile.dart';
import '../domain/repositories/customer_repository.dart';
import '../domain/repositories/vehicle_profile_repository.dart';
import '../domain/repositories/vehicle_repository.dart';
import 'repositories/customer_repository_impl.dart';
import 'repositories/vehicle_profile_repository_impl.dart';
import 'repositories/vehicle_repository_impl.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(ref.watch(appDatabaseProvider));
});

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(ref.watch(appDatabaseProvider));
});

final vehicleProfileRepositoryProvider =
    Provider<VehicleProfileRepository>((ref) {
  return VehicleProfileRepositoryImpl(ref.watch(appDatabaseProvider));
});

final vehicleProfileProvider =
    FutureProvider.autoDispose.family<VehicleProfile?, String>((ref, vehicleId) {
  return ref.watch(vehicleProfileRepositoryProvider).getByVehicleId(vehicleId);
});

final vehicleVisitFilterProvider =
    StateProvider<VehicleVisitFilter>((ref) => VehicleVisitFilter.all);

final vehiclesListProvider =
    FutureProvider.autoDispose<List<VehicleListItem>>((ref) async {
  final filter = ref.watch(vehicleVisitFilterProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime? from;
  DateTime? to;
  switch (filter) {
    case VehicleVisitFilter.all:
      break;
    case VehicleVisitFilter.today:
      from = today;
      to = today;
    case VehicleVisitFilter.week:
      from = today.subtract(const Duration(days: 6));
      to = today;
    case VehicleVisitFilter.month:
      from = DateTime(today.year, today.month, 1);
      to = today;
  }

  return ref.watch(vehicleRepositoryProvider).listWithVisitStats(
        visitsFrom: from,
        visitsTo: to,
      );
});
