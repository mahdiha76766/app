import '../../../../core/database/enums.dart';

class PaymentTransaction {
  const PaymentTransaction({
    required this.id,
    required this.repairOrderId,
    required this.amount,
    required this.paidAt,
    required this.method,
    this.note,
    this.trackingCode,
    required this.createdAt,
  });

  final String id;
  final String repairOrderId;
  final int amount;
  final DateTime paidAt;
  final PaymentMethod method;
  final String? note;
  final String? trackingCode;
  final DateTime createdAt;
}
