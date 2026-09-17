export 'iranian_plate_widget.dart';

import 'package:flutter/material.dart';

import 'iranian_plate_widget.dart';
import 'numeric_keypad.dart';
import 'plate_letter_picker_sheet.dart';

/// ورودی پلاک ایرانی با چیدمان LTR ثابت.
class IranianPlateInput extends StatefulWidget {
  const IranianPlateInput({
    super.key,
    this.initialValue = const IranianPlateValue(),
    this.onChanged,
  });

  final IranianPlateValue initialValue;
  final ValueChanged<IranianPlateValue>? onChanged;

  @override
  State<IranianPlateInput> createState() => IranianPlateInputState();
}

class IranianPlateInputState extends State<IranianPlateInput> {
  late IranianPlateValue _value;

  IranianPlateValue get value => _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _emit(IranianPlateValue next) {
    setState(() => _value = next);
    widget.onChanged?.call(next);
  }

  Future<void> _editDigits({
    required String title,
    required int maxLength,
    required String current,
    required void Function(String digits) apply,
  }) async {
    final result = await showNumericKeypadSheet(
      context: context,
      title: title,
      maxLength: maxLength,
      initialValue: current,
    );
    if (result == null || !mounted) {
      return;
    }
    apply(result);
  }

  Future<void> _editLetter() async {
    final result = await showPlateLetterPickerSheet(
      context: context,
      selectedLetter: _value.letter.isEmpty ? null : _value.letter,
    );
    if (result == null || !mounted) {
      return;
    }
    _emit(_value.copyWith(letter: result));
  }

  @override
  Widget build(BuildContext context) {
    return IranianPlateWidget(
      value: _value,
      onFirstTwoDigitsTap: () => _editDigits(
        title: 'عدد دو رقمی (سمت چپ)',
        maxLength: 2,
        current: _value.firstTwoDigits,
        apply: (digits) => _emit(_value.copyWith(firstTwoDigits: digits)),
      ),
      onLetterTap: _editLetter,
      onMiddleThreeDigitsTap: () => _editDigits(
        title: 'عدد سه‌رقمی',
        maxLength: 3,
        current: _value.middleThreeDigits,
        apply: (digits) => _emit(_value.copyWith(middleThreeDigits: digits)),
      ),
      onCityCodeTap: () => _editDigits(
        title: 'کد شهر (۲ رقم)',
        maxLength: 2,
        current: _value.cityCode,
        apply: (digits) => _emit(_value.copyWith(cityCode: digits)),
      ),
    );
  }
}
