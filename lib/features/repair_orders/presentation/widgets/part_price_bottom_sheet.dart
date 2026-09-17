import 'package:flutter/material.dart';

import '../../../../core/widgets/price_keypad_bottom_sheet.dart';

/// نتیجه ویرایش قیمت قطعه در bottom sheet.
class PartPriceSheetResult {
  const PartPriceSheetResult({required this.unitPrice});

  final int unitPrice;
}

/// ورود قیمت قطعه با [PriceKeypadBottomSheet].
Future<PartPriceSheetResult?> showPartPriceSheet({
  required BuildContext context,
  required String partTitle,
  String? vehicleModel,
  int? lastPrice,
  int initialUnitPrice = 0,
}) async {
  final amount = await showPriceKeypadBottomSheet(
    context: context,
    partTitle: partTitle,
    vehicleModel: vehicleModel,
    lastPrice: lastPrice,
    initialAmount: initialUnitPrice > 0 ? initialUnitPrice : null,
  );
  if (amount == null) {
    return null;
  }
  return PartPriceSheetResult(unitPrice: amount);
}
