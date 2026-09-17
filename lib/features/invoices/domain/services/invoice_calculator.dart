import '../../../../core/database/enums.dart';
import '../entities/invoice_totals.dart';

/// خطای اعتبارسنجی مبلغ/پرداخت.
class PaymentValidationException implements Exception {
  PaymentValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// محاسبات مالی فاکتور و قوانین پرداخت.
abstract final class InvoiceCalculator {
  static InvoiceTotals compute({
    required int laborAmount,
    required int partsTotal,
    required int discountAmount,
    required int paidAmount,
    int servicesTotal = 0,
  }) {
    ensureNonNegative(laborAmount, field: 'اجرت');
    ensureNonNegative(partsTotal, field: 'قطعات');
    ensureNonNegative(discountAmount, field: 'تخفیف');
    ensureNonNegative(paidAmount, field: 'پرداخت');
    ensureNonNegative(servicesTotal, field: 'خدمات');

    return InvoiceTotals(
      laborAmount: laborAmount,
      servicesTotal: servicesTotal,
      partsTotal: partsTotal,
      discountAmount: discountAmount,
      paidAmount: paidAmount,
    );
  }

  static PaymentStatus deriveStatus({
    required int paidAmount,
    required int grandTotal,
  }) {
    if (paidAmount <= 0) {
      return PaymentStatus.unpaid;
    }
    if (grandTotal <= 0 || paidAmount >= grandTotal) {
      return PaymentStatus.paid;
    }
    return PaymentStatus.partial;
  }

  static void ensureNonNegative(int amount, {String field = 'مبلغ'}) {
    if (amount < 0) {
      throw PaymentValidationException('$field نمی‌تواند منفی باشد.');
    }
  }

  /// جلوگیری از پرداخت بیشتر از مانده.
  static void ensureNotExceedingRemaining(int amount, int remaining) {
    ensureNonNegative(amount);
    if (amount > remaining) {
      throw PaymentValidationException(
        'مبلغ پرداختی بیشتر از مانده بدهی است.',
      );
    }
  }

  static int clampPaidToGrandTotal(int paidAmount, int grandTotal) {
    if (paidAmount < 0) {
      return 0;
    }
    if (paidAmount > grandTotal) {
      return grandTotal;
    }
    return paidAmount;
  }
}
