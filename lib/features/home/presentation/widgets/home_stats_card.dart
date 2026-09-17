import 'package:flutter/material.dart';

import '../../../../core/formatters/money_formatter.dart';
import '../../../../core/formatters/persian_digit_formatter.dart';
import '../../domain/entities/home_dashboard.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({super.key, required this.dashboard});

  final HomeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'خودروهای امروز',
                    value: PersianDigitFormatter.intToPersian(
                      dashboard.todayVehicleCount,
                    ),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'دریافت امروز',
                    value: MoneyFormatter.format(
                      dashboard.todayIncome,
                      withSuffix: false,
                    ),
                    subtitle: 'تومان',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'یادآوری‌ها',
                    value: PersianDigitFormatter.intToPersian(
                      dashboard.dueReminderCount,
                    ),
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'بدهکار',
                    value: PersianDigitFormatter.intToPersian(
                      dashboard.unpaidDebtCount,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
