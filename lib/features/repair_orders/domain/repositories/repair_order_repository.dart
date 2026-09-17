import '../../../../core/database/app_database.dart';
import '../../../../core/database/enums.dart';
import '../../../invoices/domain/entities/invoice_totals.dart';
import '../entities/repair_order.dart';
import '../entities/repair_part.dart';
import '../entities/repair_service.dart';

abstract class RepairOrderRepository {
  Future<RepairOrder?> getById(String id);

  Future<List<RepairOrder>> getHistoryForVehicle(String vehicleId);

  Future<void> create(RepairOrder order);

  Future<void> update(RepairOrder order);

  Future<void> changeStatus({
    required String repairOrderId,
    required RepairOrderStatus to,
    String? note,
    DateTime? at,
  });

  Future<RepairPart> addPart(RepairPart part);

  Future<void> updatePart(RepairPart part);

  Future<void> removePart(String repairPartId);

  Future<RepairService> addService(RepairService service);

  Future<void> updateService(RepairService service);

  Future<void> removeService(String repairServiceId);

  Future<List<RepairPart>> getParts(String repairOrderId);

  Future<List<RepairService>> getServices(String repairOrderId);

  Future<InvoiceTotals> calculateInvoiceTotals(String repairOrderId);

  /// پایان تعمیر → آماده تحویل + فاکتور
  Future<void> completeRepair(String repairOrderId, {DateTime? completedAt});

  /// تحویل واقعی به مشتری
  Future<void> deliverRepair(String repairOrderId, {DateTime? deliveredAt});

  Future<void> cancelRepair(String repairOrderId, {String? reason});

  Future<void> recordMileage({
    required String vehicleId,
    required int mileage,
    String? repairOrderId,
    DateTime? recordedAt,
    String? note,
    bool allowDecrease = false,
  });

  Future<List<VehicleMileageLogRow>> listMileageLogs(String vehicleId);

  Future<List<RepairStatusHistoryRow>> listStatusHistory(String repairOrderId);
}
