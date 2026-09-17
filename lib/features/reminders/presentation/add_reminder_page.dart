import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/enums.dart';
import '../../../core/formatters/jalali_date_formatter.dart';
import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/jalali_date_picker.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../../repair_orders/data/providers.dart';
import '../../vehicles/data/providers.dart';
import '../data/providers.dart';
import '../domain/entities/reminder.dart';
import '../domain/reminder_presets.dart';

/// افزودن یادآوری سرویس پس از تعمیر (یا به‌صورت مستقل با vehicleId).
class AddReminderPage extends ConsumerStatefulWidget {
  const AddReminderPage({
    super.key,
    this.repairId,
    this.vehicleId,
  });

  final String? repairId;
  final String? vehicleId;

  @override
  ConsumerState<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends ConsumerState<AddReminderPage> {
  String? _vehicleId;
  String? _repairOrderId;
  int? _currentMileage;
  String _vehicleLabel = '';
  bool _loading = true;
  bool _saving = false;
  String? _errorText;

  final _titleController = TextEditingController();
  ReminderDueKind _dueKind = ReminderDueKind.date;
  DateTime? _dueDate;
  String _mileageDigits = '';
  String _intervalDaysDigits = '';
  String _intervalMileageDigits = '';
  ReminderPreset? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      String? vehicleId = widget.vehicleId;
      String? repairId = widget.repairId;
      int? mileage;
      var label = '';

      if (repairId != null && repairId.isNotEmpty) {
        final order =
            await ref.read(repairOrderRepositoryProvider).getById(repairId);
        if (order != null) {
          vehicleId = order.vehicleId;
          repairId = order.id;
          mileage = order.mileage;
        }
      }

      if (vehicleId != null) {
        final vehicle =
            await ref.read(vehicleRepositoryProvider).getById(vehicleId);
        if (vehicle != null) {
          mileage ??= vehicle.lastMileage;
          final parts = [
            if (vehicle.manufacturer != null &&
                vehicle.manufacturer!.isNotEmpty)
              vehicle.manufacturer!,
            if (vehicle.model != null && vehicle.model!.isNotEmpty)
              vehicle.model!,
          ];
          label = parts.isEmpty ? vehicle.plateDisplay : parts.join(' ');
        }
      }

      if (!mounted) {
        return;
      }
      if (vehicleId == null) {
        setState(() {
          _loading = false;
          _errorText = 'خودرو برای یادآوری پیدا نشد.';
        });
        return;
      }
      setState(() {
        _vehicleId = vehicleId;
        _repairOrderId = repairId;
        _currentMileage = mileage;
        _vehicleLabel = label;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _errorText = 'خطا در بارگذاری اطلاعات یادآوری.';
      });
    }
  }

  void _applyPreset(ReminderPreset preset) {
    setState(() {
      _selectedPreset = preset;
      _titleController.text = preset.title;
      _dueKind = preset.dueKind;
      _errorText = null;

      final now = DateTime.now();
      if (preset.monthsLater != null &&
          (preset.dueKind == ReminderDueKind.date ||
              preset.dueKind == ReminderDueKind.both)) {
        _dueDate = ReminderPresets.addMonths(now, preset.monthsLater!);
      } else if (preset.dueKind == ReminderDueKind.date) {
        _dueDate = null;
      }

      if (preset.kmLater != null &&
          (preset.dueKind == ReminderDueKind.mileage ||
              preset.dueKind == ReminderDueKind.both)) {
        final base = _currentMileage ?? 0;
        _mileageDigits = (base + preset.kmLater!).toString();
      } else if (preset.dueKind == ReminderDueKind.mileage) {
        _mileageDigits = '';
      }
    });
  }

  Future<void> _pickDate() async {
    final initial = _dueDate ?? DateTime.now().add(const Duration(days: 30));
    final picked = await showJalaliDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      helpText: 'تاریخ یادآوری',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() => _dueDate = picked);
  }

  Future<void> _editMileage() async {
    final result = await showNumericKeypadSheet(
      context: context,
      title: 'کیلومتر سررسید',
      maxLength: 7,
      initialValue: _mileageDigits,
    );
    if (result == null || !mounted) {
      return;
    }
    setState(() => _mileageDigits = result);
  }

  Future<void> _editInterval({
    required String title,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) async {
    final result = await showNumericKeypadSheet(
      context: context,
      title: title,
      maxLength: 7,
      initialValue: initialValue,
    );
    if (result == null || !mounted) return;
    setState(() => onChanged(result));
  }

  Future<void> _save() async {
    final vehicleId = _vehicleId;
    if (vehicleId == null || _saving) {
      return;
    }
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = 'عنوان سرویس را وارد کنید.');
      return;
    }

    DateTime? dueDate;
    int? dueMileage;
    switch (_dueKind) {
      case ReminderDueKind.date:
        dueDate = _dueDate;
        if (dueDate == null) {
          setState(() => _errorText = 'تاریخ یادآوری را انتخاب کنید.');
          return;
        }
      case ReminderDueKind.mileage:
        if (_mileageDigits.isEmpty) {
          setState(() => _errorText = 'کیلومتر سررسید را وارد کنید.');
          return;
        }
        dueMileage = int.parse(_mileageDigits);
      case ReminderDueKind.both:
        dueDate = _dueDate;
        if (_mileageDigits.isNotEmpty) {
          dueMileage = int.parse(_mileageDigits);
        }
        if (dueDate == null && dueMileage == null) {
          setState(() => _errorText = 'حداقل تاریخ یا کیلومتر را مشخص کنید.');
          return;
        }
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });

    try {
      final reminder = Reminder(
        id: const Uuid().v4(),
        vehicleId: vehicleId,
        repairOrderId: _repairOrderId,
        title: title,
        dueDate: dueDate,
        dueMileage: dueMileage,
        status: ReminderStatus.pending,
        createdAt: DateTime.now(),
        intervalDays: _intervalDaysDigits.isEmpty
            ? null
            : int.parse(_intervalDaysDigits),
        intervalMileage: _intervalMileageDigits.isEmpty
            ? null
            : int.parse(_intervalMileageDigits),
      );
      await ref.read(reminderRepositoryProvider).upsert(reminder);
      await ref.read(reminderNotificationServiceProvider).scheduleReminder(reminder);
      ref.invalidate(reminderDashboardProvider);
      if (!mounted) {
        return;
      }
      if (context.canPop()) {
        context.pop(true);
      } else {
        context.go('/reminders');
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _errorText = 'ذخیره یادآوری با خطا مواجه شد.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppPageAppBar(title: 'یادآوری سرویس'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_vehicleLabel.isNotEmpty)
                          Text(
                            _vehicleLabel,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (_currentMileage != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'کارکرد فعلی: ${PersianDigitFormatter.toPersian('$_currentMileage')} کیلومتر',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Text(
                          'پیشنهاد سریع',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final preset in ReminderPresets.all)
                              FilterChip(
                                selected: _selectedPreset?.id == preset.id,
                                label: Text(preset.title),
                                onSelected: (_) => _applyPreset(preset),
                              ),
                          ],
                        ),
                        if (_selectedPreset?.hint != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _selectedPreset!.hint!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'عنوان سرویس',
                          ),
                          onChanged: (_) {
                            if (_errorText != null) {
                              setState(() => _errorText = null);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'نوع یادآوری',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<ReminderDueKind>(
                          segments: const [
                            ButtonSegment(
                              value: ReminderDueKind.date,
                              label: Text('تاریخ'),
                            ),
                            ButtonSegment(
                              value: ReminderDueKind.mileage,
                              label: Text('کیلومتر'),
                            ),
                            ButtonSegment(
                              value: ReminderDueKind.both,
                              label: Text('هر دو'),
                            ),
                          ],
                          selected: {_dueKind},
                          onSelectionChanged: (values) {
                            if (values.isEmpty) {
                              return;
                            }
                            setState(() => _dueKind = values.first);
                          },
                        ),
                        if (_dueKind == ReminderDueKind.date ||
                            _dueKind == ReminderDueKind.both) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            height: AppTapTargets.priceKeypad,
                            child: OutlinedButton(
                              onPressed: _pickDate,
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  _dueDate == null
                                      ? 'انتخاب تاریخ'
                                      : JalaliDateFormatter.formatLong(_dueDate!),
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (_dueKind == ReminderDueKind.mileage ||
                            _dueKind == ReminderDueKind.both) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: AppTapTargets.priceKeypad,
                            child: OutlinedButton(
                              onPressed: _editMileage,
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  _mileageDigits.isEmpty
                                      ? 'ورود کیلومتر سررسید'
                                      : '${PersianDigitFormatter.toPersian(_mileageDigits)} کیلومتر',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        Text(
                          'تکرار دوره‌ای (اختیاری)',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: AppTapTargets.priceKeypad,
                          child: OutlinedButton(
                            onPressed: () => _editInterval(
                              title: 'فاصله تکرار (روز)',
                              initialValue: _intervalDaysDigits,
                              onChanged: (value) => _intervalDaysDigits = value,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _intervalDaysDigits.isEmpty
                                    ? 'فاصله تکرار به روز'
                                    : 'هر ${PersianDigitFormatter.toPersian(_intervalDaysDigits)} روز',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: AppTapTargets.priceKeypad,
                          child: OutlinedButton(
                            onPressed: () => _editInterval(
                              title: 'فاصله تکرار (کیلومتر)',
                              initialValue: _intervalMileageDigits,
                              onChanged: (value) =>
                                  _intervalMileageDigits = value,
                            ),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _intervalMileageDigits.isEmpty
                                    ? 'فاصله تکرار به کیلومتر'
                                    : 'هر ${PersianDigitFormatter.toPersian(_intervalMileageDigits)} کیلومتر',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ),
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
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      height: AppTapTargets.priceKeypad,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('ذخیره یادآوری'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
