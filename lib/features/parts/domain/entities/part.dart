class Part {
  const Part({
    required this.id,
    required this.title,
    required this.normalizedTitle,
    this.serviceCategoryId,
    this.vehicleModel,
    this.brand,
    required this.usageCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String normalizedTitle;
  final String? serviceCategoryId;
  final String? vehicleModel;
  final String? brand;
  final int usageCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
