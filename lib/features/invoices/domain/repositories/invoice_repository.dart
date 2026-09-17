import '../entities/invoice_list_item.dart';
import '../entities/invoice_totals.dart';
import '../entities/payment_transaction.dart';
import '../../../../core/database/enums.dart';

abstract class InvoiceRepository {
  Future<InvoiceTotals> calculateTotals(String repairOrderId);

  Future<List<InvoiceListItem>> listInvoices({
    String query = '',
    PaymentStatus? paymentStatus,
    DateTime? from,
    DateTime? to,
  });

  Future<InvoiceListItem?> getInvoiceItem(String repairOrderId);

  Future<List<PaymentTransaction>> listPayments(String repairOrderId);

  Future<void> addPayment(PaymentTransaction payment);

  Future<void> deletePayment(String paymentId);

  /// همگام‌سازی paidAmount و paymentStatus از مجموع تراکنش‌ها.
  Future<void> syncPaymentState(String repairOrderId);
}
