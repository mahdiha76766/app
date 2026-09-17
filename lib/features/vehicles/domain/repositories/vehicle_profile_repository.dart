import '../entities/vehicle_profile.dart';

abstract class VehicleProfileRepository {
  Future<VehicleProfile?> getByVehicleId(
    String vehicleId, {
    int recentLimit = 3,
  });
}
