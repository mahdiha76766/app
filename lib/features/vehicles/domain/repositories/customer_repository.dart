import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<Customer?> getById(String id);

  Future<void> upsert(Customer customer);
}
