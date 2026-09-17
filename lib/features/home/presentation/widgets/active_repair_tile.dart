import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/enums.dart';
import '../../domain/entities/active_repair.dart';

class ActiveRepairTile extends StatelessWidget {
  const ActiveRepairTile({super.key, required this.repair});

  final ActiveRepair repair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final path = switch (repair.status) {
      RepairOrderStatus.accepted => '/repair/${repair.repairOrderId}/intake',
      RepairOrderStatus.readyForDelivery =>
        '/repair/${repair.repairOrderId}/summary',
      _ => '/repair/${repair.repairOrderId}/summary',
    };

    final highlight = repair.isHighlighted;
    final bg = highlight
        ? theme.colorScheme.tertiary.withValues(alpha: 0.12)
        : theme.colorScheme.primary.withValues(alpha: 0.06);
    final accent = highlight
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  highlight
                      ? (repair.status == RepairOrderStatus.waitingForParts
                          ? Icons.inventory_2_outlined
                          : Icons.done_all_outlined)
                      : Icons.build_circle_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      repair.vehicleModel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${repair.statusLabel} · ${repair.plateDisplay}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: highlight
                            ? accent
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            highlight ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                repair.status == RepairOrderStatus.readyForDelivery
                    ? 'تحویل'
                    : 'ادامه',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.chevron_right, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}
