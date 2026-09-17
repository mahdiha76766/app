/// جمع فاکتور بر حسب تومان (integer).
class InvoiceTotals {
  const InvoiceTotals({
    required this.laborAmount,
    required this.servicesTotal,
    required this.partsTotal,
    required this.discountAmount,
    required this.paidAmount,
  });

  final int laborAmount;

  /// مجموع مبلغ خدمات جداگانه (در نسخه اول معمولاً ۰؛ اجرت در [laborAmount] است).
  final int servicesTotal;

  /// فقط قطعات تامین‌شده توسط کارگاه.
  final int partsTotal;
  final int discountAmount;
  final int paidAmount;

  /// `partsTotal + laborAmount` (اجرت کل؛ بدون خدمات جداگانه).
  int get subtotal => partsTotal + laborAmount;

  int get grandTotal {
    final total = subtotal - discountAmount;
    return total < 0 ? 0 : total;
  }

  int get remaining {
    final value = grandTotal - paidAmount;
    return value < 0 ? 0 : value;
  }
}
