import 'package:flutter/material.dart';

import '../../domain/vehicle_model_catalog.dart';

/// نتیجه انتخاب از شیت مدل‌های «سایر».
sealed class OtherVehicleModelPick {
  const OtherVehicleModelPick();
}

class OtherVehicleModelNamed extends OtherVehicleModelPick {
  const OtherVehicleModelNamed(this.model);
  final String model;
}

class OtherVehicleModelCustom extends OtherVehicleModelPick {
  const OtherVehicleModelCustom();
}

Future<OtherVehicleModelPick?> showOtherVehicleModelSheet({
  required BuildContext context,
  String? currentModel,
}) {
  return showModalBottomSheet<OtherVehicleModelPick>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _OtherVehicleModelSheet(currentModel: currentModel),
  );
}

class _OtherVehicleModelSheet extends StatefulWidget {
  const _OtherVehicleModelSheet({this.currentModel});

  final String? currentModel;

  @override
  State<_OtherVehicleModelSheet> createState() => _OtherVehicleModelSheetState();
}

class _OtherVehicleModelSheetState extends State<_OtherVehicleModelSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VehicleModelBrandGroup> get _filteredGroups {
    final q = _query.trim();
    if (q.isEmpty) {
      return otherVehicleModelGroups;
    }
    return [
      for (final group in otherVehicleModelGroups)
        if (group.brand.contains(q) ||
            group.models.any((m) => m.contains(q)))
          VehicleModelBrandGroup(
            brand: group.brand,
            models: [
              for (final m in group.models)
                if (m.contains(q) || group.brand.contains(q)) m,
            ],
          ),
    ].where((g) => g.models.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.78;
    final groups = _filteredGroups;
    final current = widget.currentModel?.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'انتخاب مدل خودرو',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'چینی، ژاپنی و برندهای معروف — یا دستی بنویسید',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'جستجو در مدل‌ها…',
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
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
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  ),
                ),
                leading: Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('سایر — نوشتن دستی'),
                subtitle: const Text('اگر مدل را پیدا نکردید'),
                onTap: () =>
                    Navigator.of(context).pop(const OtherVehicleModelCustom()),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: groups.isEmpty
                  ? Center(
                      child: Text(
                        'مدلی پیدا نشد',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                              child: Text(
                                group.brand,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            for (final model in group.models)
                              ListTile(
                                dense: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                selected: current == model,
                                selectedTileColor: theme
                                    .colorScheme.primaryContainer
                                    .withValues(alpha: 0.45),
                                title: Text(model),
                                trailing: current == model
                                    ? Icon(
                                        Icons.check_circle,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      )
                                    : null,
                                onTap: () => Navigator.of(context).pop(
                                  OtherVehicleModelNamed(model),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
