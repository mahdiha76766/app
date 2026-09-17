import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/enums.dart';
import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../../../core/widgets/price_keypad_bottom_sheet.dart';
import '../../messaging/data/providers.dart';
import '../../messaging/domain/services/customer_message_sender.dart';
import '../../repair_orders/data/providers.dart';
import '../../settings/data/providers.dart';
import '../../settings/domain/entities/bank_account.dart';
import '../../vehicles/data/providers.dart';
import '../data/providers.dart';
import '../data/services/invoice_pdf_builder.dart';
import '../domain/entities/payment_transaction.dart';
import '../domain/services/invoice_calculator.dart';

class InvoiceDetailPage extends ConsumerStatefulWidget {
  const InvoiceDetailPage({super.key, required this.repairOrderId});

  final String repairOrderId;

  @override
  ConsumerState<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends ConsumerState<InvoiceDetailPage> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemAsync = ref.watch(invoiceDetailProvider(widget.repairOrderId));
    final paymentsAsync =
        ref.watch(invoicePaymentsProvider(widget.repairOrderId));

    return Scaffold(
      appBar: const AppPageAppBar(title: 'جزئیات فاکتور'),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('خطا در بارگذاری')),
        data: (item) {
          if (item == null) {
            return const Center(child: Text('فاکتور پیدا نشد'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              Text(
                PersianDigitFormatter.toPersian(item.invoiceNumber),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.plateDisplay} · ${JalaliDateFormatter.formatWithTime(item.completedAt)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (item.customerName?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  [
                    item.customerName!,
                    if (item.customerPhone?.isNotEmpty == true)
                      item.customerPhone!,
                  ].join(' · '),
                ),
              ],
              const SizedBox(height: 16),
              _TotalsBox(
                status: item.paymentStatus,
                grandTotal: item.totals.grandTotal,
                paidAmount: item.totals.paidAmount,
                remaining: item.totals.remaining,
                partsTotal: item.totals.partsTotal,
                laborAmount: item.totals.laborAmount,
                discountAmount: item.totals.discountAmount,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'تراکنش‌های پرداخت',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (item.totals.remaining > 0)
                    TextButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _addPayment(item.totals.remaining),
                      icon: const Icon(Icons.add),
                      label: const Text('پرداخت جدید'),
                    ),
                ],
              ),
              paymentsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const Text('خطا در بارگذاری پرداخت‌ها'),
                data: (payments) {
                  if (payments.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'هنوز پرداختی ثبت نشده',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final payment in payments)
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              '${MoneyFormatter.format(payment.amount)} · ${payment.method.labelFa}',
                            ),
                            subtitle: Text(
                              [
                                JalaliDateFormatter.formatWithTime(
                                  payment.paidAt,
                                ),
                                if (payment.trackingCode?.isNotEmpty == true)
                                  'پیگیری: ${payment.trackingCode}',
                                if (payment.note?.isNotEmpty == true)
                                  payment.note!,
                              ].join('\n'),
                            ),
                            isThreeLine:
                                payment.note?.isNotEmpty == true ||
                                    payment.trackingCode?.isNotEmpty == true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: _busy
                                  ? null
                                  : () => _deletePayment(payment.id),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: AppTapTargets.large,
                child: FilledButton.icon(
                  onPressed: _busy ? null : _sharePdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('ساخت و اشتراک PDF'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: AppTapTargets.large,
                child: OutlinedButton.icon(
                  onPressed: _busy
                      ? null
                      : () => context.push(
                            '/repair/${widget.repairOrderId}/message',
                          ),
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('ارسال مجدد پیام تحویل'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    context.push('/vehicle/${item.vehicleId}'),
                child: const Text('پرونده خودرو'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addPayment(int remaining) async {
    final method = await showModalBottomSheet<PaymentMethod>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(title: Text('روش پرداخت')),
              for (final method in PaymentMethod.values)
                ListTile(
                  title: Text(method.labelFa),
                  onTap: () => Navigator.pop(context, method),
                ),
            ],
          ),
        );
      },
    );
    if (method == null || !mounted) return;

    final amount = await showPriceKeypadBottomSheet(
      context: context,
      partTitle: 'مبلغ پرداخت',
      initialAmount: remaining,
    );
    if (amount == null || !mounted) return;

    final noteController = TextEditingController();
    final trackingController = TextEditingController();
    final extras = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            20 + MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: trackingController,
                decoration: const InputDecoration(
                  labelText: 'شماره پیگیری (اختیاری)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'توضیح (اختیاری)',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('ثبت پرداخت'),
              ),
            ],
          ),
        );
      },
    );
    final note = noteController.text.trim();
    final tracking = trackingController.text.trim();
    noteController.dispose();
    trackingController.dispose();
    if (extras != true || !mounted) return;

    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      await ref.read(invoiceRepositoryProvider).addPayment(
            PaymentTransaction(
              id: const Uuid().v4(),
              repairOrderId: widget.repairOrderId,
              amount: amount,
              paidAt: now,
              method: method,
              note: note.isEmpty ? null : note,
              trackingCode: tracking.isEmpty ? null : tracking,
              createdAt: now,
            ),
          );
      ref.invalidate(invoiceDetailProvider(widget.repairOrderId));
      ref.invalidate(invoicePaymentsProvider(widget.repairOrderId));
      ref.invalidate(invoiceListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('پرداخت ثبت شد')),
      );
    } on PaymentValidationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deletePayment(String paymentId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف پرداخت'),
        content: const Text('این تراکنش حذف شود؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(invoiceRepositoryProvider).deletePayment(paymentId);
      ref.invalidate(invoiceDetailProvider(widget.repairOrderId));
      ref.invalidate(invoicePaymentsProvider(widget.repairOrderId));
      ref.invalidate(invoiceListProvider);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sharePdf() async {
    setState(() => _busy = true);
    try {
      final order = await ref
          .read(repairOrderRepositoryProvider)
          .getById(widget.repairOrderId);
      if (order == null) return;
      final vehicle =
          await ref.read(vehicleRepositoryProvider).getById(order.vehicleId);
      if (vehicle == null) return;
      final customerId = order.customerId ?? vehicle.customerId;
      final customer = customerId == null
          ? null
          : await ref.read(customerRepositoryProvider).getById(customerId);
      final workshop = await ref.read(workshopRepositoryProvider).getWorkshop();
      final banks = workshop == null
          ? <BankAccount>[]
          : await ref
              .read(bankAccountRepositoryProvider)
              .listForWorkshop(workshop.id);
      if (workshop == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('اطلاعات تعمیرگاه ثبت نشده است')),
        );
        return;
      }
      final parts = await ref
          .read(repairOrderRepositoryProvider)
          .getParts(widget.repairOrderId);
      final totals = await ref
          .read(invoiceRepositoryProvider)
          .calculateTotals(widget.repairOrderId);
      final payments = await ref
          .read(invoiceRepositoryProvider)
          .listPayments(widget.repairOrderId);

      final file = await InvoicePdfBuilder().build(
        InvoicePdfInput(
          invoiceNumber: order.invoiceNumber ?? '—',
          issuedAt: order.completedAt ?? order.createdAt,
          workshop: workshop,
          vehicle: vehicle,
          customer: customer,
          parts: parts,
          totals: totals,
          mileage: order.mileage ?? vehicle.lastMileage,
          bankAccounts: banks,
          payments: payments,
          paymentStatus: order.paymentStatus,
        ),
      );
      await ref.read(customerMessageSenderProvider).shareFile(
            filePath: file.path,
            preferred: CustomerMessageSendChannel.systemShare,
          );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _TotalsBox extends StatelessWidget {
  const _TotalsBox({
    required this.status,
    required this.grandTotal,
    required this.paidAmount,
    required this.remaining,
    required this.partsTotal,
    required this.laborAmount,
    required this.discountAmount,
  });

  final PaymentStatus status;
  final int grandTotal;
  final int paidAmount;
  final int remaining;
  final int partsTotal;
  final int laborAmount;
  final int discountAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('وضعیت', style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(
                status.labelFa,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _row(theme, 'قطعات تعمیرگاه', partsTotal),
          _row(theme, 'اجرت', laborAmount),
          if (discountAmount > 0) _row(theme, 'تخفیف', discountAmount),
          const Divider(height: 20),
          _row(theme, 'مبلغ نهایی', grandTotal, bold: true),
          _row(theme, 'پرداخت‌شده', paidAmount),
          _row(theme, 'مانده بدهی', remaining, error: remaining > 0),
        ],
      ),
    );
  }

  Widget _row(
    ThemeData theme,
    String label,
    int amount, {
    bool bold = false,
    bool error = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            MoneyFormatter.format(amount),
            style: (bold ? theme.textTheme.titleSmall : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: error ? theme.colorScheme.error : null,
            ),
          ),
        ],
      ),
    );
  }
}
