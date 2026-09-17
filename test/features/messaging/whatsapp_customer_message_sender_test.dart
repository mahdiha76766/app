import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/formatters/phone_normalizer.dart';
import 'package:mechanic_assistant/features/messaging/data/services/whatsapp_customer_message_sender.dart';
import 'package:mechanic_assistant/features/messaging/domain/services/customer_message_sender.dart';

void main() {
  group('PhoneNormalizer for WhatsApp', () {
    test('شماره به فرمت بین‌المللی ۹۸ تبدیل می‌شود', () {
      expect(PhoneNormalizer.toInternational('09123456789'), '989123456789');
      expect(PhoneNormalizer.toInternational('+98 912 345 6789'), '989123456789');
      expect(PhoneNormalizer.toInternational('۰۹۱۲۳۴۵۶۷۸۹'), '989123456789');
    });
  });

  group('MultiChannelCustomerMessageSender', () {
    test('با شماره معتبر واتساپ را باز می‌کند و share صدا زده نمی‌شود', () async {
      Uri? launched;
      var shareCalled = false;

      final sender = MultiChannelCustomerMessageSender(
        canLaunch: (_) async => true,
        launch: (uri) async {
          launched = uri;
          return true;
        },
        shareText: (_) async {
          shareCalled = true;
        },
      );

      final result = await sender.openPreparedMessage(
        message: 'سلام تست',
        phone: '09123456789',
        preferred: CustomerMessageSendChannel.whatsapp,
      );

      expect(result.channel, CustomerMessageSendChannel.whatsapp);
      expect(launched, isNotNull);
      expect(launched!.host, 'wa.me');
      expect(launched!.path, '/989123456789');
      expect(launched!.queryParameters['text'], 'سلام تست');
      expect(shareCalled, isFalse);
    });

    test('اگر واتساپ باز نشود به اشتراک سیستم می‌رود', () async {
      var shareText = '';
      final sender = MultiChannelCustomerMessageSender(
        canLaunch: (_) async => false,
        launch: (_) async => false,
        shareText: (text) async {
          shareText = text;
        },
      );

      final result = await sender.openPreparedMessage(
        message: 'متن اشتراک',
        phone: '09123456789',
        preferred: CustomerMessageSendChannel.whatsapp,
      );

      expect(result.channel, CustomerMessageSendChannel.systemShare);
      expect(shareText, 'متن اشتراک');
    });

    test('بدون شماره فقط اشتراک سیستم باز می‌شود', () async {
      var shareText = '';
      var launchCalled = false;
      final sender = MultiChannelCustomerMessageSender(
        canLaunch: (_) async {
          launchCalled = true;
          return true;
        },
        launch: (_) async {
          launchCalled = true;
          return true;
        },
        shareText: (text) async {
          shareText = text;
        },
      );

      final result = await sender.openPreparedMessage(
        message: 'بدون شماره',
        phone: null,
        preferred: CustomerMessageSendChannel.whatsapp,
      );

      expect(result.channel, CustomerMessageSendChannel.systemShare);
      expect(shareText, 'بدون شماره');
      expect(launchCalled, isFalse);
    });

    test('شماره نامعتبر باعث fallback به اشتراک می‌شود', () async {
      var shareCalled = false;
      final sender = MultiChannelCustomerMessageSender(
        canLaunch: (_) async => true,
        launch: (_) async => true,
        shareText: (_) async {
          shareCalled = true;
        },
      );

      final result = await sender.openPreparedMessage(
        message: 'پیام',
        phone: '123',
        preferred: CustomerMessageSendChannel.whatsapp,
      );

      expect(result.channel, CustomerMessageSendChannel.systemShare);
      expect(shareCalled, isTrue);
    });

    test('خطای launchUrl باعث fallback به اشتراک می‌شود', () async {
      var shareCalled = false;
      final sender = MultiChannelCustomerMessageSender(
        canLaunch: (_) async => true,
        launch: (_) async {
          throw Exception('launch failed');
        },
        shareText: (_) async {
          shareCalled = true;
        },
      );

      final result = await sender.openPreparedMessage(
        message: 'پیام',
        phone: '09121111111',
        preferred: CustomerMessageSendChannel.whatsapp,
      );

      expect(result.channel, CustomerMessageSendChannel.systemShare);
      expect(shareCalled, isTrue);
    });
  });
}
