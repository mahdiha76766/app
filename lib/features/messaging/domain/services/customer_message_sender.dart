/// کانال ارسال پیام به مشتری.
enum CustomerMessageSendChannel {
  whatsapp,
  telegram,
  sms,
  systemShare,
}

class CustomerMessageSendResult {
  const CustomerMessageSendResult({
    required this.channel,
  });

  final CustomerMessageSendChannel channel;
}

/// ارسال/باز کردن پیام مشتری (بدون ارسال خودکار).
abstract class CustomerMessageSender {
  Future<CustomerMessageSendResult> openPreparedMessage({
    required String message,
    String? phone,
    CustomerMessageSendChannel preferred =
        CustomerMessageSendChannel.whatsapp,
  });

  Future<CustomerMessageSendResult> shareFile({
    required String filePath,
    String? text,
    CustomerMessageSendChannel? preferred,
  });
}
