class ServiceCategory {
  const ServiceCategory({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.sortOrder,
    required this.isActive,
  });

  final String id;
  final String title;
  final String iconKey;
  final int sortOrder;
  final bool isActive;
}
