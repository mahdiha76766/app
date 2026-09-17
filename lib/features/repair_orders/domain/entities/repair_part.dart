import '../../../../core/database/enums.dart';

class RepairPart {
  const RepairPart({
    required this.id,
    required this.repairOrderId,
    this.partId,
    required this.partTitleSnapshot,
    this.brandSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.suppliedBy,
    required this.createdAt,
  });

  final String id;
  final String repairOrderId;
  final String? partId;
  final String partTitleSnapshot;
  final String? brandSnapshot;
  final int quantity;
  final int unitPrice;
  final PartSuppliedBy suppliedBy;
  final DateTime createdAt;

  int get lineTotal => quantity * unitPrice;

  RepairPart copyWith({
    String? id,
    String? repairOrderId,
    String? partId,
    String? partTitleSnapshot,
    String? brandSnapshot,
    int? quantity,
    int? unitPrice,
    PartSuppliedBy? suppliedBy,
    DateTime? createdAt,
    bool clearPartId = false,
    bool clearBrandSnapshot = false,
  }) {
    return RepairPart(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      partId: clearPartId ? null : (partId ?? this.partId),
      partTitleSnapshot: partTitleSnapshot ?? this.partTitleSnapshot,
      brandSnapshot:
          clearBrandSnapshot ? null : (brandSnapshot ?? this.brandSnapshot),
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      suppliedBy: suppliedBy ?? this.suppliedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
