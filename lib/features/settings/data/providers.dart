import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/bank_account.dart';
import '../domain/entities/workshop.dart';
import '../domain/repositories/bank_account_repository.dart';
import '../domain/repositories/workshop_repository.dart';
import 'repositories/bank_account_repository_impl.dart';
import 'repositories/workshop_repository_impl.dart';

final workshopRepositoryProvider = Provider<WorkshopRepository>((ref) {
  return WorkshopRepositoryImpl(ref.watch(appDatabaseProvider));
});

final workshopProvider = FutureProvider<Workshop?>((ref) async {
  return ref.watch(workshopRepositoryProvider).getWorkshop();
});

final bankAccountRepositoryProvider = Provider<BankAccountRepository>((ref) {
  return BankAccountRepositoryImpl(ref.watch(appDatabaseProvider));
});

final bankAccountsProvider =
    FutureProvider.autoDispose<List<BankAccount>>((ref) async {
  final workshop = await ref.watch(workshopProvider.future);
  if (workshop == null) {
    return const [];
  }
  return ref
      .watch(bankAccountRepositoryProvider)
      .listForWorkshop(workshop.id);
});

final appDatabaseForSettingsProvider = Provider<AppDatabase>((ref) {
  return ref.watch(appDatabaseProvider);
});
