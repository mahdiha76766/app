import '../formatters/money_formatter.dart';

/// حالت ورود مبلغ در صفحه‌کلید قیمت.
enum PriceInputMode {
  /// ورود بر حسب هزار تومان: `3200` → `۳٬۲۰۰٬۰۰۰`.
  thousandToman,

  /// ورود تومان کامل: `3200000` → `۳٬۲۰۰٬۰۰۰`.
  fullToman,
}

/// منطق خالص صفحه‌کلید قیمت (بدون UI) برای تست و استفاده مجدد.
class PriceKeypadLogic {
  PriceKeypadLogic({
    this.lastPrice,
    int? initialAmount,
    this.maxAmount = defaultMaxAmount,
    this.largeAmountThreshold = defaultLargeAmountThreshold,
    this._mode = PriceInputMode.thousandToman,
  }) {
    if (initialAmount != null && initialAmount > 0) {
      _setAmount(initialAmount);
    }
  }

  /// سقف منطقی مبلغ قطعات خودرو (۹۹۹ میلیون تومان).
  static const int defaultMaxAmount = 999000000;

  /// مبالغ از این حد به بالا قبل از ثبت تأیید دوباره می‌خواهند.
  static const int defaultLargeAmountThreshold = 20000000;

  static const List<int> quickIncrements = [
    50000,
    100000,
    200000,
    500000,
  ];

  static const List<int> quickDecrements = [
    50000,
    100000,
  ];

  final int? lastPrice;
  final int maxAmount;
  final int largeAmountThreshold;

  PriceInputMode _mode;
  String _digits = '';

  PriceInputMode get mode => _mode;

  String get digits => _digits;

  bool get hasLastPrice => lastPrice != null && lastPrice! > 0;

  /// مبلغ فعلی به تومان (هرگز منفی نیست).
  int get amount {
    if (_digits.isEmpty) {
      return 0;
    }
    return MoneyFormatter.parse(
      _digits,
      millionShortcut: _mode == PriceInputMode.thousandToman,
    ).clamp(0, maxAmount);
  }

  bool get canConfirm => amount > 0;

  bool get needsLargeAmountConfirmation =>
      amount >= largeAmountThreshold;

  void appendDigit(String digit) {
    if (digit.length != 1 || digit.compareTo('0') < 0 || digit.compareTo('9') > 0) {
      return;
    }
    final next = _digits.isEmpty && digit == '0' ? '0' : '$_digits$digit';
    if (_wouldExceedMax(next)) {
      return;
    }
    // جلوگیری از صفرهای پیشرو بی‌فایده (به‌جز خود صفر تنها).
    if (_digits == '0' && digit != '0') {
      _digits = digit;
      return;
    }
    if (_digits == '0' && digit == '0') {
      return;
    }
    _digits = next;
  }

  void clear() {
    _digits = '';
  }

  void backspace() {
    if (_digits.isEmpty) {
      return;
    }
    _digits = _digits.substring(0, _digits.length - 1);
  }

  /// تغییر حالت؛ مبلغ نمایش‌داده‌شده حفظ می‌شود.
  void setMode(PriceInputMode mode) {
    if (_mode == mode) {
      return;
    }
    final current = amount;
    _mode = mode;
    if (current <= 0) {
      _digits = '';
      return;
    }
    _setAmount(current);
  }

  void toggleMode() {
    setMode(
      _mode == PriceInputMode.thousandToman
          ? PriceInputMode.fullToman
          : PriceInputMode.thousandToman,
    );
  }

  /// فقط با انتخاب صریح کاربر (دکمه «همان قیمت قبلی»).
  bool applyLastPrice() {
    final previous = lastPrice;
    if (previous == null || previous <= 0) {
      return false;
    }
    _setAmount(previous);
    return true;
  }

  void adjustBy(int deltaToman) {
    _setAmount(amount + deltaToman);
  }

  void _setAmount(int value) {
    final clamped = value.clamp(0, maxAmount);
    if (clamped <= 0) {
      _digits = '';
      return;
    }
    if (_mode == PriceInputMode.thousandToman) {
      final thousands = clamped ~/ 1000;
      _digits = thousands > 0 ? thousands.toString() : '';
    } else {
      _digits = clamped.toString();
    }
  }

  bool _wouldExceedMax(String nextDigits) {
    final parsed = MoneyFormatter.parse(
      nextDigits,
      millionShortcut: _mode == PriceInputMode.thousandToman,
    );
    return parsed > maxAmount;
  }
}
