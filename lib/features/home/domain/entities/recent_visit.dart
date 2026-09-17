class RecentVisit {
  const RecentVisit({
    required this.repairOrderId,
    required this.vehicleId,
    required this.vehicleModel,
    required this.serviceType,
    required this.invoiceTotal,
    required this.visitDate,
  });

  final String repairOrderId;
  final String vehicleId;
  final String vehicleModel;
  final String serviceType;
  final int invoiceTotal;
  final DateTime visitDate;
}
