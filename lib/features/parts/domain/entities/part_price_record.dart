class PartPriceRecord {
  const PartPriceRecord({
    required this.id,
    this.partId,
    required this.partTitleNormalized,
    this.vehicleModel,
    required this.amount,
    this.repairOrderId,
    required this.createdAt,
  });

  final String id;
  final String? partId;
  final String partTitleNormalized;
  final String? vehicleModel;
  final int amount;
  final String? repairOrderId;
  final DateTime createdAt;
}
