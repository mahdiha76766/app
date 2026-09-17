import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/invoices/domain/entities/invoice_totals.dart';
import 'package:mechanic_assistant/features/invoices/domain/services/invoice_calculator.dart';
import 'package:mechanic_assistant/features/invoices/domain/services/invoice_number_formatter.dart';

void main() {
  group('InvoiceCalculator', () {
    test('بدون تخفیف', () {
      final totals = InvoiceCalculator.compute(
        laborAmount: 500000,
        partsTotal: 1500000,
        discountAmount: 0,
        paidAmount: 0,
      );
      expect(totals.subtotal, 2000000);
      expect(totals.grandTotal, 2000000);
      expect(totals.remaining, 2000000);
      expect(
        InvoiceCalculator.deriveStatus(
          paidAmount: totals.paidAmount,
          grandTotal: totals.grandTotal,
        ),
        PaymentStatus.unpaid,
      );
    });

    test('با تخفیف', () {
      final totals = InvoiceCalculator.compute(
        laborAmount: 500000,
        partsTotal: 1200000,
        discountAmount: 100000,
        paidAmount: 0,
      );
      expect(totals.grandTotal, 1600000);
      expect(totals.remaining, 1600000);
    });

    test('پرداخت جزئی', () {
      final totals = InvoiceCalculator.compute(
        laborAmount: 500000,
        partsTotal: 1500000,
        discountAmount: 0,
        paidAmount: 800000,
      );
      expect(totals.grandTotal, 2000000);
      expect(totals.remaining, 1200000);
      expect(
        InvoiceCalculator.deriveStatus(
          paidAmount: totals.paidAmount,
          grandTotal: totals.grandTotal,
        ),
        PaymentStatus.partial,
      );
    });

    test('چند پرداخت — مجموع پرداخت‌ها', () {
      const payments = [300000, 500000, 200000];
      final paid = payments.fold<int>(0, (a, b) => a + b);
      final totals = InvoiceCalculator.compute(
        laborAmount: 400000,
        partsTotal: 1600000,
        discountAmount: 0,
        paidAmount: paid,
      );
      expect(totals.paidAmount, 1000000);
      expect(totals.remaining, 1000000);
      expect(
        InvoiceCalculator.deriveStatus(
          paidAmount: paid,
          grandTotal: totals.grandTotal,
        ),
        PaymentStatus.partial,
      );
    });

    test('قطعه آورده مشتری در partsTotal نیست (ورودی از قبل فیلتر شده)', () {
      // partsTotal فقط workshop؛ customer در ورودی لحاظ نمی‌شود
      final totals = InvoiceCalculator.compute(
        laborAmount: 200000,
        partsTotal: 800000, // فقط قطعات تعمیرگاه
        discountAmount: 0,
        paidAmount: 0,
      );
      expect(totals.partsTotal, 800000);
      expect(totals.grandTotal, 1000000);
    });

    test('فاکتور کاملاً پرداخت‌شده', () {
      final totals = InvoiceCalculator.compute(
        laborAmount: 300000,
        partsTotal: 700000,
        discountAmount: 0,
        paidAmount: 1000000,
      );
      expect(totals.remaining, 0);
      expect(
        InvoiceCalculator.deriveStatus(
          paidAmount: totals.paidAmount,
          grandTotal: totals.grandTotal,
        ),
        PaymentStatus.paid,
      );
    });

    test('جلوگیری از پرداخت بیشتر از مانده', () {
      expect(
        () => InvoiceCalculator.ensureNotExceedingRemaining(500001, 500000),
        throwsA(isA<PaymentValidationException>()),
      );
      expect(
        () => InvoiceCalculator.ensureNotExceedingRemaining(500000, 500000),
        returnsNormally,
      );
    });

    test('جلوگیری از مبلغ منفی', () {
      expect(
        () => InvoiceCalculator.ensureNonNegative(-1),
        throwsA(isA<PaymentValidationException>()),
      );
      expect(
        () => InvoiceCalculator.compute(
          laborAmount: -1,
          partsTotal: 0,
          discountAmount: 0,
          paidAmount: 0,
        ),
        throwsA(isA<PaymentValidationException>()),
      );
    });

    test('grandTotal منفی نمی‌شود با تخفیف بیش از حد', () {
      final totals = InvoiceCalculator.compute(
        laborAmount: 100000,
        partsTotal: 100000,
        discountAmount: 500000,
        paidAmount: 0,
      );
      expect(totals.grandTotal, 0);
    });
  });

  group('InvoiceNumberFormatter', () {
    test('فرمت ترتیبی', () {
      expect(
        InvoiceNumberFormatter.format(jalaliYear: 1405, sequence: 124),
        '1405-000124',
      );
      expect(InvoiceNumberFormatter.isSequentialFormat('1405-000124'), isTrue);
      expect(InvoiceNumberFormatter.isSequentialFormat('58231'), isFalse);
      expect(InvoiceNumberFormatter.parseSequence('1405-000124'), 124);
    });
  });

  group('InvoiceTotals سازگاری', () {
    test('servicesTotal در grandTotal نیست', () {
      const totals = InvoiceTotals(
        laborAmount: 500000,
        servicesTotal: 200000,
        partsTotal: 1200000,
        discountAmount: 100000,
        paidAmount: 0,
      );
      expect(totals.subtotal, 1700000);
      expect(totals.grandTotal, 1600000);
    });
  });
}
