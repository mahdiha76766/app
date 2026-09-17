import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/bank_account.dart';
import '../../domain/repositories/bank_account_repository.dart';

class BankAccountRepositoryImpl implements BankAccountRepository {
  BankAccountRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<BankAccount>> listForWorkshop(String workshopId) async {
    final rows = await (_db.select(_db.bankAccounts)
          ..where((t) => t.workshopId.equals(workshopId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.sortOrder),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
        .get();
    return rows
        .map(
          (row) => BankAccount(
            id: row.id,
            workshopId: row.workshopId,
            bankName: row.bankName,
            accountHolderName: row.accountHolderName,
            accountNumber: row.accountNumber,
            cardNumber: row.cardNumber,
            sortOrder: row.sortOrder,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> upsert(BankAccount account) async {
    await _db.into(_db.bankAccounts).insertOnConflictUpdate(
          BankAccountsCompanion.insert(
            id: account.id,
            workshopId: account.workshopId,
            bankName: account.bankName,
            accountHolderName: Value(account.accountHolderName),
            accountNumber: Value(account.accountNumber),
            cardNumber: Value(account.cardNumber),
            sortOrder: Value(account.sortOrder),
            createdAt: account.createdAt,
          ),
        );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.bankAccounts)..where((t) => t.id.equals(id))).go();
  }
}
