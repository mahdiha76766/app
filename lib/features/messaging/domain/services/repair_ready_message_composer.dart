import '../../../../core/formatters/jalali_date_formatter.dart';
import '../../../../core/formatters/money_formatter.dart';
import '../../../../core/formatters/persian_digit_formatter.dart';
import '../entities/repair_ready_message_input.dart';

/// تولید متن فارسی پیام آماده‌بودن تعمیر برای مشتری.
abstract final class RepairReadyMessageComposer {
  static const defaultCustomerName = 'مشتری عزیز';
  static const defaultWorkshopName = 'تعمیرگاه';

  static String compose(RepairReadyMessageInput input) {
    final name = _resolveCustomerName(input.customerName);
    final model = input.vehicleModel.trim().isEmpty
        ? 'شما'
        : input.vehicleModel.trim();
    final workshop = input.workshopName.trim().isEmpty
        ? defaultWorkshopName
        : input.workshopName.trim();
    final groups = input.effectiveGroups;
    final workBlock = _formatWorkBlock(
      groups,
      includePrices: input.includePriceDetails,
    );
    final amount = MoneyFormatter.format(
      input.grandTotalToman,
      withSuffix: false,
    );

    final delivery = input.deliveryLine?.trim();
    final deliveryBlock = (delivery == null || delivery.isEmpty)
        ? ''
        : '''

زمان تحویل:
$delivery
''';

    final priceDetails = input.includePriceDetails
        ? _formatPriceDetails(input)
        : '';

    final reminders = _bulletList(input.reminderLines);
    final remindersBlock = reminders.isEmpty
        ? ''
        : '''

یادآوری سرویس:
$reminders
''';

    final banks = _bulletList(input.bankInfoLines);
    final banksBlock = banks.isEmpty
        ? ''
        : '''

اطلاعات واریز:
$banks
''';

    return '''
سلام $name

خودروی $model شما آماده تحویل است.
$deliveryBlock
$workBlock
$priceDetails
مبلغ نهایی: $amount تومان
$remindersBlock$banksBlock
تعمیرگاه: $workshop
'''
        .trim();
  }

  static String _formatWorkBlock(
    List<MessageServiceGroup> groups, {
    required bool includePrices,
  }) {
    if (groups.isEmpty) {
      return '''

خدمات و قطعات:
ثبت نشده''';
    }

    final buffer = StringBuffer('\n\nخدمات و قطعات:');
    for (final group in groups) {
      buffer.writeln();
      buffer.writeln('▸ ${group.serviceTitle}');
      if (group.parts.isEmpty) {
        buffer.writeln('  • قطعه‌ای ثبت نشده');
        continue;
      }
      for (final part in group.parts) {
        final qty = PersianDigitFormatter.intToPersian(part.quantity);
        final customer = part.byCustomer ? ' (آورده مشتری)' : '';
        if (includePrices && !part.byCustomer && part.lineTotal > 0) {
          final price = MoneyFormatter.format(
            part.lineTotal,
            withSuffix: false,
          );
          buffer.writeln('  • ${part.title} × $qty$customer — $price تومان');
        } else {
          buffer.writeln('  • ${part.title} × $qty$customer');
        }
      }
    }
    return buffer.toString().trimRight();
  }

  static String _formatPriceDetails(RepairReadyMessageInput input) {
    final lines = <String>[];
    if (input.laborAmount > 0) {
      lines.add(
        '• اجرت: ${MoneyFormatter.format(input.laborAmount, withSuffix: false)} تومان',
      );
    }
    if (input.discountAmount > 0) {
      lines.add(
        '• تخفیف: ${MoneyFormatter.format(input.discountAmount, withSuffix: false)} تومان',
      );
    }
    if (lines.isEmpty) {
      return '';
    }
    return '''

جزئیات مبلغ:
${lines.join('\n')}
''';
  }

  static String _resolveCustomerName(String? raw) {
    final name = raw?.trim() ?? '';
    if (name.isEmpty) {
      return defaultCustomerName;
    }
    return name;
  }

  static String _bulletList(List<String> items) {
    final cleaned = items
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    if (cleaned.isEmpty) {
      return '';
    }
    return cleaned.map((item) => '• $item').join('\n');
  }

  /// ساخت یک خط یادآوری خوانا برای پیام مشتری.
  static String formatReminderLine({
    required String title,
    DateTime? dueDate,
    int? dueMileage,
    int? currentMileage,
  }) {
    final parts = <String>[title.trim()];
    if (dueMileage != null) {
      if (currentMileage != null && dueMileage > currentMileage) {
        final delta = dueMileage - currentMileage;
        parts.add(
          '${PersianDigitFormatter.intToPersian(delta)} کیلومتر دیگر',
        );
      } else {
        parts.add(
          'در کیلومتر ${PersianDigitFormatter.intToPersian(dueMileage)}',
        );
      }
    }
    if (dueDate != null) {
      parts.add(JalaliDateFormatter.formatLong(dueDate));
    }
    return parts.join(' — ');
  }

  /// متن زمان تحویل: `سه‌شنبه ۲۹ تیر — عصر ساعت ۱۷`
  static String formatDeliveryLine(DateTime deliveryAt) {
    final weekday = JalaliDateFormatter.formatWeekday(deliveryAt);
    final date = JalaliDateFormatter.formatLong(deliveryAt);
    final hour = deliveryAt.hour;
    final period = switch (hour) {
      <= 11 => 'صبح',
      <= 17 => 'عصر',
      _ => 'شب',
    };
    final time = PersianDigitFormatter.toPersian(
      hour.toString().padLeft(2, '0'),
    );
    return '$weekday $date — $period ساعت $time';
  }
}
