import '../../../../core/database/enums.dart';

class ActiveRepair {
  const ActiveRepair({
    required this.repairOrderId,
    required this.vehicleId,
    required this.vehicleModel,
    required this.plateDisplay,
    required this.status,
    required this.statusLabel,
    required this.updatedAt,
    required this.isDraft,
  });

  final String repairOrderId;
  final String vehicleId;
  final String vehicleModel;
  final String plateDisplay;
  final RepairOrderStatus status;
  final String statusLabel;
  final DateTime updatedAt;
  final bool isDraft;

  bool get isHighlighted =>
      status == RepairOrderStatus.waitingForParts ||
      status == RepairOrderStatus.readyForDelivery;
}
