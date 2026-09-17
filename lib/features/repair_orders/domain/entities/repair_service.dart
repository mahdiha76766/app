class RepairService {
  const RepairService({
    required this.id,
    required this.repairOrderId,
    required this.title,
    required this.amount,
    required this.createdAt,
  });

  final String id;
  final String repairOrderId;
  final String title;
  final int amount;
  final DateTime createdAt;

  RepairService copyWith({
    String? id,
    String? repairOrderId,
    String? title,
    int? amount,
    DateTime? createdAt,
  }) {
    return RepairService(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
