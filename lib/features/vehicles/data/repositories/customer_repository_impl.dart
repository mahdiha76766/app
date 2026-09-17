import '../../../../core/database/app_database.dart';
import '../../../../core/database/mappers.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<Customer?> getById(String id) async {
    final row = await (_db.select(_db.customers)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<void> upsert(Customer customer) async {
    await _db
        .into(_db.customers)
        .insertOnConflictUpdate(customer.toCompanion());
  }
}
