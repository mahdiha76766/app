import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/enums.dart';
import '../domain/entities/invoice_list_item.dart';
import '../domain/entities/payment_transaction.dart';
import '../domain/repositories/invoice_repository.dart';
import 'repositories/invoice_repository_impl.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(ref.watch(appDatabaseProvider));
});

class InvoiceListQuery {
  const InvoiceListQuery({
    this.search = '',
    this.paymentStatus,
    this.from,
    this.to,
  });

  final String search;
  final PaymentStatus? paymentStatus;
  final DateTime? from;
  final DateTime? to;

  InvoiceListQuery copyWith({
    String? search,
    PaymentStatus? paymentStatus,
    DateTime? from,
    DateTime? to,
    bool clearPaymentStatus = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    return InvoiceListQuery(
      search: search ?? this.search,
      paymentStatus:
          clearPaymentStatus ? null : (paymentStatus ?? this.paymentStatus),
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
    );
  }
}

final invoiceListQueryProvider =
    StateProvider<InvoiceListQuery>((ref) => const InvoiceListQuery());

final invoiceListProvider =
    FutureProvider.autoDispose<List<InvoiceListItem>>((ref) async {
  final query = ref.watch(invoiceListQueryProvider);
  return ref.watch(invoiceRepositoryProvider).listInvoices(
        query: query.search,
        paymentStatus: query.paymentStatus,
        from: query.from,
        to: query.to,
      );
});

final invoiceDetailProvider =
    FutureProvider.autoDispose.family<InvoiceListItem?, String>((ref, id) {
  return ref.watch(invoiceRepositoryProvider).getInvoiceItem(id);
});

final invoicePaymentsProvider = FutureProvider.autoDispose
    .family<List<PaymentTransaction>, String>((ref, repairOrderId) {
  return ref.watch(invoiceRepositoryProvider).listPayments(repairOrderId);
});
