import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/app/app.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/formatters/money_formatter.dart';
import 'package:mechanic_assistant/core/widgets/iranian_plate_input.dart';
import '../support/plate_test_helpers.dart';
import 'package:mechanic_assistant/features/messaging/data/providers.dart';
import 'package:mechanic_assistant/features/messaging/domain/services/customer_message_sender.dart';

class _NoopMessageSender implements CustomerMessageSender {
  @override
  Future<CustomerMessageSendResult> openPreparedMessage({
    required String message,
    String? phone,
    CustomerMessageSendChannel preferred =
        CustomerMessageSendChannel.whatsapp,
  }) async {
    return const CustomerMessageSendResult(
      channel: CustomerMessageSendChannel.systemShare,
    );
  }

  @override
  Future<CustomerMessageSendResult> shareFile({
    required String filePath,
    String? text,
    CustomerMessageSendChannel? preferred,
  }) async {
    return const CustomerMessageSendResult(
      channel: CustomerMessageSendChannel.systemShare,
    );
  }
}

Future<void> _enterPlate45B12311(WidgetTester tester) async {
  await enterPlate45B12311(tester);
}

Future<void> _confirmPriceKeys(
  WidgetTester tester,
  List<String> englishDigits,
) async {
  for (final key in englishDigits) {
    await tester.tap(find.byKey(ValueKey('price-key-$key')));
    await tester.pump();
  }
  final confirm = find.widgetWithText(FilledButton, 'تأیید');
  await tester.ensureVisible(confirm.last);
  await tester.tap(confirm.last);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
    'مسیر کامل MVP: خانه تا پیش‌نمایش واتساپ با جمع ۳٬۹۰۰٬۰۰۰',
    (tester) async {
      tester.view.physicalSize = const Size(420, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            customerMessageSenderProvider.overrideWithValue(
              _NoopMessageSender(),
            ),
          ],
          child: const MechanicAssistantApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تعمیرگاه من'), findsOneWidget);
      expect(find.byType(IranianPlateInput), findsNothing);

      await tester.tap(find.text('ورود دستی پلاک'));
      await tester.pumpAndSettle();
      expect(find.byType(IranianPlateInput), findsOneWidget);

      await _enterPlate45B12311(tester);
      await tester.tap(find.text('جستجوی خودرو'));
      await tester.pumpAndSettle();

      expect(find.text('پژو ۲۰۶'), findsOneWidget);
      await tester.tap(find.text('پژو ۲۰۶'));
      await tester.pumpAndSettle();

      final nameField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            (widget.decoration?.labelText?.contains('نام') ?? false),
      );
      await tester.enterText(nameField, 'علی تست');
      await tester.pump();

      await tester.tap(find.text('ثبت خودرو'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('شروع پذیرش'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('جلوبندی'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('جلوبندی'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ادامه'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('طبق کامل'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('طبق کامل'));
      await tester.pumpAndSettle();

      await _confirmPriceKeys(tester, ['3', '2', '0', '0']);

      final continueParts = find.textContaining('ادامه');
      await tester.ensureVisible(continueParts);
      await tester.tap(continueParts);
      await tester.pumpAndSettle();

      await tester.tap(find.text('ورود اجرت کل'));
      await tester.pumpAndSettle();
      await _confirmPriceKeys(tester, ['7', '0', '0']);

      expect(find.text(MoneyFormatter.format(3900000)), findsWidgets);

      await tester.tap(find.text('پرداخت کامل'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('پایان تعمیر'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('تأیید و پایان'));
      await tester.pumpAndSettle();

      expect(find.text('پیش‌نمایش پیام'), findsOneWidget);
      expect(find.textContaining('۳٬۹۰۰٬۰۰۰'), findsWidgets);
    },
  );
}
