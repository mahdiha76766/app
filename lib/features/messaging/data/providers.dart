import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/services/customer_message_sender.dart';
import 'services/whatsapp_customer_message_sender.dart';

final customerMessageSenderProvider = Provider<CustomerMessageSender>((ref) {
  return MultiChannelCustomerMessageSender();
});
