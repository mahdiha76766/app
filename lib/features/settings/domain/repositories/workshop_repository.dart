import '../entities/workshop.dart';

abstract class WorkshopRepository {
  Future<Workshop?> getWorkshop();

  Future<void> saveWorkshop(Workshop workshop);
}
