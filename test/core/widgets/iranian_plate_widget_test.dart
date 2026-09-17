import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/widgets/iranian_plate_widget.dart';

void main() {
  testWidgets('چیدمان LTR: نوار آبی چپ، کد شهر راست — ۵۲ د ۶۸۹ ایران ۱۱', (
    tester,
  ) async {
    const value = IranianPlateValue(
      firstTwoDigits: '52',
      letter: 'د',
      middleThreeDigits: '689',
      cityCode: '11',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IranianPlateWidget(value: value),
            ),
          ),
        ),
      ),
    );

    expect(find.text('۵۲'), findsOneWidget);
    expect(find.text('د'), findsOneWidget);
    expect(find.text('۶۸۹'), findsOneWidget);
    expect(find.text('۱۱'), findsOneWidget);
    expect(find.text('ایران'), findsOneWidget);
    expect(find.text('I.R.'), findsOneWidget);

    final blueStrip = tester.getRect(find.byKey(const Key('plate_blue_strip')));
    final firstTwo =
        tester.getRect(find.byKey(const Key('plate_first_two_digits')));
    final letter = tester.getRect(find.byKey(const Key('plate_letter')));
    final middle =
        tester.getRect(find.byKey(const Key('plate_middle_three_digits')));
    final cityPanel =
        tester.getRect(find.byKey(const Key('plate_city_code_panel')));

    expect(blueStrip.left, lessThan(firstTwo.left));
    expect(firstTwo.left, lessThan(letter.left));
    expect(letter.left, lessThan(middle.left));
    expect(middle.left, lessThan(cityPanel.left));
    expect(value.display, '۵۲ د ۶۸۹ ایران ۱۱');
    expect(value.normalized, '52-D-689-11');
  });
}
