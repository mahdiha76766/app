import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/finance_snapshot.dart';
import '../domain/repositories/finance_repository.dart';
import 'repositories/finance_repository_impl.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  return FinanceRepositoryImpl(ref.watch(appDatabaseProvider));
});

class FinanceQuery {
  const FinanceQuery({
    required this.period,
    required this.from,
    required this.to,
  });

  final FinancePeriod period;
  final DateTime from;
  final DateTime to;
}

final financeQueryProvider =
    StateProvider<FinanceQuery>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return FinanceQuery(
    period: FinancePeriod.month,
    from: DateTime(today.year, today.month, 1),
    to: today,
  );
});

final financeSnapshotProvider =
    FutureProvider.autoDispose<FinanceSnapshot>((ref) async {
  final query = ref.watch(financeQueryProvider);
  return ref.watch(financeRepositoryProvider).getSnapshot(
        from: query.from,
        to: query.to,
      );
});
