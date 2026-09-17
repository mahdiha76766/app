import 'vehicle.dart';

/// خودرو با آمار مراجعه برای فهرست.
class VehicleListItem {
  const VehicleListItem({
    required this.vehicle,
    this.customerName,
    required this.visitCount,
    this.lastVisitAt,
  });

  final Vehicle vehicle;
  final String? customerName;
  final int visitCount;
  final DateTime? lastVisitAt;

  String get modelLabel {
    final parts = <String>[
      if (vehicle.manufacturer != null &&
          vehicle.manufacturer!.trim().isNotEmpty)
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

enum VehicleVisitFilter {
  all,
  today,
  week,
  month,
}
