import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/enums.dart';
import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../data/providers.dart';
import '../domain/entities/invoice_list_item.dart';

class InvoicesPage extends ConsumerStatefulWidget {
  const InvoicesPage({super.key});

  @override
  ConsumerState<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends ConsumerState<InvoicesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = ref.watch(invoiceListQueryProvider);
    final listAsync = ref.watch(invoiceListProvider);

    return Scaffold(
      appBar: const AppPageAppBar(title: 'فاکتورها'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'جستجو: شماره فاکتور، پلاک، مشتری، موبایل',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: query.search.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          ref.read(invoiceListQueryProvider.notifier).state =
                              query.copyWith(search: '');
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (value) {
                ref.read(invoiceListQueryProvider.notifier).state =
                    query.copyWith(search: value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'همه',
                  selected: query.paymentStatus == null,
                  onTap: () {
                    ref.read(invoiceListQueryProvider.notifier).state =
                        query.copyWith(clearPaymentStatus: true);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'پرداخت کامل',
                  selected: query.paymentStatus == PaymentStatus.paid,
                  onTap: () {
                    ref.read(invoiceListQueryProvider.notifier).state =
                        query.copyWith(paymentStatus: PaymentStatus.paid);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'پرداخت جزئی',
                  selected: query.paymentStatus == PaymentStatus.partial,
                  onTap: () {
                    ref.read(invoiceListQueryProvider.notifier).state =
                        query.copyWith(paymentStatus: PaymentStatus.partial);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'بدهکار',
                  selected: query.paymentStatus == PaymentStatus.unpaid,
                  onTap: () {
                    ref.read(invoiceListQueryProvider.notifier).state =
                        query.copyWith(paymentStatus: PaymentStatus.unpaid);
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: query.from == null && query.to == null
                      ? 'بازه زمانی'
                      : 'بازه انتخاب‌شده',
                  selected: query.from != null || query.to != null,
                  onTap: () => _pickDateRange(query),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: listAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('خطا در بارگذاری')),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'فاکتوری پیدا نشد',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(invoiceListProvider);
                    await ref.read(invoiceListProvider.future);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _InvoiceCard(item: items[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange(InvoiceListQuery query) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: query.from != null && query.to != null
          ? DateTimeRange(start: query.from!, end: query.to!)
          : null,
      helpText: 'بازه زمانی فاکتورها',
      cancelText: 'انصراف',
      confirmText: 'تأیید',
    );
    if (!mounted) return;
    if (picked == null) {
      ref.read(invoiceListQueryProvider.notifier).state = query.copyWith(
        clearFrom: true,
        clearTo: true,
      );
      return;
    }
    ref.read(invoiceListQueryProvider.notifier).state = query.copyWith(
      from: picked.start,
      to: picked.end,
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primaryContainer,
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.item});

  final InvoiceListItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/invoices/${item.repairOrderId}'),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      PersianDigitFormatter.toPersian(item.invoiceNumber),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusBadge(status: item.paymentStatus),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                [
                  item.plateDisplay,
                  if (item.customerName?.isNotEmpty == true) item.customerName!,
                ].join(' · '),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                JalaliDateFormatter.format(item.completedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _AmountCol(
                      label: 'مبلغ کل',
                      value: item.totals.grandTotal,
                    ),
                  ),
                  Expanded(
                    child: _AmountCol(
                      label: 'پرداخت‌شده',
                      value: item.totals.paidAmount,
                    ),
                  ),
                  Expanded(
                    child: _AmountCol(
                      label: 'مانده',
                      value: item.totals.remaining,
                      emphasize: item.totals.remaining > 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountCol extends StatelessWidget {
  const _AmountCol({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final int value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          MoneyFormatter.format(value, withSuffix: false),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: emphasize ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (status) {
      PaymentStatus.paid => theme.colorScheme.primary,
      PaymentStatus.partial => theme.colorScheme.tertiary,
      PaymentStatus.unpaid => theme.colorScheme.error,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.labelFa,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
