class FinanceDayPoint {
  const FinanceDayPoint({
    required this.day,
    required this.invoicedTotal,
    required this.receivedTotal,
    required this.repairCount,
  });

  final DateTime day;

  /// جمع مبلغ نهایی فاکتورها در آن روز.
  final int invoicedTotal;

  /// جمع مبلغ واقعاً دریافت‌شده در آن روز.
  final int receivedTotal;
  final int repairCount;

  @Deprecated('Use receivedTotal')
  int get income => receivedTotal;
}

class FinanceSnapshot {
  const FinanceSnapshot({
    required this.invoicedTotal,
    required this.receivedTotal,
    required this.outstandingTotal,
    required this.laborTotal,
    required this.partsTotal,
    required this.discountTotal,
    required this.repairCount,
    required this.daily,
  });

  /// مبلغ کل فاکتورهای تکمیل‌شده (grandTotal).
  final int invoicedTotal;

  /// مبلغ واقعاً دریافت‌شده (مجموع تراکنش‌ها / paidAmount).
  final int receivedTotal;

  /// مطالبات باقی‌مانده.
  final int outstandingTotal;

  final int laborTotal;
  final int partsTotal;
  final int discountTotal;
  final int repairCount;
  final List<FinanceDayPoint> daily;

  int get averagePerInvoice =>
      repairCount == 0 ? 0 : (invoicedTotal / repairCount).round();

  @Deprecated('Use invoicedTotal')
  int get totalIncome => invoicedTotal;

  @Deprecated('Use averagePerInvoice')
  int get averagePerRepair => averagePerInvoice;
}

enum FinancePeriod {
  today,
  week,
  month,
  threeMonths,
}
