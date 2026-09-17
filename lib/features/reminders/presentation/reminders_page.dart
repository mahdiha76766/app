import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../../../core/formatters/phone_normalizer.dart';
import '../../../core/theme_constants.dart';
import '../../messaging/data/providers.dart';
import '../../messaging/domain/services/customer_message_sender.dart';
import '../data/providers.dart';
import '../domain/entities/reminder.dart';
import '../domain/entities/reminder_card.dart';

/// صفحه لیست یادآوری‌ها: سررسید / نزدیک / آینده.
class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(reminderDashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppPageAppBar(title: 'یادآوری‌ها', showHome: false),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('خطا در بارگذاری یادآوری‌ها.')),
        data: (dashboard) {
          if (dashboard.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'یادآوری فعالی ثبت نشده است.\nپس از پایان تعمیر می‌توانید یادآوری اضافه کنید.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(reminderDashboardProvider);
              await ref.read(reminderDashboardProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _Section(
                  title: 'سررسیدشده',
                  cards: dashboard.due,
                  emphasize: true,
                  emptyLabel: 'موردی سررسید نشده.',
                ),
                const SizedBox(height: 20),
                _Section(
                  title: 'نزدیک',
                  cards: dashboard.near,
                  emptyLabel: 'یادآوری نزدیکی نیست.',
                ),
                const SizedBox(height: 20),
                _Section(
                  title: 'آینده',
                  cards: dashboard.future,
                  emptyLabel: 'یادآوری آینده‌ای نیست.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Section extends ConsumerWidget {
  const _Section({
    required this.title,
    required this.cards,
    required this.emptyLabel,
    this.emphasize = false,
  });

  final String title;
  final List<ReminderCard> cards;
  final String emptyLabel;
  final bool emphasize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: emphasize ? theme.colorScheme.error : null,
          ),
        ),
        const SizedBox(height: 8),
        if (cards.isEmpty)
          Text(
            emptyLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final card in cards) ...[
            _ReminderCardTile(card: card, showContactActions: emphasize),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _ReminderCardTile extends ConsumerStatefulWidget {
  const _ReminderCardTile({
    required this.card,
    required this.showContactActions,
  });

  final ReminderCard card;
  final bool showContactActions;

  @override
  ConsumerState<_ReminderCardTile> createState() => _ReminderCardTileState();
}

class _ReminderCardTileState extends ConsumerState<_ReminderCardTile> {
  bool _busy = false;

  Future<void> _openWhatsApp() async {
    final phone = widget.card.phone;
    if (phone == null || PhoneNormalizer.normalize(phone) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('شماره تماس معتبر ثبت نشده است.')),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final message = _buildReminderMessage(widget.card);
      final result =
          await ref.read(customerMessageSenderProvider).openPreparedMessage(
                message: message,
                phone: phone,
              );
      if (!mounted) {
        return;
      }
      final hint = result.channel == CustomerMessageSendChannel.whatsapp
          ? 'واتساپ باز شد. ارسال را خودتان تأیید کنید.'
          : 'پنجره اشتراک‌گذاری باز شد.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hint)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('باز کردن واتساپ ممکن نشد.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _markDone() async {
    final reminder = widget.card.reminder;
    final hasInterval =
        reminder.intervalDays != null || reminder.intervalMileage != null;
    var createNext = false;
    if (hasInterval) {
      createNext =
          await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('یادآوری بعدی ساخته شود؟'),
              content: const Text(
                'این یادآوری دوره‌ای است. آیا موعد بعدی آن ایجاد شود؟',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('خیر'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('بله'),
                ),
              ],
            ),
          ) ??
          false;
      if (!mounted) return;
    }

    final repository = ref.read(reminderRepositoryProvider);
    final notificationService =
        ref.read(reminderNotificationServiceProvider);
    final next = createNext
        ? await repository.markDoneAndMaybeCreateNext(reminder.id)
        : null;
    if (!createNext) {
      await repository.markDone(reminder.id);
    }
    await notificationService.cancelReminder(reminder.id);
    if (next != null) {
      await notificationService.scheduleReminder(next);
    }
    ref.invalidate(reminderDashboardProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = widget.card;
    final reminder = card.reminder;
    final name = (card.customerName == null || card.customerName!.trim().isEmpty)
        ? 'مشتری عزیز'
        : card.customerName!.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
        color: widget.showContactActions
            ? theme.colorScheme.errorContainer.withValues(alpha: 0.25)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showContactActions) ...[
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(card.vehicleModel, style: theme.textTheme.bodyLarge),
              PlateDisplayLtr(
                plateDisplay: card.plateDisplay,
                style: theme.textTheme.titleSmall,
                compact: true,
              ),
              const SizedBox(height: 8),
              Text(
                'سرویس: ${reminder.title}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (card.phone != null && card.phone!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'تماس: ${PhoneNormalizer.formatDisplay(card.phone!)}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ] else ...[
              Text(
                reminder.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text('${card.vehicleModel} — ${card.plateDisplay}'),
            ],
            const SizedBox(height: 8),
            Text(
              _dueDescription(reminder),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (widget.showContactActions) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: AppTapTargets.large,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                  ),
                  onPressed: _busy ? null : _openWhatsApp,
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('واتساپ'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _markDone,
                child: const Text('انجام شد'),
              ),
            ] else
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: _markDone,
                  child: const Text('انجام شد'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _dueDescription(Reminder reminder) {
    final parts = <String>[];
    if (reminder.dueDate != null) {
      parts.add('تاریخ: ${JalaliDateFormatter.formatLong(reminder.dueDate!)}');
    }
    if (reminder.dueMileage != null) {
      parts.add(
        'کیلومتر: ${PersianDigitFormatter.toPersian('${reminder.dueMileage}')}',
      );
    }
    return parts.isEmpty ? 'بدون موعد مشخص' : parts.join(' | ');
  }

  String _buildReminderMessage(ReminderCard card) {
    final name = (card.customerName == null || card.customerName!.trim().isEmpty)
        ? 'مشتری عزیز'
        : card.customerName!.trim();
    final buffer = StringBuffer()
      ..writeln('سلام $name')
      ..writeln()
      ..writeln(
        'یادآوری سرویس «${card.reminder.title}» برای خودروی ${card.vehicleModel} (${card.plateDisplay}).',
      );
    if (card.reminder.dueDate != null) {
      buffer.writeln(
        'موعد تاریخ: ${JalaliDateFormatter.formatLong(card.reminder.dueDate!)}',
      );
    }
    if (card.reminder.dueMileage != null) {
      buffer.writeln(
        'موعد کیلومتر: ${PersianDigitFormatter.toPersian('${card.reminder.dueMileage}')}',
      );
    }
    return buffer.toString().trim();
  }
}
