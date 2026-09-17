import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/enums.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/price_keypad_bottom_sheet.dart';
import '../../invoices/domain/entities/invoice_totals.dart';
import '../../parts/data/providers.dart';
import '../../vehicles/data/providers.dart';
import '../../vehicles/domain/entities/vehicle.dart';
import '../data/providers.dart';
import '../domain/entities/repair_order.dart';
import '../domain/entities/repair_part.dart';
import '../domain/entities/repair_service.dart';
import '../domain/services/repair_workflow.dart';
import 'widgets/browse_services_sheet.dart';
import 'widgets/part_price_bottom_sheet.dart';

/// صفحه خلاصه تعمیر: ویرایش قطعات/مبالغ و پایان کار.
class RepairSummaryPage extends ConsumerStatefulWidget {
  const RepairSummaryPage({
    super.key,
    required this.repairId,
  });

  final String repairId;

  @override
  ConsumerState<RepairSummaryPage> createState() => _RepairSummaryPageState();
}

class _RepairSummaryPageState extends ConsumerState<RepairSummaryPage> {
  RepairOrder? _order;
  Vehicle? _vehicle;
  List<RepairPart> _parts = const [];
  List<RepairService> _services = const [];
  bool _loading = true;
  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _load();
  }

  InvoiceTotals get _totals {
    final order = _order;
    if (order == null) {
      return const InvoiceTotals(
        laborAmount: 0,
        servicesTotal: 0,
        partsTotal: 0,
        discountAmount: 0,
        paidAmount: 0,
      );
    }
    final partsTotal = _parts
        .where((item) => item.suppliedBy == PartSuppliedBy.workshop)
        .fold<int>(0, (sum, item) => sum + item.lineTotal);
    return InvoiceTotals(
      laborAmount: order.laborAmount,
      servicesTotal: 0,
      partsTotal: partsTotal,
      discountAmount: order.discountAmount,
      paidAmount: order.paidAmount,
    );
  }

  String get _categoryLabel {
    if (_services.isEmpty) {
      return 'بدون دسته';
    }
    return _services.first.title;
  }

  String get _vehicleTitle {
    final vehicle = _vehicle;
    if (vehicle == null) {
      return '—';
    }
    final parts = [
      if (vehicle.manufacturer != null && vehicle.manufacturer!.isNotEmpty)
        vehicle.manufacturer!,
      if (vehicle.model != null && vehicle.model!.isNotEmpty) vehicle.model!,
    ];
    return parts.isEmpty ? 'خودرو' : parts.join(' ');
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(repairOrderRepositoryProvider);
      final order = await repo.getById(widget.repairId);
      if (order == null) {
        if (!mounted) {
          return;
        }
        setState(() {
          _loading = false;
          _errorText = 'پذیرش پیدا نشد.';
        });
        return;
      }
      final vehicle =
          await ref.read(vehicleRepositoryProvider).getById(order.vehicleId);
      final parts = await repo.getParts(order.id);
      final services = await repo.getServices(order.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _order = order;
        _vehicle = vehicle;
        _parts = parts;
        _services = services;
        _loading = false;
        _errorText = null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorText = 'خطا در بارگذاری خلاصه تعمیر.';
      });
    }
  }

  Future<void> _persistOrder(RepairOrder order) async {
    await ref.read(repairOrderRepositoryProvider).update(order);
    if (!mounted) {
      return;
    }
    setState(() => _order = order);
  }

  Future<void> _removePart(String id) async {
    await ref.read(repairOrderRepositoryProvider).removePart(id);
    if (!mounted) {
      return;
    }
    setState(() => _parts = _parts.where((item) => item.id != id).toList());
  }

  Future<void> _editPartPrice(RepairPart part) async {
    final result = await showPartPriceSheet(
      context: context,
      partTitle: part.partTitleSnapshot,
      vehicleModel: _vehicleTitle,
      initialUnitPrice: part.unitPrice,
    );
    if (result == null || !mounted) {
      return;
    }
    final updated = part.copyWith(unitPrice: result.unitPrice);
    await ref.read(repairOrderRepositoryProvider).updatePart(updated);
    if (!mounted) {
      return;
    }
    setState(() {
      _parts = [
        for (final item in _parts)
          if (item.id == part.id) updated else item,
      ];
    });
  }

  /// مثل پذیرش: انتخاب دسته → رفتن به قطعات همان دسته.
  Future<void> _addMoreParts() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final categories = await ref
        .read(serviceCategoryRepositoryProvider)
        .getActiveCategories();
    if (!mounted) {
      return;
    }
    final title = await showBrowseServicesSheet(
      context: context,
      categories: categories,
    );
    if (title == null || title.trim().isEmpty || !mounted) {
      return;
    }

    final repo = ref.read(repairOrderRepositoryProvider);
    final trimmed = title.trim();
    final existing = await repo.getServices(order.id);
    for (final item in existing) {
      await repo.removeService(item.id);
    }
    await repo.addService(
      RepairService(
        id: const Uuid().v4(),
        repairOrderId: order.id,
        title: trimmed,
        amount: 0,
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) {
      return;
    }
    await context.push('/repair/${order.id}/parts');
    if (mounted) {
      await _load();
    }
  }

  Future<void> _editLabor() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final amount = await showPriceKeypadBottomSheet(
      context: context,
      partTitle: 'اجرت',
      vehicleModel: _vehicleTitle,
      initialAmount: order.laborAmount > 0 ? order.laborAmount : null,
    );
    if (amount == null || !mounted) {
      return;
    }
    var next = order.copyWith(laborAmount: amount);
    next = _syncPaidWithStatus(next);
    await _persistOrder(next);
  }

  Future<void> _editDiscount() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final amount = await showPriceKeypadBottomSheet(
      context: context,
      partTitle: 'تخفیف',
      vehicleModel: _vehicleTitle,
      initialAmount: order.discountAmount > 0 ? order.discountAmount : null,
    );
    if (amount == null || !mounted) {
      return;
    }
    var next = order.copyWith(discountAmount: amount);
    next = _syncPaidWithStatus(next);
    await _persistOrder(next);
  }

  RepairOrder _syncPaidWithStatus(RepairOrder order) {
    final totals = InvoiceTotals(
      laborAmount: order.laborAmount,
      servicesTotal: 0,
      partsTotal: _parts
          .where((item) => item.suppliedBy == PartSuppliedBy.workshop)
          .fold<int>(0, (sum, item) => sum + item.lineTotal),
      discountAmount: order.discountAmount,
      paidAmount: order.paidAmount,
    );
    switch (order.paymentStatus) {
      case PaymentStatus.paid:
        return order.copyWith(paidAmount: totals.grandTotal);
      case PaymentStatus.unpaid:
        return order.copyWith(paidAmount: 0);
      case PaymentStatus.partial:
        final paid = order.paidAmount.clamp(0, totals.grandTotal).toInt();
        return order.copyWith(paidAmount: paid);
    }
  }

  Future<void> _setPaymentStatus(PaymentStatus status) async {
    final order = _order;
    if (order == null) {
      return;
    }
    var next = order.copyWith(paymentStatus: status);
    next = _syncPaidWithStatus(next);
    await _persistOrder(next);
  }

  Future<void> _editPaidAmount() async {
    final order = _order;
    if (order == null) {
      return;
    }
    final totals = _totals;
    final amount = await showPriceKeypadBottomSheet(
      context: context,
      partTitle: 'مبلغ پرداختی',
      vehicleModel: _vehicleTitle,
      initialAmount: order.paidAmount > 0 ? order.paidAmount : null,
    );
    if (amount == null || !mounted) {
      return;
    }
    final paid = amount.clamp(0, totals.grandTotal).toInt();
    PaymentStatus status;
    if (paid <= 0) {
      status = PaymentStatus.unpaid;
    } else if (paid >= totals.grandTotal) {
      status = PaymentStatus.paid;
    } else {
      status = PaymentStatus.partial;
    }
    await _persistOrder(
      order.copyWith(paymentStatus: status, paidAmount: paid),
    );
  }

  Future<void> _finishRepair() async {
    final order = _order;
    if (order == null || _saving) {
      return;
    }
    final totals = _totals;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('پایان تعمیر'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('آیا مطمئن هستید خودرو آماده تحویل می‌شود؟'),
              const SizedBox(height: 12),
              _DialogRow(
                label: 'قطعات',
                value: MoneyFormatter.format(totals.partsTotal),
              ),
              _DialogRow(
                label: 'اجرت',
                value: MoneyFormatter.format(totals.laborAmount),
              ),
              _DialogRow(
                label: 'تخفیف',
                value: MoneyFormatter.format(totals.discountAmount),
              ),
              const Divider(),
              _DialogRow(
                label: 'جمع کل',
                value: MoneyFormatter.format(totals.grandTotal),
                emphasized: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('تأیید و پایان'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });
    try {
      final repo = ref.read(repairOrderRepositoryProvider);
      final synced = _syncPaidWithStatus(order);
      await repo.update(synced);
      await repo.completeRepair(synced.id);
      if (!mounted) {
        return;
      }
      context.pushReplacement('/repair/${synced.id}/message');
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _errorText = 'پایان تعمیر با خطا مواجه شد.';
      });
    }
  }

  Future<void> _changeStatus(RepairOrderStatus status) async {
    final order = _order;
    if (order == null || _saving) return;
    setState(() {
      _saving = true;
      _errorText = null;
    });
    try {
      await ref.read(repairOrderRepositoryProvider).changeStatus(
            repairOrderId: order.id,
            to: status,
          );
      await _load();
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorText = 'تغییر وضعیت با خطا مواجه شد.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deliverRepair() async {
    final order = _order;
    if (order == null || _saving) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحویل خودرو'),
        content: const Text('آیا خودرو به مشتری تحویل داده شد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تأیید تحویل'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(repairOrderRepositoryProvider).deliverRepair(order.id);
      if (mounted) context.go('/repair/${order.id}/message');
    } catch (_) {
      if (mounted) setState(() => _errorText = 'تحویل خودرو با خطا مواجه شد.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _cancelRepair() async {
    final order = _order;
    if (order == null || _saving) return;
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('لغو تعمیر'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'دلیل لغو (اختیاری)',
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تأیید لغو'),
          ),
        ],
      ),
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(repairOrderRepositoryProvider).cancelRepair(
            order.id,
            reason: reason.isEmpty ? null : reason,
          );
      if (mounted) context.go('/');
    } catch (_) {
      if (mounted) setState(() => _errorText = 'لغو تعمیر با خطا مواجه شد.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final order = _order;
    final totals = _totals;

    return PopScope(
      canPop: !_saving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _saving) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('در حال ذخیره تعمیر… لطفاً صبر کنید.')),
          );
        }
      },
      child: Scaffold(
        appBar: AppPageAppBar(
          title: 'خلاصه تعمیر',
          actions: [
            IconButton(
              tooltip: 'دستیار هوشمند',
              icon: const Icon(Icons.smart_toy_outlined),
              onPressed: () =>
                  context.push('/repair/${widget.repairId}/assistant'),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _errorText != null && order == null
                ? Center(child: Text(_errorText!))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _HeaderCard(
                                model: _vehicleTitle,
                                plateDisplay: _vehicle?.plateDisplay ?? '—',
                                plateNormalized: _vehicle?.plateNormalized,
                                category: _categoryLabel,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Chip(
                                  avatar: const Icon(Icons.build_circle_outlined),
                                  label: Text(order!.status.labelFa),
                                ),
                              ),
                              if (order.status.isOpen &&
                                  order.status !=
                                      RepairOrderStatus.readyForDelivery) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'تغییر وضعیت',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final status
                                        in RepairWorkflow.nextStatuses(
                                          order.status,
                                        ).where(
                                          (status) =>
                                              status !=
                                                  RepairOrderStatus
                                                      .readyForDelivery &&
                                              status !=
                                                  RepairOrderStatus.delivered &&
                                              status !=
                                                  RepairOrderStatus.cancelled,
                                        ))
                                      OutlinedButton(
                                        onPressed: _saving
                                            ? null
                                            : () => _changeStatus(status),
                                        child: Text(status.labelFa),
                                      ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 20),
                              Text(
                                'قطعات ثبت‌شده',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (_parts.isEmpty)
                                Text(
                                  'هنوز قطعه‌ای ثبت نشده.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                )
                              else
                                for (final part in _parts) ...[
                                  _EditablePartTile(
                                    part: part,
                                    onEditPrice: () => _editPartPrice(part),
                                    onRemove: () => _removePart(part.id),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              FilledButton.icon(
                                onPressed: _addMoreParts,
                                icon: const Icon(Icons.add),
                                label: const Text('افزودن قطعه'),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'اجرت',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: AppTapTargets.priceKeypad,
                                child: OutlinedButton(
                                  onPressed: _editLabor,
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      order.laborAmount <= 0
                                          ? 'ورود اجرت کل'
                                          : MoneyFormatter.format(
                                              order.laborAmount,
                                            ),
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'خلاصه فاکتور',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _TotalsCard(
                                partsTotal: totals.partsTotal,
                                laborAmount: totals.laborAmount,
                                discountAmount: totals.discountAmount,
                                grandTotal: totals.grandTotal,
                                onEditDiscount: _editDiscount,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'وضعیت پرداخت',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SegmentedButton<PaymentStatus>(
                                segments: const [
                                  ButtonSegment(
                                    value: PaymentStatus.paid,
                                    label: Text('پرداخت کامل'),
                                  ),
                                  ButtonSegment(
                                    value: PaymentStatus.partial,
                                    label: Text('پرداخت جزئی'),
                                  ),
                                  ButtonSegment(
                                    value: PaymentStatus.unpaid,
                                    label: Text('پرداخت‌نشده'),
                                  ),
                                ],
                                selected: {order.paymentStatus},
                                onSelectionChanged: (values) {
                                  if (values.isEmpty) {
                                    return;
                                  }
                                  _setPaymentStatus(values.first);
                                },
                              ),                              if (order.paymentStatus ==
                                  PaymentStatus.partial) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: AppTapTargets.priceKeypad,
                                  child: OutlinedButton(
                                    onPressed: _editPaidAmount,
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        order.paidAmount <= 0
                                            ? 'ورود مبلغ پرداختی'
                                            : 'پرداختی: ${MoneyFormatter.format(order.paidAmount)}',
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'باقی‌مانده: ${MoneyFormatter.format(totals.remaining)}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                              if (_errorText != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _errorText!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Column(
                            children: [
                              if (RepairWorkflow.canTransition(
                                    order.status,
                                    RepairOrderStatus.readyForDelivery,
                                  ) &&
                                  order.status !=
                                      RepairOrderStatus.readyForDelivery &&
                                  order.status != RepairOrderStatus.delivered &&
                                  order.status != RepairOrderStatus.cancelled)
                                SizedBox(
                                  height: AppTapTargets.priceKeypad,
                                  width: double.infinity,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.secondary,
                                      foregroundColor:
                                          theme.colorScheme.onSecondary,
                                    ),
                                    onPressed: _saving ? null : _finishRepair,
                                    child: _saving
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('پایان تعمیر'),
                                  ),
                                ),
                              if (order.status ==
                                  RepairOrderStatus.readyForDelivery)
                                SizedBox(
                                  height: AppTapTargets.priceKeypad,
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: _saving ? null : _deliverRepair,
                                    child: const Text('تحویل خودرو به مشتری'),
                                  ),
                                ),
                              if (order.status == RepairOrderStatus.delivered ||
                                  order.status == RepairOrderStatus.cancelled)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    order.status == RepairOrderStatus.delivered
                                        ? 'خودرو به مشتری تحویل شده است.'
                                        : 'این تعمیر لغو شده است.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              if (order.status.isOpen) ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _saving ? null : _cancelRepair,
                                  child: const Text('لغو تعمیر'),
                                ),
                              ],
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _saving
                                      ? null
                                      : () {
                                          // اجرت و قطعات قبلاً ذخیره شده‌اند.
                                          context.go('/');
                                        },
                                  icon: const Icon(
                                    Icons.pause_circle_outline,
                                  ),
                                  label: const Text(
                                    'نگه داشتن و رفتن به خانه',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.model,
    required this.plateDisplay,
    this.plateNormalized,
    required this.category,
  });

  final String model;
  final String plateDisplay;
  final String? plateNormalized;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              model,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            PlateDisplayLtr(
              plateDisplay: plateDisplay,
              plateNormalized: plateNormalized,
              style: theme.textTheme.titleMedium,
              compact: true,
            ),
            const SizedBox(height: 6),
            Text(
              category,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditablePartTile extends StatelessWidget {
  const _EditablePartTile({
    required this.part,
    required this.onEditPrice,
    required this.onRemove,
  });

  final RepairPart part;
  final VoidCallback onEditPrice;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCustomer = part.suppliedBy == PartSuppliedBy.customer;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onEditPrice,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 8, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part.partTitleSnapshot,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [
                          'تعداد ${PersianDigitFormatter.toPersian('${part.quantity}')}',
                          if (byCustomer) 'آورده مشتری',
                          if (!byCustomer && part.unitPrice > 0)
                            MoneyFormatter.format(part.lineTotal)
                          else if (!byCustomer)
                            'ورود قیمت',
                        ].join(' · '),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close),
              tooltip: 'حذف',
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({
    required this.partsTotal,
    required this.laborAmount,
    required this.discountAmount,
    required this.grandTotal,
    required this.onEditDiscount,
  });

  final int partsTotal;
  final int laborAmount;
  final int discountAmount;
  final int grandTotal;
  final VoidCallback onEditDiscount;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _DialogRow(
              label: 'جمع قطعات',
              value: MoneyFormatter.format(partsTotal),
            ),
            const SizedBox(height: 8),
            _DialogRow(
              label: 'اجرت',
              value: MoneyFormatter.format(laborAmount),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: onEditDiscount,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _DialogRow(
                  label: 'تخفیف',
                  value: discountAmount <= 0
                      ? 'افزودن تخفیف'
                      : MoneyFormatter.format(discountAmount),
                ),
              ),
            ),
            const Divider(height: 24),
            _DialogRow(
              label: 'جمع کل',
              value: MoneyFormatter.format(grandTotal),
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogRow extends StatelessWidget {
  const _DialogRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : theme.textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
