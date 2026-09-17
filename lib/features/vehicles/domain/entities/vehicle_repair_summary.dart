class VehicleRepairSummary {
  const VehicleRepairSummary({
    required this.repairOrderId,
    required this.servicesTitle,
    required this.mainParts,
    required this.finalAmount,
    required this.visitDate,
    this.mileage,
  });

  final String repairOrderId;
  final String servicesTitle;
  final String mainParts;
  final int finalAmount;
  final DateTime visitDate;
  final int? mileage;
}
