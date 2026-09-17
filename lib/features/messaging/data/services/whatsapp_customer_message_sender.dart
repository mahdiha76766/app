import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/formatters/phone_normalizer.dart';
import '../../domain/services/customer_message_sender.dart';

/// باز کردن واتساپ / تلگرام / پیامک سیم‌کارت با fallback به اشتراک سیستم.
class MultiChannelCustomerMessageSender implements CustomerMessageSender {
  MultiChannelCustomerMessageSender({
    this.canLaunch,
    this.launch,
    this.shareText,
    this.shareFiles,
  });

  final Future<bool> Function(Uri uri)? canLaunch;
  final Future<bool> Function(Uri uri)? launch;
  final Future<void> Function(String text)? shareText;
  final Future<void> Function(String path, String? text)? shareFiles;

  @override
  Future<CustomerMessageSendResult> openPreparedMessage({
    required String message,
    String? phone,
    CustomerMessageSendChannel preferred =
        CustomerMessageSendChannel.whatsapp,
  }) async {
    final international = phone == null || phone.trim().isEmpty
        ? null
        : PhoneNormalizer.toInternational(phone);

    switch (preferred) {
      case CustomerMessageSendChannel.whatsapp:
        if (international != null &&
            await _tryOpenWhatsApp(
              phoneInternational: international,
              message: message,
            )) {
          return const CustomerMessageSendResult(
            channel: CustomerMessageSendChannel.whatsapp,
          );
        }
      case CustomerMessageSendChannel.telegram:
        if (await _tryOpenTelegram(
          phoneInternational: international,
          message: message,
        )) {
          return const CustomerMessageSendResult(
            channel: CustomerMessageSendChannel.telegram,
          );
        }
      case CustomerMessageSendChannel.sms:
        if (await _tryOpenSms(phone: phone, message: message)) {
          return const CustomerMessageSendResult(
            channel: CustomerMessageSendChannel.sms,
          );
        }
      case CustomerMessageSendChannel.systemShare:
        break;
    }

    await _shareText(message);
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
    if (shareFiles != null) {
      await shareFiles!(filePath, text);
    } else {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          text: text,
        ),
      );
    }
    return CustomerMessageSendResult(
      channel: preferred ?? CustomerMessageSendChannel.systemShare,
    );
  }

  Future<bool> _tryOpenWhatsApp({
    required String phoneInternational,
    required String message,
  }) async {
    final uri = Uri.https(
      'wa.me',
      '/$phoneInternational',
      {'text': message},
    );
    return _launch(uri);
  }

  Future<bool> _tryOpenTelegram({
    required String? phoneInternational,
    required String message,
  }) async {
    // اشتراک متن در تلگرام (با یا بدون شماره)
    final shareUri = Uri.https(
      't.me',
      '/share/url',
      {'text': message},
    );
    if (await _launch(shareUri)) {
      return true;
    }
    if (phoneInternational != null) {
      final resolve = Uri.parse('tg://resolve?phone=$phoneInternational');
      if (await _launch(resolve)) {
        return true;
      }
    }
    return false;
  }

  Future<bool> _tryOpenSms({
    required String? phone,
    required String message,
  }) async {
    final digits = phone == null || phone.trim().isEmpty
        ? ''
        : PhoneNormalizer.normalize(phone) ?? phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri(
      scheme: 'sms',
      path: digits,
      queryParameters: {'body': message},
    );
    return _launch(uri);
  }

  Future<bool> _launch(Uri uri) async {
    try {
      final can = canLaunch != null
          ? await canLaunch!(uri)
          : await canLaunchUrl(uri);
      if (!can) {
        return false;
      }
      if (launch != null) {
        return await launch!(uri);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<void> _shareText(String message) async {
    if (shareText != null) {
      await shareText!(message);
      return;
    }
    await SharePlus.instance.share(ShareParams(text: message));
  }
}
