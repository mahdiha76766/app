import '../../../../core/database/enums.dart';

class InvalidRepairTransitionException implements Exception {
  InvalidRepairTransitionException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// قوانین انتقال وضعیت تعمیر.
abstract final class RepairWorkflow {
  static const _allowed = <RepairOrderStatus, Set<RepairOrderStatus>>{
    RepairOrderStatus.accepted: {
      RepairOrderStatus.awaitingReview,
      RepairOrderStatus.inRepair,
      RepairOrderStatus.waitingForParts,
      RepairOrderStatus.cancelled,
    },
    RepairOrderStatus.awaitingReview: {
      RepairOrderStatus.inRepair,
      RepairOrderStatus.waitingForParts,
      RepairOrderStatus.cancelled,
    },
    RepairOrderStatus.inRepair: {
      RepairOrderStatus.waitingForParts,
      RepairOrderStatus.readyForDelivery,
      RepairOrderStatus.awaitingReview,
      RepairOrderStatus.cancelled,
    },
    RepairOrderStatus.waitingForParts: {
      RepairOrderStatus.inRepair,
      RepairOrderStatus.readyForDelivery,
      RepairOrderStatus.cancelled,
    },
    RepairOrderStatus.readyForDelivery: {
      RepairOrderStatus.delivered,
      RepairOrderStatus.inRepair,
      RepairOrderStatus.cancelled,
    },
    RepairOrderStatus.delivered: {},
    RepairOrderStatus.cancelled: {},
  };

  static bool canTransition(RepairOrderStatus from, RepairOrderStatus to) {
    if (from == to) {
      return true;
    }
    return _allowed[from]?.contains(to) ?? false;
  }

  static void ensureCanTransition(RepairOrderStatus from, RepairOrderStatus to) {
    if (!canTransition(from, to)) {
      throw InvalidRepairTransitionException(
        'انتقال از «${from.labelFa}» به «${to.labelFa}» مجاز نیست.',
      );
    }
  }

  static Set<RepairOrderStatus> nextStatuses(RepairOrderStatus from) {
    return {...?_allowed[from]};
  }

  static bool requiresConfirm(RepairOrderStatus to) {
    return to == RepairOrderStatus.cancelled ||
        to == RepairOrderStatus.delivered;
  }
}
