import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/widgets/iranian_plate_input.dart';
import 'package:mechanic_assistant/core/widgets/numeric_keypad.dart';
import 'package:mechanic_assistant/core/formatters/persian_digit_formatter.dart';

void main() {
  testWidgets('ورودی پلاک چهار بخش جدا و دکمه جستجو ندارد TextField یکپارچه', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: IranianPlateInput(),
          ),
        ),
      ),
    );

    expect(find.text('۲ رقم'), findsOneWidget);
    expect(find.text('۳ رقم'), findsOneWidget);
    expect(find.text('انتخاب'), findsOneWidget);
    expect(find.text('ایران'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byKey(const Key('plate_blue_strip')), findsOneWidget);
    expect(find.byKey(const Key('plate_city_code_panel')), findsOneWidget);

    await tester.tap(find.text('انتخاب'));
    await tester.pumpAndSettle();

    expect(find.text('انتخاب حرف پلاک'), findsOneWidget);
    expect(find.text('ب'), findsWidgets);

    await tester.tap(find.text('ب').last);
    await tester.pumpAndSettle();

    expect(find.text('ب'), findsOneWidget);
  });

  testWidgets('با کیبورد عددی کد شهر را می‌گیرد', (tester) async {
    IranianPlateValue? latest;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: IranianPlateInput(
              onChanged: (value) => latest = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('plate_city_code_panel')));
    await tester.pumpAndSettle();

    expect(find.text('کد شهر (۲ رقم)'), findsOneWidget);

    final keypad = find.byType(NumericKeypad);
    await tester.tap(
      find.descendant(
        of: keypad,
        matching: find.text(PersianDigitFormatter.toPersian('1')),
      ),
    );
    await tester.pump();
    await tester.tap(
      find.descendant(
        of: keypad,
        matching: find.text(PersianDigitFormatter.toPersian('1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(latest?.cityCode, '11');
  });
}
