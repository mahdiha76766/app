class Workshop {
  const Workshop({
    required this.id,
    required this.name,
    this.mechanicName,
    this.phone,
    this.address,
    this.morningHour = 9,
    this.afternoonHour = 17,
    this.nightHour = 20,
    this.enableWhatsApp = true,
    this.enableTelegram = false,
    this.enableSms = false,
    this.includeBankInfoInMessages = false,
    this.nextInvoiceNumber = 1,
    this.invoiceSeqYear,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String? mechanicName;
  final String? phone;
  final String? address;
  final int morningHour;
  final int afternoonHour;
  final int nightHour;
  final bool enableWhatsApp;
  final bool enableTelegram;
  final bool enableSms;
  final bool includeBankInfoInMessages;
  final int nextInvoiceNumber;
  final int? invoiceSeqYear;
  final DateTime createdAt;
}
