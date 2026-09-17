import 'customer.dart';
import 'vehicle.dart';
import 'vehicle_repair_summary.dart';

class VehicleProfile {
  const VehicleProfile({
    required this.vehicle,
    this.customer,
    this.lastVisitAt,
    required this.recentRepairs,
  });

  final Vehicle vehicle;
  final Customer? customer;
  final DateTime? lastVisitAt;
  final List<VehicleRepairSummary> recentRepairs;

  String get modelLabel {
    final parts = <String>[
      if (vehicle.manufacturer != null && vehicle.manufacturer!.trim().isNotEmpty)
        vehicle.manufacturer!.trim(),
      if (vehicle.model != null && vehicle.model!.trim().isNotEmpty)
        vehicle.model!.trim(),
    ];
    if (parts.isEmpty) {
      return 'مدل ثبت نشده';
    }
    return parts.join(' ');
  }
}
