import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/widgets/price_keypad_logic.dart';

void main() {
  group('PriceKeypadLogic parsing', () {
    test('حالت هزار تومان: 3200 → ۳٬۲۰۰٬۰۰۰', () {
      final logic = PriceKeypadLogic();
      for (final digit in '3200'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.amount, 3200000);
    });

    test('حالت هزار تومان: 850 → ۸۵۰٬۰۰۰', () {
      final logic = PriceKeypadLogic();
      for (final digit in '850'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.amount, 850000);
    });

    test('حالت تومان کامل بدون ضرب در ۱۰۰۰', () {
      final logic = PriceKeypadLogic(mode: PriceInputMode.fullToman);
      for (final digit in '3200000'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.amount, 3200000);
    });

    test('ورودی خالی مبلغ صفر است', () {
      final logic = PriceKeypadLogic();
      expect(logic.amount, 0);
      expect(logic.canConfirm, isFalse);
    });
  });

  group('PriceKeypadLogic input rules', () {
    test('پاک کردن همه ارقام', () {
      final logic = PriceKeypadLogic();
      logic.appendDigit('3');
      logic.appendDigit('2');
      logic.clear();
      expect(logic.digits, isEmpty);
      expect(logic.amount, 0);
    });

    test('backspace آخرین رقم را حذف می‌کند', () {
      final logic = PriceKeypadLogic();
      logic.appendDigit('8');
      logic.appendDigit('5');
      logic.appendDigit('0');
      logic.backspace();
      expect(logic.digits, '85');
      expect(logic.amount, 85000);
    });

    test('صفر پیشرو بی‌فایده جایگزین می‌شود', () {
      final logic = PriceKeypadLogic();
      logic.appendDigit('0');
      logic.appendDigit('5');
      expect(logic.digits, '5');
      expect(logic.amount, 5000);
    });

    test('مبلغ از سقف بالاتر نمی‌رود', () {
      final logic = PriceKeypadLogic(maxAmount: 999000000);
      for (final digit in '9999999'.split('')) {
        logic.appendDigit(digit);
      }
      // 9999999 * 1000 would exceed; last digits that fit stop earlier
      expect(logic.amount, lessThanOrEqualTo(999000000));
      expect(logic.amount, greaterThan(0));
    });

    test('سقف در حالت تومان کامل هم اعمال می‌شود', () {
      final logic = PriceKeypadLogic(
        mode: PriceInputMode.fullToman,
        maxAmount: 1000000,
      );
      for (final digit in '1000001'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.amount, lessThanOrEqualTo(1000000));
    });
  });

  group('PriceKeypadLogic mode switch', () {
    test('تغییر حالت مبلغ نمایشی را حفظ می‌کند', () {
      final logic = PriceKeypadLogic();
      for (final digit in '3200'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.amount, 3200000);

      logic.setMode(PriceInputMode.fullToman);
      expect(logic.mode, PriceInputMode.fullToman);
      expect(logic.amount, 3200000);
      expect(logic.digits, '3200000');

      logic.setMode(PriceInputMode.thousandToman);
      expect(logic.amount, 3200000);
      expect(logic.digits, '3200');
    });

    test('toggleMode بین دو حالت جابه‌جا می‌شود', () {
      final logic = PriceKeypadLogic();
      expect(logic.mode, PriceInputMode.thousandToman);
      logic.toggleMode();
      expect(logic.mode, PriceInputMode.fullToman);
      logic.toggleMode();
      expect(logic.mode, PriceInputMode.thousandToman);
    });
  });

  group('PriceKeypadLogic last price', () {
    test('آخرین قیمت به‌صورت خودکار اعمال نمی‌شود', () {
      final logic = PriceKeypadLogic(lastPrice: 3000000);
      expect(logic.amount, 0);
      expect(logic.hasLastPrice, isTrue);
      expect(logic.digits, isEmpty);
    });

    test('همان قیمت قبلی فقط با فراخوانی صریح اعمال می‌شود', () {
      final logic = PriceKeypadLogic(lastPrice: 3000000);
      expect(logic.applyLastPrice(), isTrue);
      expect(logic.amount, 3000000);
    });

    test('بدون آخرین قیمت applyLastPrice ناموفق است', () {
      final logic = PriceKeypadLogic();
      expect(logic.applyLastPrice(), isFalse);
      expect(logic.amount, 0);
    });

    test('initialAmount فقط وقتی کاربر قبلاً قیمت داشته اعمال می‌شود', () {
      final logic = PriceKeypadLogic(
        lastPrice: 3000000,
        initialAmount: 1500000,
      );
      expect(logic.amount, 1500000);
    });
  });

  group('PriceKeypadLogic quick adjust', () {
    test('دکمه‌های افزایش هزارتومانی', () {
      final logic = PriceKeypadLogic(initialAmount: 1000000);
      logic.adjustBy(50000);
      expect(logic.amount, 1050000);
      logic.adjustBy(100000);
      expect(logic.amount, 1150000);
      logic.adjustBy(200000);
      expect(logic.amount, 1350000);
      logic.adjustBy(500000);
      expect(logic.amount, 1850000);
    });

    test('دکمه‌های کاهش و جلوگیری از منفی', () {
      final logic = PriceKeypadLogic(initialAmount: 80000);
      logic.adjustBy(-50000);
      expect(logic.amount, 30000);
      logic.adjustBy(-100000);
      expect(logic.amount, 0);
      expect(logic.amount, isNonNegative);
    });

    test('کاهش از صفر منفی نمی‌شود', () {
      final logic = PriceKeypadLogic();
      logic.adjustBy(-50000);
      expect(logic.amount, 0);
    });

    test('افزایش از سقف فراتر نمی‌رود', () {
      final logic = PriceKeypadLogic(
        initialAmount: 998000000,
        maxAmount: 999000000,
      );
      logic.adjustBy(500000);
      expect(logic.amount, 998500000);
      logic.adjustBy(5000000);
      expect(logic.amount, 999000000);
    });
  });

  group('PriceKeypadLogic large amount', () {
    test('نیاز به تأیید برای مبالغ بسیار بزرگ', () {
      final logic = PriceKeypadLogic(
        largeAmountThreshold: 20000000,
      );
      for (final digit in '25000'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.amount, 25000000);
      expect(logic.needsLargeAmountConfirmation, isTrue);
      expect(logic.canConfirm, isTrue);
    });

    test('مبالغ معمولی تأیید اضافه نمی‌خواهند', () {
      final logic = PriceKeypadLogic();
      for (final digit in '3200'.split('')) {
        logic.appendDigit(digit);
      }
      expect(logic.needsLargeAmountConfirmation, isFalse);
    });
  });
}
