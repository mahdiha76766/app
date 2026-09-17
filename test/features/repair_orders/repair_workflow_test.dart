import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/services/repair_workflow.dart';

void main() {
  group('RepairWorkflow', () {
    test('allows valid transitions', () {
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.accepted,
          RepairOrderStatus.inRepair,
        ),
        isTrue,
      );
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.inRepair,
          RepairOrderStatus.waitingForParts,
        ),
        isTrue,
      );
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.inRepair,
          RepairOrderStatus.readyForDelivery,
        ),
        isTrue,
      );
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.readyForDelivery,
          RepairOrderStatus.delivered,
        ),
        isTrue,
      );
    });

    test('blocks invalid transitions', () {
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.accepted,
          RepairOrderStatus.delivered,
        ),
        isFalse,
      );
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.delivered,
          RepairOrderStatus.inRepair,
        ),
        isFalse,
      );
      expect(
        RepairWorkflow.canTransition(
          RepairOrderStatus.cancelled,
          RepairOrderStatus.inRepair,
        ),
        isFalse,
      );
      expect(
        () => RepairWorkflow.ensureCanTransition(
          RepairOrderStatus.accepted,
          RepairOrderStatus.readyForDelivery,
        ),
        throwsA(isA<InvalidRepairTransitionException>()),
      );
    });

    test('requires confirm for cancel and deliver', () {
      expect(
        RepairWorkflow.requiresConfirm(RepairOrderStatus.cancelled),
        isTrue,
      );
      expect(
        RepairWorkflow.requiresConfirm(RepairOrderStatus.delivered),
        isTrue,
      );
      expect(
        RepairWorkflow.requiresConfirm(RepairOrderStatus.waitingForParts),
        isFalse,
      );
    });

    test('legacy status mapping', () {
      expect(RepairOrderStatus.fromValue('draft'), RepairOrderStatus.accepted);
      expect(
        RepairOrderStatus.fromValue('inProgress'),
        RepairOrderStatus.inRepair,
      );
      expect(
        RepairOrderStatus.fromValue('completed'),
        RepairOrderStatus.delivered,
      );
    });

    test('cancelled does not count for finance', () {
      expect(RepairOrderStatus.cancelled.countsForFinance, isFalse);
      expect(RepairOrderStatus.readyForDelivery.countsForFinance, isTrue);
      expect(RepairOrderStatus.delivered.countsForFinance, isTrue);
      expect(RepairOrderStatus.inRepair.countsForFinance, isFalse);
    });
  });
}
