import '../../../../core/database/enums.dart';

class RepairOrder {
  const RepairOrder({
    required this.id,
    required this.vehicleId,
    this.customerId,
    required this.status,
    this.complaintText,
    this.mileage,
    required this.laborAmount,
    required this.discountAmount,
    required this.paymentStatus,
    required this.paidAmount,
    this.invoiceNumber,
    this.cancelReason,
    required this.createdAt,
    this.completedAt,
    this.deliveredAt,
  });

  final String id;
  final String vehicleId;
  final String? customerId;
  final RepairOrderStatus status;
  final String? complaintText;
  final int? mileage;
  final int laborAmount;
  final int discountAmount;
  final PaymentStatus paymentStatus;
  final int paidAmount;
  final String? invoiceNumber;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? deliveredAt;

  RepairOrder copyWith({
    String? id,
    String? vehicleId,
    String? customerId,
    RepairOrderStatus? status,
    String? complaintText,
    int? mileage,
    int? laborAmount,
    int? discountAmount,
    PaymentStatus? paymentStatus,
    int? paidAmount,
    String? invoiceNumber,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? deliveredAt,
    bool clearComplaintText = false,
    bool clearMileage = false,
    bool clearCompletedAt = false,
    bool clearDeliveredAt = false,
    bool clearInvoiceNumber = false,
    bool clearCancelReason = false,
  }) {
    return RepairOrder(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      complaintText:
          clearComplaintText ? null : (complaintText ?? this.complaintText),
      mileage: clearMileage ? null : (mileage ?? this.mileage),
      laborAmount: laborAmount ?? this.laborAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidAmount: paidAmount ?? this.paidAmount,
      invoiceNumber: clearInvoiceNumber
          ? null
          : (invoiceNumber ?? this.invoiceNumber),
      cancelReason:
          clearCancelReason ? null : (cancelReason ?? this.cancelReason),
      createdAt: createdAt ?? this.createdAt,
      completedAt:
          clearCompletedAt ? null : (completedAt ?? this.completedAt),
      deliveredAt:
          clearDeliveredAt ? null : (deliveredAt ?? this.deliveredAt),
    );
  }
}
