import '../../../../core/database/enums.dart';
import '../../../repair_orders/domain/entities/repair_order.dart';
import '../../../repair_orders/domain/entities/repair_service.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/assistant_models.dart';

/// ساخت زمینهٔ امن خودرو بدون PII (نام، موبایل، پلاک، بانک).
abstract final class AssistantContextBuilder {
  static AssistantVehicleContext build({
    required Vehicle? vehicle,
    required RepairOrder order,
    required List<RepairService> services,
    required List<RepairOrder> recentOrders,
    required Map<String, List<RepairService>> servicesByOrderId,
  }) {
    final modelParts = <String>[
      if (vehicle?.manufacturer != null &&
          vehicle!.manufacturer!.trim().isNotEmpty)
        vehicle.manufacturer!.trim(),
      if (vehicle?.model != null && vehicle!.model!.trim().isNotEmpty)
        vehicle.model!.trim(),
      if (vehicle?.trim != null && vehicle!.trim!.trim().isNotEmpty)
        vehicle.trim!.trim(),
    ];

    final recent = <AssistantRecentRepair>[];
    for (final past in recentOrders) {
      if (past.id == order.id) continue;
      if (past.status == RepairOrderStatus.cancelled) continue;
      final titles = servicesByOrderId[past.id] ?? const [];
      final summaryParts = <String>[
        if (past.complaintText != null && past.complaintText!.trim().isNotEmpty)
          past.complaintText!.trim(),
        if (titles.isNotEmpty) titles.map((s) => s.title).join('، '),
      ];
      if (summaryParts.isEmpty) continue;
      recent.add(
        AssistantRecentRepair(
          summary: summaryParts.join(' — '),
          mileage: past.mileage,
        ),
      );
      if (recent.length >= 5) break;
    }

    return AssistantVehicleContext(
      vehicleModel: modelParts.isEmpty ? null : modelParts.join(' '),
      mileage: order.mileage ?? vehicle?.lastMileage,
      complaint: order.complaintText?.trim(),
      selectedServices: services.map((s) => s.title).toList(),
      recentRepairs: recent,
    );
  }

  /// فقط چند پیام آخر برای کاهش هزینه.
  static List<Map<String, String>> recentMessagesPayload(
    List<AssistantChatMessage> messages, {
    int maxPairs = 3,
  }) {
    final sliced = messages.length <= maxPairs * 2
        ? messages
        : messages.sublist(messages.length - maxPairs * 2);
    return [
      for (final m in sliced)
        {
          'role': m.role,
          'content': m.isUser
              ? m.content
              : (m.reply?.summary ?? m.content),
        },
    ];
  }
}
