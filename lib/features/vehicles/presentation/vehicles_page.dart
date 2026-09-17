import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../data/providers.dart';
import '../domain/entities/vehicle_list_item.dart';

class VehiclesPage extends ConsumerStatefulWidget {
  const VehiclesPage({super.key});

  @override
  ConsumerState<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends ConsumerState<VehiclesPage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filter = ref.watch(vehicleVisitFilterProvider);
    final async = ref.watch(vehiclesListProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text('خودروها', style: theme.textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value.trim()),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'جستجو پلاک، مدل یا مشتری',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final item in const [
                  (VehicleVisitFilter.all, 'همه'),
                  (VehicleVisitFilter.today, 'امروز'),
                  (VehicleVisitFilter.week, 'هفته'),
                  (VehicleVisitFilter.month, 'این ماه'),
                ]) ...[
                  _FilterPill(
                    label: item.$2,
                    selected: filter == item.$1,
                    onTap: () => ref
                        .read(vehicleVisitFilterProvider.notifier)
                        .state = item.$1,
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('خطا در بارگذاری خودروها')),
              data: (items) {
                final filtered = _applySearch(items, _query);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      items.isEmpty
                          ? 'هنوز خودرویی ثبت نشده'
                          : 'نتیجه‌ای پیدا نشد',
                      style: theme.textTheme.bodyLarge,
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(vehiclesListProvider);
                    await ref.read(vehiclesListProvider.future);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _VehicleCard(
                        item: item,
                        filter: filter,
                        onTap: () =>
                            context.push('/vehicle/${item.vehicle.id}'),
                      );
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

  List<VehicleListItem> _applySearch(List<VehicleListItem> items, String q) {
    if (q.isEmpty) {
      return items;
    }
    final needle = q.toLowerCase();
    return items.where((item) {
      final v = item.vehicle;
      final hay = [
        v.plateDisplay,
        v.plateNormalized,
        item.modelLabel,
        item.customerName ?? '',
        v.manufacturer ?? '',
        v.model ?? '',
      ].join(' ').toLowerCase();
      return hay.contains(needle);
    }).toList();
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
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
    return Material(
      color: selected
          ? theme.colorScheme.primary
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.item,
    required this.filter,
    required this.onTap,
  });

  final VehicleListItem item;
  final VehicleVisitFilter filter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periodLabel = switch (filter) {
      VehicleVisitFilter.all => 'کل مراجعات',
      VehicleVisitFilter.today => 'مراجعه امروز',
      VehicleVisitFilter.week => 'مراجعه این هفته',
      VehicleVisitFilter.month => 'مراجعه این ماه',
    };

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.modelLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${PersianDigitFormatter.intToPersian(item.visitCount)} $periodLabel',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IranianPlateWidget(
                value: IranianPlateValue.fromAny(item.vehicle.plateNormalized),
                compact: true,
              ),
              if (item.customerName != null &&
                  item.customerName!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  item.customerName!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (item.lastVisitAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'آخرین مراجعه: ${JalaliDateFormatter.format(item.lastVisitAt!)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
