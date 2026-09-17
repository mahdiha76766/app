import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';

void main() {
  group('InvoiceTotals formula', () {
    test('partsTotal فقط workshop و grandTotal با تخفیف', () {
      const totals = InvoiceTotals(
        laborAmount: 500000,
        servicesTotal: 200000,
        partsTotal: 1200000,
        discountAmount: 100000,
        paidAmount: 0,
      );

      expect(totals.subtotal, 1700000);
      expect(totals.grandTotal, 1600000);
      expect(totals.remaining, 1600000);
    });

    test('grandTotal منفی نمی‌شود', () {
      const totals = InvoiceTotals(
        laborAmount: 100000,
        servicesTotal: 0,
        partsTotal: 100000,
        discountAmount: 500000,
        paidAmount: 0,
      );
      expect(totals.grandTotal, 0);
    });

    test('remaining پس از پرداخت جزئی', () {
      const totals = InvoiceTotals(
        laborAmount: 500000,
        servicesTotal: 0,
        partsTotal: 1500000,
        discountAmount: 0,
        paidAmount: 800000,
      );
      expect(totals.grandTotal, 2000000);
      expect(totals.remaining, 1200000);
    });
  });
}
