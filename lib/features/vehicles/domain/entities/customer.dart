class Customer {
  const Customer({
    required this.id,
    this.fullName,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? fullName;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
}
