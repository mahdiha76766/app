import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/enums.dart';
import '../../../core/errors/not_implemented_exception.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../../parts/data/providers.dart';
import '../../parts/domain/entities/service_category.dart';
import '../../reminders/data/services/local_reminder_notification_service.dart';
import '../../vehicles/data/providers.dart';
import '../data/providers.dart';
import '../domain/entities/repair_order.dart';
import '../domain/entities/repair_service.dart';
import '../domain/services/mileage_validator.dart';

/// صفحه پذیرش تعمیر (بعد از ایجاد draft).
class RepairIntakePage extends ConsumerStatefulWidget {
  const RepairIntakePage({
    super.key,
    required this.repairId,
  });

  final String repairId;

  @override
  ConsumerState<RepairIntakePage> createState() => _RepairIntakePageState();
}

class _RepairIntakePageState extends ConsumerState<RepairIntakePage> {
  RepairOrder? _order;
  int? _previousMileage;
  List<ServiceCategory> _categories = const [];
  String? _selectedCategoryId;
  final _complaintController = TextEditingController();
  String _mileageDigits = '';
  bool _loading = true;
  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final order =
          await ref.read(repairOrderRepositoryProvider).getById(widget.repairId);
      final categories =
          await ref.read(serviceCategoryRepositoryProvider).getActiveCategories();
      int? previousMileage;
      String mileageDigits = order?.mileage?.toString() ?? '';
      if (order != null) {
        final vehicle =
            await ref.read(vehicleRepositoryProvider).getById(order.vehicleId);
        previousMileage = vehicle?.lastMileage;
        if (mileageDigits.isEmpty && previousMileage != null) {
          mileageDigits = previousMileage.toString();
        }
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _order = order;
        _categories = categories;
        _previousMileage = previousMileage;
        _mileageDigits = mileageDigits;
        _complaintController.text = order?.complaintText ?? '';
        _loading = false;
        if (order == null) {
          _errorText = 'پذیرش پیدا نشد.';
        }
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorText = 'خطا در بارگذاری پذیرش.';
      });
    }
  }

  Future<void> _editMileage() async {
    final result = await showNumericKeypadSheet(
      context: context,
      title: 'کارکرد فعلی (کیلومتر)',
      maxLength: 7,
      initialValue: _mileageDigits,
    );
    if (result == null || !mounted) {
      return;
    }
    setState(() => _mileageDigits = result);
  }

  Future<void> _onVoiceTap() async {
    final recorder = ref.read(problemVoiceRecorderProvider);
    try {
      await recorder.start();
    } on NotImplementedException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  Future<void> _continue() async {
    final order = _order;
    if (order == null || _saving) {
      return;
    }
    if (_selectedCategoryId == null) {
      setState(() => _errorText = 'دسته خدمت را انتخاب کنید.');
      return;
    }

    final category = _categories.firstWhere(
      (item) => item.id == _selectedCategoryId,
    );

    setState(() {
      _errorText = null;
      _saving = true;
    });

    try {
      final repo = ref.read(repairOrderRepositoryProvider);
      final mileage =
          _mileageDigits.isEmpty ? null : int.parse(_mileageDigits);
      final complaint = _complaintController.text.trim();
      var allowMileageDecrease = false;

      if (mileage != null) {
        final preview = MileageValidator.preview(
          previousMileage: _previousMileage,
          newMileage: mileage,
        );
        if (preview.isDecrease) {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('کاهش کارکرد خودرو'),
              content: Text(
                'کارکرد جدید از آخرین مقدار کمتر است '
                '(${PersianDigitFormatter.intToPersian(_previousMileage!)} کیلومتر). '
                'آیا از ثبت آن مطمئن هستید؟',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('انصراف'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('ثبت کارکرد'),
                ),
              ],
            ),
          );
          if (confirmed != true) {
            if (mounted) setState(() => _saving = false);
            return;
          }
          allowMileageDecrease = true;
        }
      }

      await repo.update(
        order.copyWith(
          mileage: mileage,
          complaintText: complaint.isEmpty ? null : complaint,
          clearComplaintText: complaint.isEmpty,
          clearMileage: mileage == null,
        ),
      );

      if (mileage != null) {
        await repo.recordMileage(
          vehicleId: order.vehicleId,
          mileage: mileage,
          repairOrderId: order.id,
          allowDecrease: allowMileageDecrease,
        );
        try {
          await ref
              .read(localReminderNotificationServiceProvider)
              .checkMileageReminders(
                vehicleId: order.vehicleId,
                currentMileage: mileage,
              );
        } catch (_) {
          // بررسی یادآوری‌ها نباید مانع ادامه پذیرش شود.
        }
      }
      await repo.changeStatus(
        repairOrderId: order.id,
        to: RepairOrderStatus.inRepair,
      );

      final existingServices = await repo.getServices(order.id);
      final hasCategoryService = existingServices.any(
        (item) => item.title == category.title,
      );
      if (!hasCategoryService) {
        await repo.addService(
          RepairService(
            id: const Uuid().v4(),
            repairOrderId: order.id,
            title: category.title,
            amount: 0,
            createdAt: DateTime.now(),
          ),
        );
      }

      if (!mounted) {
        return;
      }
      context.pushReplacement('/repair/${order.id}/parts');
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _errorText = 'ذخیره پذیرش با خطا مواجه شد.';
      });
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppPageAppBar(
        title: 'پذیرش خودرو',
        actions: [
          IconButton(
            tooltip: 'دستیار هوشمند',
            icon: const Icon(Icons.smart_toy_outlined),
            onPressed: () => context.push('/repair/${widget.repairId}/assistant'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  Text('کارکرد فعلی', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Material(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _editMileage,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.45),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.speed_outlined,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _mileageDigits.isEmpty
                                    ? 'کارکرد جدید (کیلومتر)'
                                    : '${PersianDigitFormatter.toPersian(_mileageDigits)} کیلومتر',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: _mileageDigits.isEmpty
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onSurface,
                                  fontWeight: _mileageDigits.isEmpty
                                      ? FontWeight.w500
                                      : FontWeight.w700,
                                ),
                              ),
                            ),
                            if (_previousMileage != null &&
                                _mileageDigits.isNotEmpty &&
                                _mileageDigits != _previousMileage.toString())
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 8,
                                ),
                                child: Text(
                                  'قبل: ${PersianDigitFormatter.intToPersian(_previousMileage!)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('شرح مشکل', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _complaintController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'مثلاً صدای جلوبندی موقع دست‌انداز',
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: AppTapTargets.large,
                    child: OutlinedButton.icon(
                      onPressed: _onVoiceTap,
                      icon: const Icon(Icons.mic_none_outlined),
                      label: const Text('ضبط صدا (به‌زودی)'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('دسته خدمت', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.35,
                    ),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final selected = category.id == _selectedCategoryId;
                      return Material(
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = category.id;
                              _errorText = null;
                            });
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline
                                        .withValues(alpha: 0.5),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _iconFor(category.iconKey),
                                    size: 32,
                                    color: selected
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.title,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: selected
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorText!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _continue,
                    child: _saving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('ادامه'),
                  ),
                ],
              ),
            ),
    );
  }
}
