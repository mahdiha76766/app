import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/formatters/money_formatter.dart';
import 'package:mechanic_assistant/core/theme_constants.dart';
import 'package:mechanic_assistant/core/widgets/price_keypad_bottom_sheet.dart';
import 'package:mechanic_assistant/core/widgets/price_keypad_logic.dart';

void main() {
  void setTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      locale: const Locale('fa', 'IR'),
      home: Scaffold(body: child),
    );
  }

  testWidgets('هدر نام قطعه، مدل و آخرین قیمت را نشان می‌دهد', (tester) async {
    setTallSurface(tester);
    await tester.pumpWidget(
      wrap(
        const PriceKeypadBottomSheet(
          partTitle: 'طبق',
          vehicleModel: 'پژو ۲۰۶',
          lastPrice: 3000000,
          enableHaptics: false,
        ),
      ),
    );

    expect(find.text('طبق - پژو ۲۰۶'), findsOneWidget);
    expect(find.textContaining('آخرین بار'), findsOneWidget);
    expect(find.textContaining(MoneyFormatter.format(3000000)), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('آخرین قیمت بدون لمس کاربر اعمال نمی‌شود', (tester) async {
    setTallSurface(tester);
    final logic = PriceKeypadLogic(lastPrice: 3000000);
    await tester.pumpWidget(
      wrap(
        PriceKeypadBottomSheet(
          partTitle: 'طبق',
          vehicleModel: 'پژو ۲۰۶',
          lastPrice: 3000000,
          logic: logic,
          enableHaptics: false,
        ),
      ),
    );

    expect(logic.amount, 0);
    expect(find.text('—'), findsOneWidget);

    await tester.tap(find.text('همان قیمت قبلی'));
    await tester.pump();

    expect(logic.amount, 3000000);
    expect(find.text(MoneyFormatter.format(3000000)), findsWidgets);
  });

  testWidgets('ورود 3200 مبلغ ۳٬۲۰۰٬۰۰۰ را نشان می‌دهد', (tester) async {
    setTallSurface(tester);
    final logic = PriceKeypadLogic();
    await tester.pumpWidget(
      wrap(
        PriceKeypadBottomSheet(
          partTitle: 'لنت',
          logic: logic,
          enableHaptics: false,
        ),
      ),
    );

    for (final key in ['3', '2', '0', '0']) {
      await tester.tap(find.byKey(ValueKey('price-key-$key')));
      await tester.pump();
    }

    expect(logic.amount, 3200000);
    expect(find.text(MoneyFormatter.format(3200000)), findsOneWidget);
  });

  testWidgets('دکمه‌های keypad حداقل ۶۰ پیکسل ارتفاع دارند', (tester) async {
    setTallSurface(tester);
    await tester.pumpWidget(
      wrap(
        const PriceKeypadBottomSheet(
          partTitle: 'لنت',
          enableHaptics: false,
        ),
      ),
    );

    final size = tester.getSize(find.byKey(const ValueKey('price-key-1')));
    expect(size.height, greaterThanOrEqualTo(AppTapTargets.priceKeypad));
  });

  testWidgets('تأیید مبلغ را برمی‌گرداند', (tester) async {
    setTallSurface(tester);
    int? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    result = await showPriceKeypadBottomSheet(
                      context: context,
                      partTitle: 'دیسک',
                      lastPrice: 1000000,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('price-key-8')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('price-key-5')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('price-key-0')));
    await tester.pump();

    await tester.ensureVisible(find.widgetWithText(FilledButton, 'تأیید'));
    await tester.tap(find.widgetWithText(FilledButton, 'تأیید'));
    await tester.pumpAndSettle();

    expect(result, 850000);
  });

  testWidgets('مبلغ بسیار بزرگ قبل از ثبت تأیید می‌خواهد', (tester) async {
    setTallSurface(tester);
    final logic = PriceKeypadLogic(
      initialAmount: 25000000,
      largeAmountThreshold: 20000000,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () {
                    showModalBottomSheet<int>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => PriceKeypadBottomSheet(
                        partTitle: 'گیربکس',
                        logic: logic,
                        enableHaptics: false,
                      ),
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.widgetWithText(FilledButton, 'تأیید'));
    await tester.tap(find.widgetWithText(FilledButton, 'تأیید'));
    await tester.pumpAndSettle();

    expect(find.text('تأیید مبلغ بالا'), findsOneWidget);
    await tester.tap(find.text('انصراف'));
    await tester.pumpAndSettle();
    expect(find.text('تأیید مبلغ بالا'), findsNothing);
  });

  testWidgets('تغییر به تومان کامل حالت ورود را عوض می‌کند', (tester) async {
    setTallSurface(tester);
    final logic = PriceKeypadLogic();
    await tester.pumpWidget(
      wrap(
        PriceKeypadBottomSheet(
          partTitle: 'روغن',
          logic: logic,
          enableHaptics: false,
        ),
      ),
    );

    await tester.tap(find.text('تغییر به تومان کامل'));
    await tester.pump();
    expect(logic.mode, PriceInputMode.fullToman);
    expect(find.text('ورود تومان کامل'), findsOneWidget);
  });
}
