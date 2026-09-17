class Vehicle {
  const Vehicle({
    required this.id,
    this.customerId,
    required this.plateNormalized,
    required this.plateDisplay,
    this.manufacturer,
    this.model,
    this.trim,
    this.productionYear,
    this.lastMileage,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? customerId;
  final String plateNormalized;
  final String plateDisplay;
  final String? manufacturer;
  final String? model;
  final String? trim;
  final int? productionYear;
  final int? lastMileage;
  final DateTime createdAt;
  final DateTime updatedAt;
}
