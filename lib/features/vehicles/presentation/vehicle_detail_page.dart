import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../../../core/formatters/phone_normalizer.dart';
import '../../../core/theme_constants.dart';
import '../../repair_orders/data/providers.dart';
import '../../repair_orders/domain/entities/repair_order.dart';
import '../data/providers.dart';
import '../domain/entities/vehicle_profile.dart';
import '../domain/entities/vehicle_repair_summary.dart';

class VehicleDetailPage extends ConsumerWidget {
  const VehicleDetailPage({
    super.key,
    required this.vehicleId,
    this.showScanSuccess = false,
  });

  final String vehicleId;
  final bool showScanSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(vehicleProfileProvider(vehicleId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppPageAppBar(title: 'پرونده خودرو'),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'خطا در بارگذاری پرونده خودرو',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(vehicleProfileProvider(vehicleId)),
                  child: const Text('تلاش مجدد'),
                ),
              ],
            ),
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('خودرو پیدا نشد.'));
          }
          return _VehicleProfileBody(
            profile: profile,
            showScanSuccess: showScanSuccess,
          );
        },
      ),
    );
  }
}

class _VehicleProfileBody extends ConsumerStatefulWidget {
  const _VehicleProfileBody({
    required this.profile,
    required this.showScanSuccess,
  });

  final VehicleProfile profile;
  final bool showScanSuccess;

  @override
  ConsumerState<_VehicleProfileBody> createState() =>
      _VehicleProfileBodyState();
}

class _VehicleProfileBodyState extends ConsumerState<_VehicleProfileBody> {
  bool _startingIntake = false;
  bool? _hasOpenRepair;
  List<VehicleMileageLogRow> _mileageLogs = const [];

  @override
  void initState() {
    super.initState();
    _checkOpenRepair();
    _loadMileageHistory();
  }

  Future<void> _loadMileageHistory() async {
    try {
      final logs = await ref
          .read(repairOrderRepositoryProvider)
          .listMileageLogs(widget.profile.vehicle.id);
      if (mounted) setState(() => _mileageLogs = logs);
    } catch (_) {
      // نمایش پرونده خودرو نباید با خطای تاریخچه متوقف شود.
    }
  }

  Future<void> _checkOpenRepair() async {
    final history = await ref
        .read(repairOrderRepositoryProvider)
        .getHistoryForVehicle(widget.profile.vehicle.id);
    if (!mounted) {
      return;
    }
    final open = history.any((item) => item.status.isOpen);
    setState(() => _hasOpenRepair = open);
  }

  Future<void> _startIntake() async {
    if (_startingIntake) {
      return;
    }
    setState(() => _startingIntake = true);

    try {
      final vehicle = widget.profile.vehicle;
      final repo = ref.read(repairOrderRepositoryProvider);
      final history = await repo.getHistoryForVehicle(vehicle.id);
      RepairOrder? open;
      for (final item in history) {
        if (item.status.isOpen) {
          open = item;
          break;
        }
      }
      if (open != null) {
        if (!mounted) {
          return;
        }
        final destination = open.status == RepairOrderStatus.accepted
            ? '/repair/${open.id}/intake'
            : '/repair/${open.id}/summary';
        context.push(destination);
        return;
      }

      final repairId = const Uuid().v4();
      final now = DateTime.now();
      await repo.create(
            RepairOrder(
              id: repairId,
              vehicleId: vehicle.id,
              customerId: vehicle.customerId,
              status: RepairOrderStatus.accepted,
              laborAmount: 0,
              discountAmount: 0,
              paymentStatus: PaymentStatus.unpaid,
              paidAmount: 0,
              createdAt: now,
            ),
          );
      if (!mounted) {
        return;
      }
      context.push('/repair/$repairId/intake');
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ایجاد پذیرش با خطا مواجه شد.')),
      );
    } finally {
      if (mounted) {
        setState(() => _startingIntake = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = widget.profile;
    final vehicle = profile.vehicle;
    final customer = profile.customer;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          if (widget.showScanSuccess) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: theme.colorScheme.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'پلاک با موفقیت شناسایی شد',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          PlateDisplayLtr(
            plateDisplay: vehicle.plateDisplay,
            plateNormalized: vehicle.plateNormalized,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(label: 'مدل خودرو', value: profile.modelLabel),
                  _InfoRow(
                    label: 'نام مشتری',
                    value: customer?.fullName?.trim().isNotEmpty == true
                        ? customer!.fullName!
                        : '—',
                  ),
                  _InfoRow(
                    label: 'شماره موبایل',
                    value: customer?.phone == null
                        ? '—'
                        : PhoneNormalizer.formatDisplay(customer!.phone!),
                  ),
                  _InfoRow(
                    label: 'آخرین مراجعه',
                    value: profile.lastVisitAt == null
                        ? '—'
                        : JalaliDateFormatter.format(profile.lastVisitAt!),
                  ),
                  _InfoRow(
                    label: 'آخرین کارکرد',
                    value: vehicle.lastMileage == null
                        ? '—'
                        : '${PersianDigitFormatter.intToPersian(vehicle.lastMileage!)} کیلومتر',
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('آخرین سابقه', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (profile.recentRepairs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                'هنوز تعمیری برای این خودرو ثبت نشده است.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )
          else
            ...[
              for (var i = 0; i < profile.recentRepairs.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                _RepairHistoryCard(summary: profile.recentRepairs[i]),
              ],
            ],
          const SizedBox(height: 24),
          Text('تاریخچه کارکرد', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          if (_mileageLogs.isEmpty)
            Text(
              'هنوز کارکردی ثبت نشده است.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (var index = 0; index < _mileageLogs.length; index++)
                    _MileageLogTile(
                      log: _mileageLogs[index],
                      previousLog: index + 1 < _mileageLogs.length
                          ? _mileageLogs[index + 1]
                          : null,
                      isLast: index == _mileageLogs.length - 1,
                    ),
                ],
              ),
            ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _startingIntake ? null : _startIntake,
            child: _startingIntake
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Text(
                    _hasOpenRepair == true ? 'ادامه تعمیر' : 'شروع پذیرش',
                  ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: AppTapTargets.large,
            child: OutlinedButton(
              onPressed: () => context.push('/vehicle/${vehicle.id}/edit'),
              child: const Text('ویرایش اطلاعات'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MileageLogTile extends StatelessWidget {
  const _MileageLogTile({
    required this.log,
    required this.previousLog,
    required this.isLast,
  });

  final VehicleMileageLogRow log;
  final VehicleMileageLogRow? previousLog;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delta = previousLog == null ? null : log.mileage - previousLog!.mileage;
    final deltaText = delta == null
        ? 'اولین ثبت'
        : '${delta >= 0 ? '+' : ''}${PersianDigitFormatter.intToPersian(delta)} کیلومتر';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  JalaliDateFormatter.format(log.recordedAt),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                '${PersianDigitFormatter.intToPersian(log.mileage)} کیلومتر',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              deltaText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: delta != null && delta < 0
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (!isLast) const Divider(height: 20),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
          ),
          Expanded(
            child:             Text(
              value,
              textAlign: TextAlign.start,
              style: theme.textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepairHistoryCard extends StatelessWidget {
  const _RepairHistoryCard({required this.summary});

  final VehicleRepairSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(summary.servicesTitle, style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              summary.mainParts,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  JalaliDateFormatter.format(summary.visitDate),
                  style: theme.textTheme.bodySmall,
                ),
                if (summary.mileage != null) ...[
                  const Spacer(),
                  Text(
                    '${PersianDigitFormatter.intToPersian(summary.mileage!)} کیلومتر',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
