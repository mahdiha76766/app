import '../entities/finance_snapshot.dart';

abstract class FinanceRepository {
  Future<FinanceSnapshot> getSnapshot({
    required DateTime from,
    required DateTime to,
  });
}
