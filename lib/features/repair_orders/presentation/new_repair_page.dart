import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/enums.dart';
import '../../vehicles/data/providers.dart';
import '../data/providers.dart';
import '../domain/entities/repair_order.dart';

/// سازگاری مسیر قدیمی: draft می‌سازد و به صفحه پذیرش می‌رود.
class NewRepairPage extends ConsumerStatefulWidget {
  const NewRepairPage({
    super.key,
    required this.vehicleId,
  });

  final String vehicleId;

  @override
  ConsumerState<NewRepairPage> createState() => _NewRepairPageState();
}

class _NewRepairPageState extends ConsumerState<NewRepairPage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      final vehicle =
          await ref.read(vehicleRepositoryProvider).getById(widget.vehicleId);
      if (vehicle == null) {
        setState(() => _error = 'خودرو پیدا نشد.');
        return;
      }
      final repairId = const Uuid().v4();
      await ref.read(repairOrderRepositoryProvider).create(
            RepairOrder(
              id: repairId,
              vehicleId: vehicle.id,
              customerId: vehicle.customerId,
              status: RepairOrderStatus.accepted,
              laborAmount: 0,
              discountAmount: 0,
              paymentStatus: PaymentStatus.unpaid,
              paidAmount: 0,
              createdAt: DateTime.now(),
            ),
          );
      if (!mounted) {
        return;
      }
      context.go('/repair/$repairId/intake');
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _error = 'ایجاد پذیرش با خطا مواجه شد.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: const AppPageAppBar(title: 'پذیرش'),
        body: Center(child: Text(_error!)),
      );
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
