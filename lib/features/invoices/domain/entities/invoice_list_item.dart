import '../../../../core/database/enums.dart';
import 'invoice_totals.dart';

/// خلاصه یک فاکتور برای لیست.
class InvoiceListItem {
  const InvoiceListItem({
    required this.repairOrderId,
    required this.invoiceNumber,
    required this.completedAt,
    required this.vehicleId,
    required this.plateDisplay,
    required this.plateNormalized,
    this.vehicleModel,
    this.customerName,
    this.customerPhone,
    required this.paymentStatus,
    required this.totals,
  });

  final String repairOrderId;
  final String invoiceNumber;
  final DateTime completedAt;
  final String vehicleId;
  final String plateDisplay;
  final String plateNormalized;
  final String? vehicleModel;
  final String? customerName;
  final String? customerPhone;
  final PaymentStatus paymentStatus;
  final InvoiceTotals totals;
}
