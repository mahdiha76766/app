import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/database/enums.dart';
import '../../../../core/formatters/jalali_date_formatter.dart';
import '../../../../core/formatters/money_formatter.dart';
import '../../../../core/formatters/persian_digit_formatter.dart';
import '../../../repair_orders/domain/entities/repair_part.dart';
import '../../../settings/domain/entities/bank_account.dart';
import '../../../settings/domain/entities/workshop.dart';
import '../../../vehicles/domain/entities/customer.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/invoice_totals.dart';
import '../../domain/entities/payment_transaction.dart';

class InvoicePdfInput {
  const InvoicePdfInput({
    required this.invoiceNumber,
    required this.issuedAt,
    required this.workshop,
    required this.vehicle,
    this.customer,
    required this.parts,
    required this.totals,
    this.mileage,
    this.bankAccounts = const [],
    this.payments = const [],
    this.paymentStatus,
  });

  final String invoiceNumber;
  final DateTime issuedAt;
  final Workshop workshop;
  final Vehicle vehicle;
  final Customer? customer;
  final List<RepairPart> parts;
  final InvoiceTotals totals;
  final int? mileage;
  final List<BankAccount> bankAccounts;
  final List<PaymentTransaction> payments;
  final PaymentStatus? paymentStatus;
}

/// ساخت فاکتور PDF جدولی با فونت فارسی.
class InvoicePdfBuilder {
  Future<File> build(InvoicePdfInput input) async {
    final regularData =
        await rootBundle.load('assets/fonts/Vazirmatn-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Vazirmatn-Bold.ttf');
    final regular = pw.Font.ttf(regularData);
    final bold = pw.Font.ttf(boldData);

    final doc = pw.Document();
    final theme = pw.ThemeData.withFont(base: regular, bold: bold);

    final vehicleLabel = [
      if (input.vehicle.manufacturer?.isNotEmpty == true)
        input.vehicle.manufacturer!,
      if (input.vehicle.model?.isNotEmpty == true) input.vehicle.model!,
    ].join(' ');

    final customerName =
        input.customer?.fullName?.trim().isNotEmpty == true
            ? input.customer!.fullName!.trim()
            : '—';

    doc.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blueGrey800, width: 1.4),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(
                  input.workshop.name,
                  style: pw.TextStyle(font: bold, fontSize: 22),
                  textAlign: pw.TextAlign.center,
                ),
                if (input.workshop.phone?.isNotEmpty == true) ...[
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'تلفن: ${PersianDigitFormatter.toPersian(input.workshop.phone!)}',
                    style: pw.TextStyle(font: regular, fontSize: 11),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
                if (input.workshop.address?.isNotEmpty == true) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(
                    input.workshop.address!,
                    style: pw.TextStyle(font: regular, fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
                pw.SizedBox(height: 12),
                pw.Divider(color: PdfColors.blueGrey400),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'فاکتور شماره ${PersianDigitFormatter.toPersian(input.invoiceNumber)}',
                      style: pw.TextStyle(font: bold, fontSize: 13),
                    ),
                    pw.Text(
                      'تاریخ: ${JalaliDateFormatter.format(input.issuedAt)}',
                      style: pw.TextStyle(font: regular, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: pw.BoxDecoration(
              color: PdfColors.blueGrey50,
              borderRadius: pw.BorderRadius.circular(12),
              border: pw.Border.all(color: PdfColors.blueGrey200, width: 1),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                _infoBlock('مشتری', customerName, bold, regular),
                pw.SizedBox(height: 12),
                _infoBlock(
                  'خودرو',
                  vehicleLabel.isEmpty ? '—' : vehicleLabel,
                  bold,
                  regular,
                ),
                pw.SizedBox(height: 12),
                _infoBlock('پلاک', input.vehicle.plateDisplay, bold, regular),
                if (input.mileage != null) ...[
                  pw.SizedBox(height: 12),
                  _infoBlock(
                    'کارکرد',
                    '${PersianDigitFormatter.intToPersian(input.mileage!)} کیلومتر',
                    bold,
                    regular,
                  ),
                ],
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'اقلام فاکتور',
            style: pw.TextStyle(font: bold, fontSize: 13),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: const ['ردیف', 'شرح', 'تعداد', 'فی', 'مبلغ'],
            headerStyle: pw.TextStyle(font: bold, fontSize: 10),
            cellStyle: pw.TextStyle(font: regular, fontSize: 9),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.blueGrey100),
            cellAlignment: pw.Alignment.center,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
            },
            data: [
              for (var i = 0; i < input.parts.length; i++)
                [
                  PersianDigitFormatter.intToPersian(i + 1),
                  input.parts[i].partTitleSnapshot +
                      (input.parts[i].suppliedBy == PartSuppliedBy.customer
                          ? ' (آورده مشتری)'
                          : ''),
                  PersianDigitFormatter.intToPersian(input.parts[i].quantity),
                  input.parts[i].suppliedBy == PartSuppliedBy.customer
                      ? MoneyFormatter.format(0, withSuffix: false)
                      : MoneyFormatter.format(
                          input.parts[i].unitPrice,
                          withSuffix: false,
                        ),
                  input.parts[i].suppliedBy == PartSuppliedBy.customer
                      ? MoneyFormatter.format(0, withSuffix: false)
                      : MoneyFormatter.format(
                          input.parts[i].lineTotal,
                          withSuffix: false,
                        ),
                ],
              if (input.parts.isEmpty)
                [
                  PersianDigitFormatter.intToPersian(1),
                  'اجرت / خدمات',
                  PersianDigitFormatter.intToPersian(1),
                  MoneyFormatter.format(input.totals.laborAmount,
                      withSuffix: false),
                  MoneyFormatter.format(input.totals.laborAmount,
                      withSuffix: false),
                ],
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Container(
              width: 260,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blueGrey300),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                children: [
                  _totalRow(
                    'جمع قطعات',
                    MoneyFormatter.format(input.totals.partsTotal),
                    regular,
                    bold,
                  ),
                  pw.SizedBox(height: 6),
                  _totalRow(
                    'اجرت',
                    MoneyFormatter.format(input.totals.laborAmount),
                    regular,
                    bold,
                  ),
                  if (input.totals.discountAmount > 0) ...[
                    pw.SizedBox(height: 6),
                    _totalRow(
                      'تخفیف',
                      MoneyFormatter.format(input.totals.discountAmount),
                      regular,
                      bold,
                    ),
                  ],
                  pw.Divider(color: PdfColors.blueGrey300),
                  _totalRow(
                    'مبلغ نهایی',
                    MoneyFormatter.format(input.totals.grandTotal),
                    bold,
                    bold,
                    emphasize: true,
                  ),
                  pw.SizedBox(height: 6),
                  _totalRow(
                    'پرداخت‌شده',
                    MoneyFormatter.format(input.totals.paidAmount),
                    regular,
                    bold,
                  ),
                  pw.SizedBox(height: 6),
                  _totalRow(
                    'مانده بدهی',
                    MoneyFormatter.format(input.totals.remaining),
                    regular,
                    bold,
                  ),
                  if (input.paymentStatus != null) ...[
                    pw.SizedBox(height: 6),
                    _totalRow(
                      'وضعیت پرداخت',
                      input.paymentStatus!.labelFa,
                      regular,
                      bold,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (input.payments.isNotEmpty) ...[
            pw.SizedBox(height: 18),
            pw.Text(
              'تراکنش‌های پرداخت',
              style: pw.TextStyle(font: bold, fontSize: 13),
            ),
            pw.SizedBox(height: 8),
            for (final payment in input.payments) ...[
              pw.Container(
                width: double.infinity,
                margin: const pw.EdgeInsets.only(bottom: 6),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey200),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${MoneyFormatter.format(payment.amount)} — ${payment.method.labelFa}',
                      style: pw.TextStyle(font: bold, fontSize: 11),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      JalaliDateFormatter.formatWithTime(payment.paidAt),
                      style: pw.TextStyle(font: regular, fontSize: 10),
                    ),
                    if (payment.trackingCode?.trim().isNotEmpty == true)
                      pw.Text(
                        'پیگیری: ${payment.trackingCode}',
                        style: pw.TextStyle(font: regular, fontSize: 10),
                      ),
                    if (payment.note?.trim().isNotEmpty == true)
                      pw.Text(
                        payment.note!.trim(),
                        style: pw.TextStyle(font: regular, fontSize: 10),
                      ),
                  ],
                ),
              ),
            ],
          ],
          if (input.bankAccounts.isNotEmpty) ...[
            pw.SizedBox(height: 18),
            pw.Text(
              'اطلاعات واریز',
              style: pw.TextStyle(font: bold, fontSize: 13),
            ),
            pw.SizedBox(height: 8),
            for (final bank in input.bankAccounts) ...[
              pw.Container(
                width: double.infinity,
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.blueGrey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      bank.bankName,
                      style: pw.TextStyle(font: bold, fontSize: 12),
                    ),
                    if (bank.accountHolderName?.trim().isNotEmpty == true) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'به نام: ${bank.accountHolderName!.trim()}',
                        style: pw.TextStyle(font: regular, fontSize: 11),
                      ),
                    ],
                    if (bank.cardNumber?.trim().isNotEmpty == true) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'شماره کارت: ${PersianDigitFormatter.toPersian(bank.cardNumber!.trim())}',
                        style: pw.TextStyle(font: regular, fontSize: 11),
                      ),
                    ],
                    if (bank.accountNumber?.trim().isNotEmpty == true) ...[
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'شماره حساب: ${PersianDigitFormatter.toPersian(bank.accountNumber!.trim())}',
                        style: pw.TextStyle(font: regular, fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
          pw.SizedBox(height: 24),
          pw.Text(
            'با تشکر از اعتماد شما',
            style: pw.TextStyle(font: regular, fontSize: 11),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File(
      p.join(
        dir.path,
        'invoice_${input.invoiceNumber}_${input.issuedAt.millisecondsSinceEpoch}.pdf',
      ),
    );
    await file.writeAsBytes(await doc.save());
    return file;
  }

  pw.Widget _infoBlock(
    String label,
    String value,
    pw.Font bold,
    pw.Font regular,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: regular,
            fontSize: 11,
            color: PdfColors.blueGrey600,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(font: bold, fontSize: 16),
        ),
      ],
    );
  }

  pw.Widget _totalRow(
    String label,
    String value,
    pw.Font regular,
    pw.Font bold, {
    bool emphasize = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: emphasize ? bold : regular,
            fontSize: emphasize ? 12 : 10,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: bold,
            fontSize: emphasize ? 12 : 10,
          ),
        ),
      ],
    );
  }
}
