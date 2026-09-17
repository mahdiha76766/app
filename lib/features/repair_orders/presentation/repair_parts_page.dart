import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/enums.dart';
import '../../../core/formatters/money_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/formatters/text_normalizer.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../../parts/data/providers.dart';
import '../../parts/domain/entities/part.dart';
import '../../parts/domain/entities/service_category.dart';
import '../../vehicles/data/providers.dart';
import '../../vehicles/domain/entities/vehicle.dart';
import '../data/providers.dart';
import '../domain/entities/repair_order.dart';
import '../domain/entities/repair_part.dart';
import 'widgets/add_new_part_sheet.dart';
import 'widgets/browse_parts_sheet.dart';
import 'widgets/part_price_bottom_sheet.dart';

const _previewLimit = 12;

/// صفحه انتخاب و ثبت قطعات تعمیر.
class RepairPartsPage extends ConsumerStatefulWidget {
  const RepairPartsPage({
    super.key,
    required this.repairId,
  });

  final String repairId;

  @override
  ConsumerState<RepairPartsPage> createState() => _RepairPartsPageState();
}

class _RepairPartsPageState extends ConsumerState<RepairPartsPage> {
  RepairOrder? _order;
  Vehicle? _vehicle;
  ServiceCategory? _category;
  List<RepairPart> _selected = const [];
  List<Part> _categoryParts = const [];
  List<Part> _workshopParts = const [];
  List<Part> _searchResults = const [];
  bool _hasMoreCategory = false;
  bool _hasMoreWorkshop = false;
  bool _loading = true;
  bool _busy = false;
  String? _errorText;
  final _searchController = TextEditingController();
  final _priceQueue = <String>[];
  final _pendingLastPrices = <String, int?>{};
  bool _drainingPriceQueue = false;
  final _differentPrices = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          _errorText = 'پذیرش پیدا نشد.';
        });
        return;
      }

      final vehicle =
          await ref.read(vehicleRepositoryProvider).getById(order.vehicleId);
      final services = await repairRepo.getServices(order.id);
      final selected = await repairRepo.getParts(order.id);
      final categories =
          await ref.read(serviceCategoryRepositoryProvider).getActiveCategories();

      ServiceCategory? category;
      if (services.isNotEmpty) {
        final title = services.first.title;
        for (final item in categories) {
          if (item.title == title) {
            category = item;
            break;
          }
        }
      }

      final partRepo = ref.read(partRepositoryProvider);
      final categoryParts = category == null
          ? const <Part>[]
          : await partRepo.getPopularByCategory(
              category.id,
              limit: _previewLimit + 1,
            );
      final workshopParts = await partRepo.getPopularWorkshop(
        limit: _previewLimit + 1,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _order = order;
        _vehicle = vehicle;
        _category = category;
        _selected = selected;
        _categoryParts = categoryParts.take(_previewLimit).toList();
        _workshopParts = workshopParts.take(_previewLimit).toList();
        _hasMoreCategory = categoryParts.length > _previewLimit;
        _hasMoreWorkshop = workshopParts.length > _previewLimit;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorText = 'خطا در بارگذاری قطعات.';
      });
    }
  }

  Future<void> _reloadSelected() async {
    final selected = await ref
        .read(repairOrderRepositoryProvider)
        .getParts(widget.repairId);
    if (!mounted) {
      return;
    }
    setState(() => _selected = selected);
  }

  Future<void> _refreshSuggestions() async {
    final category = _category;
    final partRepo = ref.read(partRepositoryProvider);
    final categoryParts = category == null
        ? const <Part>[]
        : await partRepo.getPopularByCategory(
            category.id,
            limit: _previewLimit + 1,
          );
    final workshopParts = await partRepo.getPopularWorkshop(
      limit: _previewLimit + 1,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _categoryParts = categoryParts.take(_previewLimit).toList();
      _workshopParts = workshopParts.take(_previewLimit).toList();
      _hasMoreCategory = categoryParts.length > _previewLimit;
      _hasMoreWorkshop = workshopParts.length > _previewLimit;
    });
  }

  void _enqueuePriceEdit(String repairPartId, {int? lastPrice}) {
    _priceQueue.add(repairPartId);
    if (lastPrice != null) {
      _pendingLastPrices[repairPartId] = lastPrice;
    }
    _drainPriceQueue();
  }

  Future<void> _drainPriceQueue() async {
    if (_drainingPriceQueue || _priceQueue.isEmpty || !mounted) {
      return;
    }
    _drainingPriceQueue = true;
    while (_priceQueue.isNotEmpty && mounted) {
      final id = _priceQueue.removeAt(0);
      RepairPart? target;
      for (final item in _selected) {
        if (item.id == id) {
          target = item;
          break;
        }
      }
      if (target == null) {
        _pendingLastPrices.remove(id);
        continue;
      }
      if (!mounted) {
        break;
      }
      final lastPrice = _pendingLastPrices.remove(id);
      final result = await showPartPriceSheet(
        context: context,
        partTitle: target.partTitleSnapshot,
        vehicleModel: _vehicleTitle,
        lastPrice: lastPrice,
        initialUnitPrice: target.unitPrice,
      );
      if (!mounted) {
        break;
      }
      if (result != null) {
        await ref.read(repairOrderRepositoryProvider).updatePart(
              target.copyWith(unitPrice: result.unitPrice),
            );
        await _reloadSelected();
      }
    }
    _drainingPriceQueue = false;
  }

  Future<void> _onPartTapped(Part part) async {
    if (_busy || _order == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final lastPrice = await ref.read(partRepositoryProvider).getLatestPrice(
            normalizedTitle: part.normalizedTitle,
            vehicleModel: _vehicle?.model,
          );
      final repairPart = RepairPart(
        id: const Uuid().v4(),
        repairOrderId: widget.repairId,
        partId: part.id,
        partTitleSnapshot: part.title,
        brandSnapshot: part.brand,
        quantity: 1,
        unitPrice: 0,
        suppliedBy: PartSuppliedBy.workshop,
        createdAt: DateTime.now(),
      );
      await ref.read(repairOrderRepositoryProvider).addPart(repairPart);
      await _reloadSelected();
      _enqueuePriceEdit(repairPart.id, lastPrice: lastPrice);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _onSearchChanged(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() => _searchResults = const []);
      return;
    }
    final results = await ref.read(partRepositoryProvider).searchByTitle(
          trimmed,
          limit: _previewLimit,
        );
    if (!mounted || _searchController.text.trim() != trimmed) {
      return;
    }
    setState(() => _searchResults = results);
  }

  Future<void> _browseCategory() async {
    final category = _category;
    if (category == null) {
      return;
    }
    final part = await showBrowsePartsSheet(
      context: context,
      title: 'قطعات ${category.title}',
      loadParts: (query) async {
        final repo = ref.read(partRepositoryProvider);
        if (query.trim().isEmpty) {
          return repo.getPopularByCategory(category.id, limit: 80);
        }
        final searched = await repo.searchByTitle(query, limit: 80);
        return searched
            .where((item) => item.serviceCategoryId == category.id)
            .toList();
      },
    );
    if (part != null && mounted) {
      await _onPartTapped(part);
    }
  }

  Future<void> _browseWorkshop() async {
    final part = await showBrowsePartsSheet(
      context: context,
      title: 'قطعات پرتکرار تعمیرگاه',
      loadParts: (query) async {
        final repo = ref.read(partRepositoryProvider);
        if (query.trim().isEmpty) {
          return repo.getPopularWorkshop(limit: 80);
        }
        return repo.searchByTitle(query, limit: 80);
      },
    );
    if (part != null && mounted) {
      await _onPartTapped(part);
    }
  }

  Future<void> _addNewPart() async {
    final result = await showAddNewPartSheet(
      context: context,
      vehicleModel: _vehicleTitle,
    );
    if (result == null || !mounted || _order == null) {
      return;
    }

    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      final partId = const Uuid().v4();
      final part = Part(
        id: partId,
        title: result.title,
        normalizedTitle: TextNormalizer.normalize(result.title),
        serviceCategoryId: _category?.id,
        brand: result.brandOrNote,
        usageCount: 0,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );
      await ref.read(partRepositoryProvider).upsert(part);

      final repairPart = RepairPart(
        id: const Uuid().v4(),
        repairOrderId: widget.repairId,
        partId: partId,
        partTitleSnapshot: result.title,
        brandSnapshot: result.brandOrNote,
        quantity: 1,
        unitPrice: result.unitPrice,
        suppliedBy: PartSuppliedBy.workshop,
        createdAt: now,
      );
      await ref.read(repairOrderRepositoryProvider).addPart(repairPart);
      await _reloadSelected();
      await _refreshSuggestions();
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _updateSelected(RepairPart part) async {
    await ref.read(repairOrderRepositoryProvider).updatePart(part);
    await _reloadSelected();
  }

  Future<void> _removeSelected(String id) async {
    _priceQueue.removeWhere((item) => item == id);
    _pendingLastPrices.remove(id);
    await ref.read(repairOrderRepositoryProvider).removePart(id);
    await _reloadSelected();
  }

  Future<void> _editSelectedPrice(RepairPart part) async {
    if (_differentPrices.contains(part.id) && part.quantity > 1) {
      await _collectDifferentUnitPrices(part);
      return;
    }
    int? lastPrice;
    if (part.partId != null) {
      final catalog =
          await ref.read(partRepositoryProvider).getById(part.partId!);
      if (catalog != null) {
        lastPrice = await ref.read(partRepositoryProvider).getLatestPrice(
              normalizedTitle: catalog.normalizedTitle,
              vehicleModel: _vehicle?.model,
            );
      }
    }
    lastPrice ??= await ref.read(partRepositoryProvider).getLatestPrice(
          normalizedTitle: TextNormalizer.normalize(part.partTitleSnapshot),
          vehicleModel: _vehicle?.model,
        );
    if (!mounted) {
      return;
    }
    final result = await showPartPriceSheet(
      context: context,
      partTitle: part.partTitleSnapshot,
      vehicleModel: _vehicleTitle,
      lastPrice: lastPrice,
      initialUnitPrice: part.unitPrice,
    );
    if (result == null || !mounted) {
      return;
    }
    await _updateSelected(part.copyWith(unitPrice: result.unitPrice));
  }

  Future<void> _setDifferentPrices(RepairPart part, bool enabled) async {
    setState(() {
      if (enabled) {
        _differentPrices.add(part.id);
      } else {
        _differentPrices.remove(part.id);
      }
    });
    if (enabled && part.quantity > 1) {
      await _collectDifferentUnitPrices(part);
    }
  }

  Future<void> _collectDifferentUnitPrices(RepairPart part) async {
    final prices = <int>[];
    for (var i = 0; i < part.quantity; i++) {
      if (!mounted) {
        return;
      }
      final result = await showPartPriceSheet(
        context: context,
        partTitle:
            '${part.partTitleSnapshot} (${PersianDigitFormatter.intToPersian(i + 1)} از ${PersianDigitFormatter.intToPersian(part.quantity)})',
        vehicleModel: _vehicleTitle,
        initialUnitPrice: part.unitPrice > 0 ? part.unitPrice : 0,
      );
      if (result == null) {
        return;
      }
      prices.add(result.unitPrice);
    }

    final repo = ref.read(repairOrderRepositoryProvider);
    await repo.removePart(part.id);
    _differentPrices.remove(part.id);
    for (final price in prices) {
      await repo.addPart(
        RepairPart(
          id: const Uuid().v4(),
          repairOrderId: part.repairOrderId,
          partId: part.partId,
          partTitleSnapshot: part.partTitleSnapshot,
          brandSnapshot: part.brandSnapshot,
          quantity: 1,
          unitPrice: price,
          suppliedBy: part.suppliedBy,
          createdAt: DateTime.now(),
        ),
      );
    }
    await _reloadSelected();
  }

  Future<void> _increaseQty(RepairPart part) async {
    final next = part.copyWith(quantity: part.quantity + 1);
    await _updateSelected(next);
    if (_differentPrices.contains(part.id) && next.quantity > 1) {
      final updated = _selected.firstWhere(
        (item) => item.id == part.id,
        orElse: () => next,
      );
      await _collectDifferentUnitPrices(updated);
    }
  }

  Future<void> _editBrand(RepairPart part) async {
    final controller = TextEditingController(text: part.brandSnapshot ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('برند یا توضیح'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'اختیاری',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('انصراف'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('ذخیره'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result == null || !mounted) {
      return;
    }
    final trimmed = result.trim();
    await _updateSelected(
      part.copyWith(
        brandSnapshot: trimmed,
        clearBrandSnapshot: trimmed.isEmpty,
      ),
    );
  }

  String get _vehicleTitle {
    final vehicle = _vehicle;
    if (vehicle == null) {
      return '—';
    }
    final parts = [
      if (vehicle.manufacturer != null && vehicle.manufacturer!.isNotEmpty)
        vehicle.manufacturer!,
      if (vehicle.model != null && vehicle.model!.isNotEmpty) vehicle.model!,
    ];
    return parts.isEmpty ? 'خودرو' : parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppPageAppBar(title: 'ثبت قطعات'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorText != null
              ? Center(child: Text(_errorText!))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                          _HeaderCard(
                            model: _vehicleTitle,
                            plateDisplay: _vehicle?.plateDisplay ?? '—',
                            plateNormalized: _vehicle?.plateNormalized,
                            category: _category?.title ?? '—',
                          ),
                          if (_selected.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Text(
                              'قطعات انتخاب‌شده',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final part in _selected) ...[
                              _SelectedPartTile(
                                part: part,
                                differentPrices:
                                    _differentPrices.contains(part.id),
                                onEditPrice: () => _editSelectedPrice(part),
                                onIncreaseQty: () => _increaseQty(part),
                                onDecreaseQty: part.quantity <= 1
                                    ? null
                                    : () => _updateSelected(
                                          part.copyWith(
                                            quantity: part.quantity - 1,
                                          ),
                                        ),
                                onCustomerSuppliedChanged: (byCustomer) =>
                                    _updateSelected(
                                  part.copyWith(
                                    suppliedBy: byCustomer
                                        ? PartSuppliedBy.customer
                                        : PartSuppliedBy.workshop,
                                  ),
                                ),
                                onDifferentPricesChanged: (enabled) =>
                                    _setDifferentPrices(part, enabled),
                                onEditBrand: () => _editBrand(part),
                                onRemove: () => _removeSelected(part.id),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                          const SizedBox(height: 16),
                          _SectionTitle(
                            title: _category == null
                                ? 'قطعات پرکاربرد'
                                : 'قطعات پرکاربرد ${_category!.title}',
                          ),
                          const SizedBox(height: 8),
                          if (_categoryParts.isEmpty)
                            Text(
                              'قطعه‌ای برای این دسته ثبت نشده.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          else
                            _PartButtonList(
                              parts: _categoryParts,
                              onTap: _onPartTapped,
                            ),
                          if (_hasMoreCategory)
                            TextButton(
                              onPressed: _browseCategory,
                              child: const Text('مشاهده همه'),
                            ),
                          const SizedBox(height: 16),
                          const _SectionTitle(title: 'قطعات پرتکرار این تعمیرگاه'),
                          const SizedBox(height: 8),
                          if (_workshopParts.isEmpty)
                            Text(
                              'هنوز قطعه پرتکراری ثبت نشده.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          else
                            _PartButtonList(
                              parts: _workshopParts,
                              onTap: _onPartTapped,
                            ),
                          if (_hasMoreWorkshop)
                            TextButton(
                              onPressed: _browseWorkshop,
                              child: const Text('مشاهده همه'),
                            ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _searchController,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'جستجوی قطعه',
                              prefixIcon: const Icon(Icons.search, size: 20),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: _onSearchChanged,
                          ),
                          if (_searchResults.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _PartButtonList(
                              parts: _searchResults,
                              onTap: _onPartTapped,
                            ),
                          ],
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: _busy ? null : _addNewPart,
                            icon: const Icon(Icons.add),
                            label: const Text('افزودن قطعه جدید'),
                          ),
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Column(
                          children: [
                            FilledButton(
                              onPressed: _busy
                                  ? null
                                  : () => context.push(
                                        '/repair/${widget.repairId}/summary',
                                      ),
                              child: Text(
                                _selected.isEmpty
                                    ? 'ادامه بدون قطعه'
                                    : 'ادامه (${PersianDigitFormatter.toPersian('${_selected.length}')} قطعه)',
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: _busy
                                  ? null
                                  : () {
                                      // تغییرات از قبل ذخیره شده‌اند؛ فقط نگه دار و برو.
                                      context.go('/');
                                    },
                              icon: const Icon(Icons.pause_circle_outline),
                              label: const Text('نگه داشتن و رفتن به خانه'),
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.model,
    required this.plateDisplay,
    this.plateNormalized,
    required this.category,
  });

  final String model;
  final String plateDisplay;
  final String? plateNormalized;
  final String category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              model,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            PlateDisplayLtr(
              plateDisplay: plateDisplay,
              plateNormalized: plateNormalized,
              style: theme.textTheme.titleMedium,
              compact: true,
            ),
            const SizedBox(height: 6),
            Text(
              category,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _PartButtonList extends StatelessWidget {
  const _PartButtonList({
    required this.parts,
    required this.onTap,
  });

  final List<Part> parts;
  final ValueChanged<Part> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (context, index) {
        final part = parts[index];
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => onTap(part),
          child: Text(
            part.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}

class _SelectedPartTile extends StatelessWidget {
  const _SelectedPartTile({
    required this.part,
    required this.differentPrices,
    required this.onEditPrice,
    required this.onIncreaseQty,
    required this.onDecreaseQty,
    required this.onCustomerSuppliedChanged,
    required this.onDifferentPricesChanged,
    required this.onEditBrand,
    required this.onRemove,
  });

  final RepairPart part;
  final bool differentPrices;
  final VoidCallback onEditPrice;
  final VoidCallback onIncreaseQty;
  final VoidCallback? onDecreaseQty;
  final ValueChanged<bool> onCustomerSuppliedChanged;
  final ValueChanged<bool> onDifferentPricesChanged;
  final VoidCallback onEditBrand;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final byCustomer = part.suppliedBy == PartSuppliedBy.customer;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    part.partTitleSnapshot,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _QtyStepper(
                  quantity: part.quantity,
                  onDecrease: onDecreaseQty,
                  onIncrease: onIncreaseQty,
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'حذف',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (part.brandSnapshot != null &&
                part.brandSnapshot!.isNotEmpty) ...[
              Text(
                part.brandSnapshot!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
            ],
            SizedBox(
              height: AppTapTargets.large,
              child: OutlinedButton(
                onPressed: onEditPrice,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    part.unitPrice <= 0
                        ? 'ورود قیمت'
                        : MoneyFormatter.format(part.unitPrice),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            if (part.quantity > 1)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
                value: differentPrices,
                onChanged: (value) =>
                    onDifferentPricesChanged(value ?? false),
                title: Text(
                  'قیمت‌ها متفاوت',
                  style: theme.textTheme.bodyMedium,
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            Row(
              children: [
                SizedBox(
                  height: 36,
                  width: 36,
                  child: Checkbox(
                    value: byCustomer,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) =>
                        onCustomerSuppliedChanged(value ?? false),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onCustomerSuppliedChanged(!byCustomer),
                    child: Text(
                      'آورده مشتری',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: onEditBrand,
              child: Text(
                part.brandSnapshot == null || part.brandSnapshot!.isEmpty
                    ? 'افزودن برند یا توضیح'
                    : 'ویرایش برند یا توضیح',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback? onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onDecrease,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(10),
              ),
              child: const SizedBox(
                width: 32,
                height: 36,
                child: Icon(Icons.remove_rounded, size: 18),
              ),
            ),
            SizedBox(
              width: 28,
              child: Text(
                PersianDigitFormatter.toPersian('$quantity'),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            InkWell(
              onTap: onIncrease,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
              ),
              child: const SizedBox(
                width: 32,
                height: 36,
                child: Icon(Icons.add_rounded, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
