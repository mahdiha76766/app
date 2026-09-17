class BankAccount {
  const BankAccount({
    required this.id,
    required this.workshopId,
    required this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.cardNumber,
    this.sortOrder = 0,
    required this.createdAt,
  });

  final String id;
  final String workshopId;
  final String bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? cardNumber;
  final int sortOrder;
  final DateTime createdAt;
}
