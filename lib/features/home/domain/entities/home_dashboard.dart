import 'active_repair.dart';
import 'recent_visit.dart';

class HomeDashboard {
  const HomeDashboard({
    required this.todayVehicleCount,
    required this.todayIncome,
    required this.dueReminderCount,
    required this.unpaidDebtCount,
    required this.activeRepairs,
    required this.recentVisits,
  });

  final int todayVehicleCount;
  final int todayIncome;
  final int dueReminderCount;

  /// تعداد سفارش‌های تکمیل‌شده با وضعیت بدهکار یا پرداخت جزئی.
  final int unpaidDebtCount;
  final List<ActiveRepair> activeRepairs;
  final List<RecentVisit> recentVisits;

  static const empty = HomeDashboard(
    todayVehicleCount: 0,
    todayIncome: 0,
    dueReminderCount: 0,
    unpaidDebtCount: 0,
    activeRepairs: [],
    recentVisits: [],
  );
}
