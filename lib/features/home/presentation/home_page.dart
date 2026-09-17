import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/enums.dart';
import '../data/providers.dart';
import '../../../features/settings/data/providers.dart';
import '../domain/entities/active_repair.dart';
import 'widgets/active_repair_tile.dart';
import 'widgets/home_header.dart';
import 'widgets/home_stats_card.dart';
import 'widgets/plate_entry_bottom_sheet.dart';
import 'widgets/recent_visit_tile.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final workshopAsync = ref.watch(workshopProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const _HomeLoading(),
          error: (error, _) => _HomeError(
            onRetry: () => ref.invalidate(homeDashboardProvider),
          ),
          data: (dashboard) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(homeDashboardProvider);
                await ref.read(homeDashboardProvider.future);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
                children: [
                  HomeHeader(workshop: workshopAsync.valueOrNull),
                  const SizedBox(height: 20),
                  HomeStatsCard(dashboard: dashboard),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => context.push('/scan'),
                    icon: const Icon(Icons.photo_camera_outlined, size: 26),
                    label: const Text('اسکن پلاک'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => showPlateEntryBottomSheet(context),
                    icon: Icon(
                      Icons.keyboard_outlined,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                    label: const Text('ورود دستی پلاک'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => context.push('/finance'),
                    icon: const Icon(Icons.insights_outlined),
                    label: const Text('گزارش مالی'),
                  ),
                  if (dashboard.activeRepairs.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text(
                      'تعمیرهای باز',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'گروه‌بندی بر اساس وضعیت — منتظر قطعه و آماده تحویل برجسته هستند',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildGroupedActiveRepairs(
                      theme,
                      dashboard.activeRepairs,
                    ),
                  ],
                  const SizedBox(height: 28),
                  Text(
                    'آخرین مراجعه‌ها',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (dashboard.recentVisits.isEmpty)
                    const _RecentEmptyState()
                  else
                    ...[
                      for (var i = 0; i < dashboard.recentVisits.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        RecentVisitTile(visit: dashboard.recentVisits[i]),
                      ],
                    ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<Widget> _buildGroupedActiveRepairs(
  ThemeData theme,
  List<ActiveRepair> repairs,
) {
  final order = <RepairOrderStatus>[
    RepairOrderStatus.waitingForParts,
    RepairOrderStatus.readyForDelivery,
    RepairOrderStatus.inRepair,
    RepairOrderStatus.awaitingReview,
    RepairOrderStatus.accepted,
  ];
  final widgets = <Widget>[];
  for (final status in order) {
    final group = repairs.where((r) => r.status == status).toList();
    if (group.isEmpty) continue;
    widgets.add(
      Padding(
        padding: EdgeInsets.only(top: widgets.isEmpty ? 0 : 16, bottom: 8),
        child: Text(
          status.labelFa,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: status == RepairOrderStatus.waitingForParts ||
                    status == RepairOrderStatus.readyForDelivery
                ? theme.colorScheme.tertiary
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
    for (var i = 0; i < group.length; i++) {
      if (i > 0) widgets.add(const SizedBox(height: 8));
      widgets.add(ActiveRepairTile(repair: group[i]));
    }
  }
  return widgets;
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('در حال بارگذاری...'),
        ],
      ),
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'خطا در دریافت اطلاعات صفحه اصلی',
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'لطفاً دوباره تلاش کنید.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              child: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentEmptyState extends StatelessWidget {
  const _RecentEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 40,
            color: theme.colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            'هنوز مراجعه‌ای ثبت نشده است',
            style: theme.textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'با اسکن یا ورود پلاک، اولین تعمیر را ثبت کنید.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
