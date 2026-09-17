import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/persian_digit_formatter.dart';

void expectIranianPlate45B12311Visible() {
  expect(find.text(PersianDigitFormatter.toPersian('45')), findsWidgets);
  expect(find.text('ب'), findsWidgets);
  expect(find.text(PersianDigitFormatter.toPersian('123')), findsWidgets);
  expect(find.text(PersianDigitFormatter.toPersian('11')), findsWidgets);
  expect(find.text('ایران'), findsWidgets);
}

Future<void> enterPlate45B12311(WidgetTester tester) async {
  Future<void> tapDigit(String digit) async {
    await tester.tap(find.text(PersianDigitFormatter.toPersian(digit)).last);
    await tester.pump();
  }

  await tester.tap(find.byKey(const Key('plate_first_two_digits')));
  await tester.pumpAndSettle();
  await tapDigit('4');
  await tapDigit('5');
  await tester.pumpAndSettle();

  await tester.tap(find.text('انتخاب'));
  await tester.pumpAndSettle();
  await tester.tap(
    find.descendant(
      of: find.byType(GridView),
      matching: find.text('ب'),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('plate_middle_three_digits')));
  await tester.pumpAndSettle();
  await tapDigit('1');
  await tapDigit('2');
  await tapDigit('3');
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('plate_city_code_panel')));
  await tester.pumpAndSettle();
  await tapDigit('1');
  await tapDigit('1');
  await tester.pumpAndSettle();
}
