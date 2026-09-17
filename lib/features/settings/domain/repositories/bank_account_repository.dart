import '../entities/bank_account.dart';

abstract class BankAccountRepository {
  Future<List<BankAccount>> listForWorkshop(String workshopId);

  Future<void> upsert(BankAccount account);

  Future<void> delete(String id);
}
