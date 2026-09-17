/// یک قطعه در پیام مشتری.
class MessagePartLine {
  const MessagePartLine({
    required this.title,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.byCustomer = false,
  });

  final String title;
  final int quantity;
  final int unitPrice;
  final int lineTotal;
  final bool byCustomer;
}

/// گروه خدمت + قطعات مرتبط.
class MessageServiceGroup {
  const MessageServiceGroup({
    required this.serviceTitle,
    this.parts = const [],
  });

  final String serviceTitle;
  final List<MessagePartLine> parts;
}

/// داده‌های لازم برای ساخت پیام آماده‌بودن تعمیر.
class RepairReadyMessageInput {
  const RepairReadyMessageInput({
    this.customerName,
    required this.vehicleModel,
    required this.serviceGroups,
    required this.grandTotalToman,
    required this.workshopName,
    this.laborAmount = 0,
    this.discountAmount = 0,
    this.includePriceDetails = false,
    this.deliveryLine,
    this.reminderLines = const [],
    this.bankInfoLines = const [],
    @Deprecated('Use serviceGroups') this.serviceTitles = const [],
    @Deprecated('Use serviceGroups') this.partTitles = const [],
  });

  final String? customerName;
  final String vehicleModel;
  final List<MessageServiceGroup> serviceGroups;
  final int grandTotalToman;
  final String workshopName;
  final int laborAmount;
  final int discountAmount;
  final bool includePriceDetails;
  final String? deliveryLine;
  final List<String> reminderLines;
  final List<String> bankInfoLines;

  /// سازگاری تست‌های قدیمی.
  final List<String> serviceTitles;
  final List<String> partTitles;

  List<MessageServiceGroup> get effectiveGroups {
    if (serviceGroups.isNotEmpty) {
      return serviceGroups;
    }
    if (serviceTitles.isEmpty && partTitles.isEmpty) {
      return const [];
    }
    final parts = partTitles
        .map(
          (title) => MessagePartLine(
            title: title,
            quantity: 1,
            unitPrice: 0,
            lineTotal: 0,
          ),
        )
        .toList();
    if (serviceTitles.isEmpty) {
      return [MessageServiceGroup(serviceTitle: 'خدمات', parts: parts)];
    }
    return [
      for (var i = 0; i < serviceTitles.length; i++)
        MessageServiceGroup(
          serviceTitle: serviceTitles[i],
          parts: i == 0 ? parts : const [],
        ),
    ];
  }
}
