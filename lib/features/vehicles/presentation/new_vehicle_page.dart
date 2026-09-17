import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/formatters/phone_normalizer.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../data/providers.dart';
import '../domain/entities/customer.dart';
import '../domain/entities/new_vehicle_plate_args.dart';
import '../domain/entities/vehicle.dart';
import '../domain/vehicle_model_catalog.dart';
import 'widgets/other_vehicle_model_sheet.dart';

export '../domain/vehicle_model_catalog.dart' show popularVehicleModels;

class NewVehiclePage extends ConsumerStatefulWidget {
  const NewVehiclePage({
    super.key,
    required this.args,
  });

  final NewVehiclePlateArgs args;

  @override
  ConsumerState<NewVehiclePage> createState() => _NewVehiclePageState();
}

class _NewVehiclePageState extends ConsumerState<NewVehiclePage> {
  String? _selectedModel;
  bool _showCustomModelField = false;
  final _customModelController = TextEditingController();
  final _customModelFocus = FocusNode();
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _mileageDigits = '';
  String? _errorText;
  bool _isSaving = false;

  @override
  void dispose() {
    _customModelController.dispose();
    _customModelFocus.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? get _resolvedModel {
    if (_selectedModel == null) {
      return null;
    }
    if (_selectedModel == 'سایر') {
      final custom = _customModelController.text.trim();
      return custom.isEmpty ? null : custom;
    }
    return _selectedModel;
  }

  bool get _isOtherSelected =>
      _selectedModel == 'سایر' ||
      (_selectedModel != null &&
          !popularVehicleModels.contains(_selectedModel));

  Future<void> _onModelChipTap(String model) async {
    if (model == 'سایر') {
      await _openOtherModels();
      return;
    }
    setState(() {
      _selectedModel = model;
      _showCustomModelField = false;
      _customModelController.clear();
      _errorText = null;
    });
  }

  Future<void> _openOtherModels() async {
    final currentCustom = _customModelController.text.trim();
    final current = (_selectedModel != null &&
            _selectedModel != 'سایر' &&
            !popularVehicleModels.contains(_selectedModel))
        ? _selectedModel
        : (currentCustom.isEmpty ? null : currentCustom);

    final pick = await showOtherVehicleModelSheet(
      context: context,
      currentModel: current,
    );
    if (pick == null || !mounted) {
      return;
    }

    switch (pick) {
      case OtherVehicleModelNamed(:final model):
        setState(() {
          _selectedModel = model;
          _showCustomModelField = false;
          _customModelController.text = model;
          _errorText = null;
        });
      case OtherVehicleModelCustom():
        setState(() {
          _selectedModel = 'سایر';
          _showCustomModelField = true;
          _errorText = null;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _customModelFocus.requestFocus();
          }
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

  Future<void> _save() async {
    final model = _resolvedModel;
    if (model == null) {
      setState(() => _errorText = 'مدل خودرو را انتخاب کنید.');
      return;
    }

    final phoneRaw = _phoneController.text.trim();
    String? phone;
    if (phoneRaw.isNotEmpty) {
      phone = PhoneNormalizer.normalize(phoneRaw);
      if (phone == null) {
        setState(() => _errorText = 'شماره موبایل معتبر نیست.');
        return;
      }
    }

    setState(() {
      _errorText = null;
      _isSaving = true;
    });

    try {
      final now = DateTime.now();
      final vehicles = ref.read(vehicleRepositoryProvider);
      final customers = ref.read(customerRepositoryProvider);

      String? customerId;
      final customerName = _customerNameController.text.trim();
      if (customerName.isNotEmpty || phone != null) {
        customerId = const Uuid().v4();
        await customers.upsert(
          Customer(
            id: customerId,
            fullName: customerName.isEmpty ? null : customerName,
            phone: phone,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      final mileage = _mileageDigits.isEmpty ? null : int.parse(_mileageDigits);
      final vehicle = Vehicle(
        id: const Uuid().v4(),
        customerId: customerId,
        plateNormalized: widget.args.plateNormalized,
        plateDisplay: widget.args.plateDisplay,
        model: model,
        lastMileage: mileage,
        createdAt: now,
        updatedAt: now,
      );
      await vehicles.upsert(vehicle);

      if (!mounted) {
        return;
      }
      context.go('/vehicle/${vehicle.id}?fromScan=1');
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
        _errorText = 'ذخیره خودرو با خطا مواجه شد.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOtherLabel = _isOtherSelected
        ? (_selectedModel == 'سایر'
            ? _customModelController.text.trim()
            : _selectedModel)
        : null;

    return Scaffold(
      appBar: const AppPageAppBar(title: 'خودرو جدید'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Text(
              'پلاک',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 6),
            PlateDisplayLtr(
              plateDisplay: widget.args.plateDisplay,
              plateNormalized: widget.args.plateNormalized,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text('مدل خودرو', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final model in popularVehicleModels)
                  SizedBox(
                    height: AppTapTargets.large,
                    child: OutlinedButton(
                      onPressed: () => _onModelChipTap(model),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            (model == 'سایر' ? _isOtherSelected : _selectedModel == model)
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                        foregroundColor:
                            (model == 'سایر' ? _isOtherSelected : _selectedModel == model)
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                        side: BorderSide(
                          color:
                              (model == 'سایر' ? _isOtherSelected : _selectedModel == model)
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                          width:
                              (model == 'سایر' ? _isOtherSelected : _selectedModel == model)
                                  ? 2
                                  : 1,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, AppTapTargets.large),
                      ),
                      child: Text(
                        model,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color:
                              (model == 'سایر' ? _isOtherSelected : _selectedModel == model)
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (_isOtherSelected &&
                selectedOtherLabel != null &&
                selectedOtherLabel.isNotEmpty &&
                !_showCustomModelField) ...[
              const SizedBox(height: 12),
              Material(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: Icon(
                    Icons.directions_car_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(selectedOtherLabel),
                  subtitle: const Text('برای تغییر، دوباره «سایر» را بزنید'),
                  trailing: IconButton(
                    tooltip: 'تغییر',
                    onPressed: _openOtherModels,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ),
              ),
            ],
            if (_showCustomModelField) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _customModelController,
                focusNode: _customModelFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'نام مدل',
                  hintText: 'مثلاً ال۹۰',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _customerNameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'نام مشتری (اختیاری)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'شماره موبایل (اختیاری)',
                hintText: '۰۹۱۲۳۴۵۶۷۸۹',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: AppTapTargets.large,
              child: OutlinedButton(
                onPressed: _editMileage,
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _mileageDigits.isEmpty
                            ? 'کارکرد فعلی (اختیاری)'
                            : '${PersianDigitFormatter.toPersian(_mileageDigits)} کیلومتر',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    const Icon(Icons.dialpad_outlined),
                  ],
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
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Text('ثبت خودرو'),
            ),
          ],
        ),
      ),
    );
  }
}
