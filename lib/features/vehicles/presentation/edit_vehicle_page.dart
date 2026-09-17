import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/formatters/persian_digit_formatter.dart';
import '../../../core/widgets/iranian_plate_widget.dart';
import '../../../core/formatters/phone_normalizer.dart';
import '../../../core/theme_constants.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../data/providers.dart';
import '../domain/entities/customer.dart';
import '../domain/entities/vehicle.dart';
import '../domain/vehicle_model_catalog.dart';
import 'widgets/other_vehicle_model_sheet.dart';

class EditVehiclePage extends ConsumerStatefulWidget {
  const EditVehiclePage({
    super.key,
    required this.vehicleId,
  });

  final String vehicleId;

  @override
  ConsumerState<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends ConsumerState<EditVehiclePage> {
  bool _loading = true;
  bool _saving = false;
  String? _errorText;
  Vehicle? _vehicle;
  Customer? _customer;

  String? _selectedModel;
  bool _showCustomModelField = false;
  final _customModelController = TextEditingController();
  final _customModelFocus = FocusNode();
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _mileageDigits = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _customModelController.dispose();
    _customModelFocus.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final profile = await ref
        .read(vehicleProfileRepositoryProvider)
        .getByVehicleId(widget.vehicleId);
    if (!mounted) {
      return;
    }
    if (profile == null) {
      setState(() {
        _loading = false;
        _errorText = 'خودرو پیدا نشد.';
      });
      return;
    }

    final model = profile.vehicle.model;
    final isPopular = model != null &&
        popularVehicleModels.contains(model) &&
        model != 'سایر';
    _vehicle = profile.vehicle;
    _customer = profile.customer;
    if (isPopular) {
      _selectedModel = model;
      _showCustomModelField = false;
    } else if (model != null) {
      _selectedModel = model;
      _customModelController.text = model;
      _showCustomModelField = false;
    } else {
      _selectedModel = null;
    }
    _customerNameController.text = profile.customer?.fullName ?? '';
    _phoneController.text = profile.customer?.phone ?? '';
    _mileageDigits = profile.vehicle.lastMileage?.toString() ?? '';
    setState(() => _loading = false);
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
    if (model == null || _vehicle == null) {
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
      _saving = true;
    });

    try {
      final now = DateTime.now();
      final customers = ref.read(customerRepositoryProvider);
      final vehicles = ref.read(vehicleRepositoryProvider);

      var customerId = _vehicle!.customerId;
      final customerName = _customerNameController.text.trim();
      if (customerName.isNotEmpty || phone != null) {
        customerId ??= const Uuid().v4();
        await customers.upsert(
          Customer(
            id: customerId,
            fullName: customerName.isEmpty ? null : customerName,
            phone: phone,
            createdAt: _customer?.createdAt ?? now,
            updatedAt: now,
          ),
        );
      }

      final mileage = _mileageDigits.isEmpty ? null : int.parse(_mileageDigits);
      await vehicles.upsert(
        Vehicle(
          id: _vehicle!.id,
          customerId: customerId,
          plateNormalized: _vehicle!.plateNormalized,
          plateDisplay: _vehicle!.plateDisplay,
          manufacturer: _vehicle!.manufacturer,
          model: model,
          trim: _vehicle!.trim,
          productionYear: _vehicle!.productionYear,
          lastMileage: mileage,
          createdAt: _vehicle!.createdAt,
          updatedAt: now,
        ),
      );

      ref.invalidate(vehicleProfileProvider(widget.vehicleId));
      if (!mounted) {
        return;
      }
      context.pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _errorText = 'ذخیره تغییرات با خطا مواجه شد.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppPageAppBar(title: 'ویرایش اطلاعات'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                children: [
                  if (_vehicle != null) ...[
                    PlateDisplayLtr(
                      plateDisplay: _vehicle!.plateDisplay,
                      plateNormalized: _vehicle!.plateNormalized,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                  ],
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
                              backgroundColor: (model == 'سایر'
                                      ? _isOtherSelected
                                      : _selectedModel == model)
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surface,
                              foregroundColor: (model == 'سایر'
                                      ? _isOtherSelected
                                      : _selectedModel == model)
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              side: BorderSide(
                                color: (model == 'سایر'
                                        ? _isOtherSelected
                                        : _selectedModel == model)
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                              ),
                              minimumSize:
                                  const Size(0, AppTapTargets.large),
                            ),
                            child: Text(model),
                          ),
                        ),
                    ],
                  ),
                  if (_isOtherSelected &&
                      !_showCustomModelField &&
                      (_selectedModel != null &&
                          _selectedModel != 'سایر')) ...[
                    const SizedBox(height: 12),
                    Material(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: Icon(
                          Icons.directions_car_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(_selectedModel!),
                        subtitle:
                            const Text('برای تغییر، دوباره «سایر» را بزنید'),
                        trailing: IconButton(
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
                      decoration: const InputDecoration(labelText: 'نام مدل'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'نام مشتری (اختیاری)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'شماره موبایل (اختیاری)',
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
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Text('ذخیره تغییرات'),
                  ),
                ],
              ),
            ),
    );
  }
}
