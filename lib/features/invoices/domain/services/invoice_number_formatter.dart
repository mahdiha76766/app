import 'package:shamsi_date/shamsi_date.dart';

/// تولید شماره فاکتور ترتیبی یکتا: `۱۴۰۵-۰۰۰۱۲۴` (ذخیره لاتین: `1405-000124`).
abstract final class InvoiceNumberFormatter {
  static final RegExp pattern = RegExp(r'^(\d{4})-(\d+)$');

  static bool isSequentialFormat(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return pattern.hasMatch(value);
  }

  static String format({required int jalaliYear, required int sequence}) {
    return '$jalaliYear-${sequence.toString().padLeft(6, '0')}';
  }

  static int? parseYear(String invoiceNumber) {
    final match = pattern.firstMatch(invoiceNumber);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  static int? parseSequence(String invoiceNumber) {
    final match = pattern.firstMatch(invoiceNumber);
    return match == null ? null : int.tryParse(match.group(2)!);
  }

  static int jalaliYearOf(DateTime dateTime) {
    return Jalali.fromDateTime(dateTime.toLocal()).year;
  }
}
