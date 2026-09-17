import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/enums.dart';
import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/formatters/phone_normalizer.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../../invoices/data/providers.dart';
import '../../invoices/data/services/invoice_pdf_builder.dart';
import '../../invoices/domain/entities/invoice_totals.dart';
import '../../reminders/data/providers.dart';
import '../../repair_orders/data/providers.dart';
import '../../repair_orders/domain/entities/repair_order.dart';
import '../../repair_orders/domain/entities/repair_part.dart';
import '../../settings/data/providers.dart';
import '../../settings/domain/entities/bank_account.dart';
import '../../settings/domain/entities/workshop.dart';
import '../../vehicles/data/providers.dart';
import '../../vehicles/domain/entities/customer.dart';
import '../../vehicles/domain/entities/vehicle.dart';
import '../data/providers.dart';
import '../domain/entities/repair_ready_message_input.dart';
import '../domain/services/customer_message_sender.dart';
import '../domain/services/repair_ready_message_composer.dart';

/// پیش‌نمایش و تنظیم پیام تعمیر قبل از واتساپ/اشتراک.
class RepairMessagePreviewPage extends ConsumerStatefulWidget {
  const RepairMessagePreviewPage({
    super.key,
    required this.repairId,
  });

  final String repairId;

  @override
  ConsumerState<RepairMessagePreviewPage> createState() =>
      _RepairMessagePreviewPageState();
}

class _RepairMessagePreviewPageState
    extends ConsumerState<RepairMessagePreviewPage> {
  bool _loading = true;
  bool _sending = false;
  String? _errorText;
  String _message = '';
  String? _phone;
  String? _vehicleId;
  bool _hasValidPhone = false;

  bool _includePriceDetails = false;
  DateTime? _deliveryAt;
  int _dayOffset = 0; // 0 امروز، 1 فردا، 2 پس‌فردا، یا weekday offset
  int _morningHour = 9;
  int _afternoonHour = 17;
  int _nightHour = 20;
  int _hour = 17;
  bool _enableWhatsApp = true;
  bool _enableTelegram = false;
  bool _enableSms = false;
  bool _buildingInvoice = false;

  RepairReadyMessageInput? _baseInput;
  RepairOrder? _order;
  Vehicle? _vehicle;
  Customer? _customer;
  Workshop? _workshop;
  List<RepairPart> _parts = const [];
  InvoiceTotals? _totals;
  List<BankAccount> _banks = const [];
  bool _includeBankInfoInMessages = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  DateTime get _now => DateTime.now();

  DateTime _buildDeliveryAt({int? dayOffset, int? hour}) {
    final offset = dayOffset ?? _dayOffset;
    final h = hour ?? _hour;
    final base = DateTime(_now.year, _now.month, _now.day)
        .add(Duration(days: offset));
    return DateTime(base.year, base.month, base.day, h);
  }

  void _rebuildMessage() {
    final base = _baseInput;
    if (base == null) {
      return;
    }
    final delivery = _deliveryAt == null
        ? null
        : RepairReadyMessageComposer.formatDeliveryLine(_deliveryAt!);
    final message = RepairReadyMessageComposer.compose(
      RepairReadyMessageInput(
        customerName: base.customerName,
        vehicleModel: base.vehicleModel,
        serviceGroups: base.serviceGroups,
        grandTotalToman: base.grandTotalToman,
        workshopName: base.workshopName,
        laborAmount: base.laborAmount,
        discountAmount: base.discountAmount,
        includePriceDetails: _includePriceDetails,
        deliveryLine: delivery,
        reminderLines: base.reminderLines,
        bankInfoLines: _includeBankInfoInMessages
            ? base.bankInfoLines
            : const [],
      ),
    );
    setState(() => _message = message);
  }

  List<String> _formatBankLines(List<BankAccount> banks) {
    final lines = <String>[];
    for (final bank in banks) {
      final parts = <String>[bank.bankName];
      if (bank.accountHolderName?.trim().isNotEmpty == true) {
        parts.add('به نام ${bank.accountHolderName!.trim()}');
      }
      if (bank.cardNumber?.trim().isNotEmpty == true) {
        parts.add(
          'کارت ${PersianDigitFormatter.toPersian(bank.cardNumber!.trim())}',
        );
      }
      if (bank.accountNumber?.trim().isNotEmpty == true) {
        parts.add(
          'حساب ${PersianDigitFormatter.toPersian(bank.accountNumber!.trim())}',
        );
      }
      lines.add(parts.join(' — '));
    }
    return lines;
  }

  Future<void> _load() async {
    try {
      final repairRepo = ref.read(repairOrderRepositoryProvider);
      final order = await repairRepo.getById(widget.repairId);
      if (order == null) {
        if (!mounted) {
          return;
        }
        setState(() {
          _loading = false;
          _errorText = 'تعمیر پیدا نشد.';
        });
        return;
      }

      final vehicle =
          await ref.read(vehicleRepositoryProvider).getById(order.vehicleId);
      Customer? customerEntity;
      CustomerNamePhone? customer;
      if (order.customerId != null) {
        final row = await ref
            .read(customerRepositoryProvider)
            .getById(order.customerId!);
        if (row != null) {
          customerEntity = row;
          customer = CustomerNamePhone(name: row.fullName, phone: row.phone);
        }
      }
      if (customer == null && vehicle?.customerId != null) {
        final row = await ref
            .read(customerRepositoryProvider)
            .getById(vehicle!.customerId!);
        if (row != null) {
          customerEntity = row;
          customer = CustomerNamePhone(name: row.fullName, phone: row.phone);
        }
      }

      final services = await repairRepo.getServices(order.id);
      final parts = await repairRepo.getParts(order.id);
      final totals = await repairRepo.calculateInvoiceTotals(order.id);
      final workshop = await ref.read(workshopRepositoryProvider).getWorkshop();
      _morningHour = workshop?.morningHour ?? 9;
      _afternoonHour = workshop?.afternoonHour ?? 17;
      _nightHour = workshop?.nightHour ?? 20;
      _hour = _afternoonHour;
      _enableWhatsApp = workshop?.enableWhatsApp ?? true;
      _enableTelegram = workshop?.enableTelegram ?? false;
      _enableSms = workshop?.enableSms ?? false;
      _includeBankInfoInMessages = workshop?.includeBankInfoInMessages ?? false;
      _order = order;
      _vehicle = vehicle;
      _customer = customerEntity;
      _workshop = workshop;
      _parts = parts;
      _totals = totals;
      if (workshop != null) {
        _banks = await ref
            .read(bankAccountRepositoryProvider)
            .listForWorkshop(workshop.id);
      } else {
        _banks = const [];
      }
      final reminders = await ref
          .read(reminderRepositoryProvider)
          .getForVehicle(order.vehicleId);
      final pendingReminders = reminders
          .where((item) => item.status == ReminderStatus.pending)
          .toList();

      final modelParts = [
        if (vehicle?.manufacturer != null &&
            vehicle!.manufacturer!.trim().isNotEmpty)
          vehicle.manufacturer!.trim(),
        if (vehicle?.model != null && vehicle!.model!.trim().isNotEmpty)
          vehicle.model!.trim(),
      ];
      final modelLabel = modelParts.isEmpty ? 'خودرو' : modelParts.join(' ');

      final groups = _groupPartsByService(services.map((s) => s.title).toList(), parts);

      final base = RepairReadyMessageInput(
        customerName: customer?.name,
        vehicleModel: modelLabel,
        serviceGroups: groups,
        grandTotalToman: totals.grandTotal,
        workshopName:
            workshop?.name ?? RepairReadyMessageComposer.defaultWorkshopName,
        laborAmount: order.laborAmount,
        discountAmount: order.discountAmount,
        reminderLines: pendingReminders
            .map(
              (item) => RepairReadyMessageComposer.formatReminderLine(
                title: item.title,
                dueDate: item.dueDate,
                dueMileage: item.dueMileage,
                currentMileage: vehicle?.lastMileage,
              ),
            )
            .toList(),
        bankInfoLines: _formatBankLines(_banks),
      );

      final phone = customer?.phone;
      final normalized =
          phone == null ? null : PhoneNormalizer.normalize(phone);

      if (!mounted) {
        return;
      }
      _baseInput = base;
      _deliveryAt = _buildDeliveryAt();
      setState(() {
        _phone = normalized;
        _hasValidPhone = normalized != null;
        _vehicleId = order.vehicleId;
        _loading = false;
      });
      _rebuildMessage();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorText = 'خطا در آماده‌سازی پیام.';
      });
    }
  }

  List<MessageServiceGroup> _groupPartsByService(
    List<String> serviceTitles,
    List<RepairPart> parts,
  ) {
    final partLines = parts
        .map(
          (part) => MessagePartLine(
            title: part.partTitleSnapshot,
            quantity: part.quantity,
            unitPrice: part.unitPrice,
            lineTotal: part.lineTotal,
            byCustomer: part.suppliedBy == PartSuppliedBy.customer,
          ),
        )
        .toList();

    if (serviceTitles.isEmpty) {
      if (partLines.isEmpty) {
        return const [];
      }
      return [
        MessageServiceGroup(serviceTitle: 'خدمات انجام‌شده', parts: partLines),
      ];
    }

    // فعلاً همه قطعات زیر خدمت اصلی (اولین دسته) می‌آیند؛
    // اگر چند خدمت باشد، فقط عنوان‌ها را جدا نشان می‌دهیم.
    return [
      for (var i = 0; i < serviceTitles.length; i++)
        MessageServiceGroup(
          serviceTitle: serviceTitles[i],
          parts: i == 0 ? partLines : const [],
        ),
    ];
  }

  void _selectDay(int offset) {
    setState(() {
      _dayOffset = offset;
      _deliveryAt = _buildDeliveryAt(dayOffset: offset);
    });
    _rebuildMessage();
  }

  void _selectHour(int hour) {
    setState(() {
      _hour = hour;
      _deliveryAt = _buildDeliveryAt(hour: hour);
    });
    _rebuildMessage();
  }

  Future<void> _sendVia(CustomerMessageSendChannel channel) async {
    if (_sending || _message.isEmpty) {
      return;
    }
    setState(() {
      _sending = true;
      _errorText = null;
    });
    try {
      final result =
          await ref.read(customerMessageSenderProvider).openPreparedMessage(
                message: _message,
                phone: _hasValidPhone ? _phone : null,
                preferred: channel,
              );
      if (!mounted) {
        return;
      }
      final hint = switch (result.channel) {
        CustomerMessageSendChannel.whatsapp =>
          'واتساپ باز شد. ارسال را خودتان تأیید کنید.',
        CustomerMessageSendChannel.telegram =>
          'تلگرام باز شد. ارسال را خودتان تأیید کنید.',
        CustomerMessageSendChannel.sms =>
          'برنامه پیامک باز شد. ارسال را خودتان تأیید کنید.',
        CustomerMessageSendChannel.systemShare => 'پنجره اشتراک‌گذاری باز شد.',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hint)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorText = 'باز کردن کانال پیام ممکن نشد. لطفاً دوباره تلاش کنید.';
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  Future<void> _shareInvoicePdf(CustomerMessageSendChannel? channel) async {
    final order = _order;
    final vehicle = _vehicle;
    final workshop = _workshop;
    final totals = _totals;
    if (_buildingInvoice ||
        order == null ||
        vehicle == null ||
        workshop == null ||
        totals == null) {
      return;
    }
    setState(() => _buildingInvoice = true);
    try {
      final invoiceNumber =
          (order.invoiceNumber == null || order.invoiceNumber!.isEmpty)
              ? '-----'
              : order.invoiceNumber!;
      final payments = await ref
          .read(invoiceRepositoryProvider)
          .listPayments(order.id);
      final file = await InvoicePdfBuilder().build(
        InvoicePdfInput(
          invoiceNumber: invoiceNumber,
          issuedAt: order.completedAt ?? DateTime.now(),
          workshop: workshop,
          vehicle: vehicle,
          customer: _customer,
          parts: _parts,
          totals: totals,
          mileage: order.mileage,
          bankAccounts: _banks,
          payments: payments,
          paymentStatus: order.paymentStatus,
        ),
      );
      await ref.read(customerMessageSenderProvider).shareFile(
            filePath: file.path,
            text:
                'فاکتور شماره ${PersianDigitFormatter.toPersian(invoiceNumber)} — ${workshop.name}',
            preferred: channel,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فاکتور PDF آماده اشتراک‌گذاری است.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ساخت فاکتور PDF با خطا مواجه شد.')),
      );
    } finally {
      if (mounted) {
        setState(() => _buildingInvoice = false);
      }
    }
  }

  void _copyMessage() {
    Clipboard.setData(ClipboardData(text: _message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('متن پیام کپی شد.')),
    );
  }

  void _goToVehicle() {
    final vehicleId = _vehicleId;
    if (vehicleId == null) {
      context.go('/');
      return;
    }
    context.go('/vehicle/$vehicleId');
  }

  void _acceptNewCar() => context.go('/');

  Future<void> _addReminder() async {
    await context.push('/repair/${widget.repairId}/reminder');
    if (mounted) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppPageAppBar(
        title: 'پیام به مشتری',
        actions: [
          if (!_loading && _message.isNotEmpty)
            IconButton(
              onPressed: _copyMessage,
              icon: const Icon(Icons.copy_outlined),
              tooltip: 'کپی متن',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorText != null && _message.isEmpty
              ? Center(child: Text(_errorText!))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _DeliveryPickerCard(
                              dayOffset: _dayOffset,
                              hour: _hour,
                              morningHour: _morningHour,
                              afternoonHour: _afternoonHour,
                              nightHour: _nightHour,
                              deliveryAt: _deliveryAt,
                              onSelectDay: _selectDay,
                              onSelectHour: _selectHour,
                            ),
                            const SizedBox(height: 12),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: _includePriceDetails,
                              onChanged: (value) {
                                setState(() {
                                  _includePriceDetails = value ?? false;
                                });
                                _rebuildMessage();
                              },
                              title: const Text('نمایش جزئیات قیمت در پیام'),
                              subtitle: const Text(
                                'اجرت و هزینه هر قطعه به متن اضافه شود',
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            const SizedBox(height: 8),
                            if (_hasValidPhone)
                              Text(
                                'شماره: ${PhoneNormalizer.formatDisplay(_phone!)}',
                                style: theme.textTheme.bodyMedium,
                              )
                            else
                              Text(
                                'شماره موبایل معتبر ثبت نشده؛ می‌توانید پیام را اشتراک بگذارید.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              'پیش‌نمایش پیام',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SelectableText(
                                  _message,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    height: 1.55,
                                  ),
                                ),
                              ),
                            ),
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
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ChannelActionsRow(
                              enableWhatsApp: _enableWhatsApp,
                              enableTelegram: _enableTelegram,
                              enableSms: _enableSms,
                              sending: _sending,
                              onSend: _sendVia,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'فاکتور PDF',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _InvoiceShareRow(
                              enableWhatsApp: _enableWhatsApp,
                              enableTelegram: _enableTelegram,
                              building: _buildingInvoice,
                              onShare: _shareInvoicePdf,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 44),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                    ),
                                    onPressed: _addReminder,
                                    icon: const Icon(
                                      Icons.alarm_add_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('یادآوری'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FilledButton.tonalIcon(
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(0, 44),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                    ),
                                    onPressed: _acceptNewCar,
                                    icon: const Icon(
                                      Icons.directions_car_outlined,
                                      size: 18,
                                    ),
                                    label: const Text('خودرو جدید'),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: _goToVehicle,
                              child: const Text('بازگشت به پرونده خودرو'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _DeliveryPickerCard extends StatelessWidget {
  const _DeliveryPickerCard({
    required this.dayOffset,
    required this.hour,
    required this.morningHour,
    required this.afternoonHour,
    required this.nightHour,
    required this.deliveryAt,
    required this.onSelectDay,
    required this.onSelectHour,
  });

  final int dayOffset;
  final int hour;
  final int morningHour;
  final int afternoonHour;
  final int nightHour;
  final DateTime? deliveryAt;
  final ValueChanged<int> onSelectDay;
  final ValueChanged<int> onSelectHour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final weekDays = List.generate(7, (i) {
      final date = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      return (offset: i, date: date);
    });

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'زمان تحویل',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'یک روز و یک ساعت را انتخاب کنید',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Text('روز', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in [
                  (0, 'امروز'),
                  (1, 'فردا'),
                  (2, 'پس‌فردا'),
                ])
                  _SelectChip(
                    label: item.$2,
                    selected: dayOffset == item.$1,
                    onTap: () => onSelectDay(item.$1),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text('روز هفته', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in weekDays) ...[
                    _SelectChip(
                      label:
                          '${JalaliDateFormatter.formatWeekday(item.date)}\n${JalaliDateFormatter.format(item.date)}',
                      selected: dayOffset == item.offset,
                      onTap: () => onSelectDay(item.offset),
                      multiline: true,
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text('ساعت', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final item in [
                  (morningHour, 'صبح'),
                  (afternoonHour, 'عصر'),
                  (nightHour, 'شب'),
                ]) ...[
                  Expanded(
                    child: _SelectChip(
                      label:
                          '${item.$2}\nساعت ${PersianDigitFormatter.intToPersian(item.$1)}',
                      selected: hour == item.$1,
                      onTap: () => onSelectHour(item.$1),
                      multiline: true,
                      expand: true,
                    ),
                  ),
                  if (item.$1 != nightHour) const SizedBox(width: 8),
                ],
              ],
            ),
            if (deliveryAt != null) ...[
              const SizedBox(height: 14),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    RepairReadyMessageComposer.formatDeliveryLine(deliveryAt!),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.multiline = false,
    this.expand = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool multiline;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Material(
      color: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: expand ? double.infinity : null,
          padding: EdgeInsets.symmetric(
            horizontal: multiline ? 12 : 14,
            vertical: multiline ? 10 : 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              height: multiline ? 1.25 : 1.1,
              fontSize: multiline ? 12 : 14,
              fontWeight: FontWeight.w700,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
    return child;
  }
}

class _ChannelActionsRow extends StatelessWidget {
  const _ChannelActionsRow({
    required this.enableWhatsApp,
    required this.enableTelegram,
    required this.enableSms,
    required this.sending,
    required this.onSend,
  });

  final bool enableWhatsApp;
  final bool enableTelegram;
  final bool enableSms;
  final bool sending;
  final Future<void> Function(CustomerMessageSendChannel channel) onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttons = <Widget>[
      if (enableWhatsApp)
        _CompactChannelButton(
          label: 'واتساپ',
          icon: Icons.chat_outlined,
          filled: true,
          color: theme.colorScheme.secondary,
          foreground: theme.colorScheme.onSecondary,
          onPressed: sending
              ? null
              : () => onSend(CustomerMessageSendChannel.whatsapp),
        ),
      if (enableTelegram)
        _CompactChannelButton(
          label: 'تلگرام',
          icon: Icons.send_outlined,
          tonal: true,
          onPressed: sending
              ? null
              : () => onSend(CustomerMessageSendChannel.telegram),
        ),
      if (enableSms)
        _CompactChannelButton(
          label: 'پیامک',
          icon: Icons.sms_outlined,
          onPressed: sending
              ? null
              : () => onSend(CustomerMessageSendChannel.sms),
        ),
      if (!enableWhatsApp && !enableTelegram && !enableSms)
        _CompactChannelButton(
          label: 'اشتراک',
          icon: Icons.share_outlined,
          filled: true,
          onPressed: sending
              ? null
              : () => onSend(CustomerMessageSendChannel.systemShare),
        ),
    ];

    return Row(
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(child: buttons[i]),
        ],
      ],
    );
  }
}

class _InvoiceShareRow extends StatelessWidget {
  const _InvoiceShareRow({
    required this.enableWhatsApp,
    required this.enableTelegram,
    required this.building,
    required this.onShare,
  });

  final bool enableWhatsApp;
  final bool enableTelegram;
  final bool building;
  final Future<void> Function(CustomerMessageSendChannel? channel) onShare;

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[
      if (enableWhatsApp)
        _CompactChannelButton(
          label: 'PDF واتساپ',
          icon: Icons.picture_as_pdf_outlined,
          onPressed: building
              ? null
              : () => onShare(CustomerMessageSendChannel.whatsapp),
        ),
      if (enableTelegram)
        _CompactChannelButton(
          label: 'PDF تلگرام',
          icon: Icons.picture_as_pdf_outlined,
          onPressed: building
              ? null
              : () => onShare(CustomerMessageSendChannel.telegram),
        ),
      if (!enableWhatsApp && !enableTelegram)
        _CompactChannelButton(
          label: 'اشتراک فاکتور PDF',
          icon: Icons.picture_as_pdf_outlined,
          onPressed: building ? null : () => onShare(null),
        ),
    ];

    return Row(
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(child: buttons[i]),
        ],
      ],
    );
  }
}

class _CompactChannelButton extends StatelessWidget {
  const _CompactChannelButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
    this.tonal = false,
    this.color,
    this.foreground,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool tonal;
  final Color? color;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      visualDensity: VisualDensity.standard,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
      ),
      iconSize: const WidgetStatePropertyAll(18),
      backgroundColor: color != null
          ? WidgetStatePropertyAll(color)
          : null,
      foregroundColor: foreground != null
          ? WidgetStatePropertyAll(foreground)
          : null,
    );

    if (filled) {
      return FilledButton.icon(
        style: style,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      );
    }
    if (tonal) {
      return FilledButton.tonalIcon(
        style: style,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      );
    }
    return OutlinedButton.icon(
      style: style,
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class CustomerNamePhone {
  const CustomerNamePhone({this.name, this.phone});

  final String? name;
  final String? phone;
}
