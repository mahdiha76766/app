import '../entities/vehicle.dart';
import '../entities/vehicle_list_item.dart';

abstract class VehicleRepository {
  Future<Vehicle?> findByPlateNormalized(String plateNormalized);

  Future<Vehicle?> getById(String id);

  Future<List<Vehicle>> getAll();

  Future<List<VehicleListItem>> listWithVisitStats({
    DateTime? visitsFrom,
    DateTime? visitsTo,
  });

  Future<List<Vehicle>> getVisitedToday({DateTime? now});

  Future<void> upsert(Vehicle vehicle);
}
