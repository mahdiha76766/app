import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/formatters/jalali_date_formatter.dart';
import '../../../../core/formatters/money_formatter.dart';
import '../../domain/entities/recent_visit.dart';

class RecentVisitTile extends StatelessWidget {
  const RecentVisitTile({super.key, required this.visit});

  final RecentVisit visit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/repair/${visit.repairOrderId}/summary'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                visit.vehicleModel,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                visit.serviceType,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      MoneyFormatter.format(visit.invoiceTotal),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Text(
                    JalaliDateFormatter.format(visit.visitDate),
                    style: theme.textTheme.bodySmall,
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
