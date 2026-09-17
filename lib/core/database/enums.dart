/// وضعیت سفارش تعمیر (Workflow تعمیرگاه).
enum RepairOrderStatus {
  /// پذیرش‌شده
  accepted('accepted'),

  /// در انتظار بررسی
  awaitingReview('awaitingReview'),

  /// در حال تعمیر
  inRepair('inRepair'),

  /// منتظر قطعه
  waitingForParts('waitingForParts'),

  /// آماده تحویل (پایان تعمیر)
  readyForDelivery('readyForDelivery'),

  /// تحویل‌شده به مشتری
  delivered('delivered'),

  /// لغوشده
  cancelled('cancelled');

  const RepairOrderStatus(this.value);
  final String value;

  static RepairOrderStatus fromValue(String value) {
    switch (value) {
      case 'draft':
        return RepairOrderStatus.accepted;
      case 'inProgress':
        return RepairOrderStatus.inRepair;
      case 'completed':
        return RepairOrderStatus.delivered;
      default:
        return RepairOrderStatus.values.firstWhere(
          (item) => item.value == value,
          orElse: () => RepairOrderStatus.accepted,
        );
    }
  }

  String get labelFa => switch (this) {
        RepairOrderStatus.accepted => 'پذیرش‌شده',
        RepairOrderStatus.awaitingReview => 'در انتظار بررسی',
        RepairOrderStatus.inRepair => 'در حال تعمیر',
        RepairOrderStatus.waitingForParts => 'منتظر قطعه',
        RepairOrderStatus.readyForDelivery => 'آماده تحویل',
        RepairOrderStatus.delivered => 'تحویل‌شده',
        RepairOrderStatus.cancelled => 'لغوشده',
      };

  /// هنوز در جریان کارگاه (نه تحویل نهایی و نه لغو).
  bool get isOpen =>
      this != RepairOrderStatus.delivered && this != RepairOrderStatus.cancelled;

  /// در گزارش درآمد / فاکتور لحاظ می‌شود.
  bool get countsForFinance =>
      this == RepairOrderStatus.readyForDelivery ||
      this == RepairOrderStatus.delivered;
}

/// وضعیت پرداخت.
enum PaymentStatus {
  unpaid('unpaid'),
  partial('partial'),
  paid('paid');

  const PaymentStatus(this.value);
  final String value;

  static PaymentStatus fromValue(String value) {
    return PaymentStatus.values.firstWhere(
      (item) => item.value == value,
      orElse: () => PaymentStatus.unpaid,
    );
  }

  /// برچسب فارسی برای UI و PDF.
  String get labelFa => switch (this) {
        PaymentStatus.unpaid => 'پرداخت‌نشده',
        PaymentStatus.partial => 'پرداخت جزئی',
        PaymentStatus.paid => 'پرداخت کامل',
      };
}

/// روش پرداخت.
enum PaymentMethod {
  cash('cash'),
  pos('pos'),
  cardToCard('cardToCard'),
  bankTransfer('bankTransfer'),
  other('other');

  const PaymentMethod(this.value);
  final String value;

  static PaymentMethod fromValue(String value) {
    return PaymentMethod.values.firstWhere(
      (item) => item.value == value,
      orElse: () => PaymentMethod.other,
    );
  }

  String get labelFa => switch (this) {
        PaymentMethod.cash => 'نقدی',
        PaymentMethod.pos => 'کارت‌خوان',
        PaymentMethod.cardToCard => 'کارت‌به‌کارت',
        PaymentMethod.bankTransfer => 'انتقال بانکی',
        PaymentMethod.other => 'سایر',
      };
}

/// تامین‌کننده قطعه.
enum PartSuppliedBy {
  workshop('workshop'),
  customer('customer');

  const PartSuppliedBy(this.value);
  final String value;

  static PartSuppliedBy fromValue(String value) {
    return PartSuppliedBy.values.firstWhere(
      (item) => item.value == value,
      orElse: () => PartSuppliedBy.workshop,
    );
  }
}

/// وضعیت یادآوری.
enum ReminderStatus {
  pending('pending'),
  done('done'),
  cancelled('cancelled');

  const ReminderStatus(this.value);
  final String value;

  static ReminderStatus fromValue(String value) {
    return ReminderStatus.values.firstWhere(
      (item) => item.value == value,
      orElse: () => ReminderStatus.pending,
    );
  }

  String get labelFa => switch (this) {
        ReminderStatus.pending => 'فعال',
        ReminderStatus.done => 'انجام‌شده',
        ReminderStatus.cancelled => 'لغوشده',
      };
}
