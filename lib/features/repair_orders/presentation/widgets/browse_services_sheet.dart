import 'package:flutter/material.dart';

import '../../../parts/domain/entities/service_category.dart';

/// انتخاب خدمت از همان لیست شروع پذیرش (دسته‌های خدمت).
Future<String?> showBrowseServicesSheet({
  required BuildContext context,
  required List<ServiceCategory> categories,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return _BrowseServicesSheet(categories: categories);
    },
  );
}

class _BrowseServicesSheet extends StatefulWidget {
  const _BrowseServicesSheet({required this.categories});

  final List<ServiceCategory> categories;

  @override
  State<_BrowseServicesSheet> createState() => _BrowseServicesSheetState();
}

class _BrowseServicesSheetState extends State<_BrowseServicesSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceCategory> get _filtered {
    final q = _query.trim();
    if (q.isEmpty) {
      return widget.categories;
    }
    return widget.categories
        .where((item) => item.title.contains(q))
        .toList();
  }

  IconData _iconFor(String iconKey) {
    switch (iconKey) {
      case 'periodic':
        return Icons.event_repeat_outlined;
      case 'engine':
        return Icons.settings_outlined;
      case 'suspension':
        return Icons.car_crash_outlined;
      case 'brake':
        return Icons.slow_motion_video_outlined;
      case 'electrical':
        return Icons.electrical_services_outlined;
      case 'ac':
        return Icons.ac_unit_outlined;
      case 'gearbox':
        return Icons.precision_manufacturing_outlined;
      case 'exhaust':
        return Icons.air_outlined;
      case 'body':
        return Icons.directions_car_filled_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  Future<void> _pickCustom() async {
    final controller = TextEditingController();
    final custom = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('عنوان سفارشی'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'مثلاً تعویض طبق',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('ادامه'),
            ),
          ],
        );
      },
    );
    // بعد از بسته شدن دیالوگ، در فریم بعدی dispose کن تا assertion ندهد.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dispose();
    });
    if (custom != null && mounted) {
      Navigator.of(context).pop(custom.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'انتخاب خدمت',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'جستجو',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.35,
                      ),
                      itemBuilder: (context, index) {
                        final category = _filtered[index];
                        return Material(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () =>
                                Navigator.of(context).pop(category.title),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _iconFor(category.iconKey),
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.title,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _pickCustom,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('عنوان سفارشی'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
