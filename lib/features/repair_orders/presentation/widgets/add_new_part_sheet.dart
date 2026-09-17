import 'package:flutter/material.dart';

import '../../../../core/formatters/money_formatter.dart';
import '../../../../core/theme_constants.dart';
import '../../../../core/widgets/price_keypad_bottom_sheet.dart';

class AddNewPartResult {
  const AddNewPartResult({
    required this.title,
    this.brandOrNote,
    required this.unitPrice,
  });

  final String title;
  final String? brandOrNote;
  final int unitPrice;
}

Future<AddNewPartResult?> showAddNewPartSheet({
  required BuildContext context,
  String? vehicleModel,
}) {
  return showModalBottomSheet<AddNewPartResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _AddNewPartSheet(vehicleModel: vehicleModel),
  );
}

class _AddNewPartSheet extends StatefulWidget {
  const _AddNewPartSheet({this.vehicleModel});

  final String? vehicleModel;

  @override
  State<_AddNewPartSheet> createState() => _AddNewPartSheetState();
}

class _AddNewPartSheetState extends State<_AddNewPartSheet> {
  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  int _unitPrice = 0;
  String? _errorText;

  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  Future<void> _editPrice() async {
    final title = _titleController.text.trim();
    final amount = await showPriceKeypadBottomSheet(
      context: context,
      partTitle: title.isEmpty ? 'قطعه جدید' : title,
      vehicleModel: widget.vehicleModel,
      initialAmount: _unitPrice > 0 ? _unitPrice : null,
    );
    if (amount == null || !mounted) {
      return;
    }
    setState(() {
      _unitPrice = amount;
      _errorText = null;
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _errorText = 'نام قطعه را وارد کنید.');
      return;
    }
    if (_unitPrice <= 0) {
      setState(() => _errorText = 'قیمت قطعه را وارد کنید.');
      return;
    }
    final brand = _brandController.text.trim();
    Navigator.of(context).pop(
      AddNewPartResult(
        title: title,
        brandOrNote: brand.isEmpty ? null : brand,
        unitPrice: _unitPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'افزودن قطعه جدید',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'نام قطعه',
                hintText: 'مثلاً لنت جلو',
              ),
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _brandController,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'برند یا توضیح (اختیاری)',
              ),
            ),
            const SizedBox(height: 12),
            Text('قیمت', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SizedBox(
              height: AppTapTargets.priceKeypad,
              child: OutlinedButton(
                onPressed: _editPrice,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _unitPrice <= 0
                        ? 'ورود قیمت'
                        : MoneyFormatter.format(_unitPrice),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: const Text('ذخیره و افزودن'),
            ),
          ],
        ),
      ),
    );
  }
}
