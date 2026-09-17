import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/iranian_plate_input.dart';
import '../data/providers.dart';
import '../domain/entities/new_vehicle_plate_args.dart';

/// جستجوی پلاک و هدایت به جزئیات یا فرم خودرو جدید.
Future<void> navigateForPlateLookup({
  required WidgetRef ref,
  required GoRouter router,
  required IranianPlateValue plate,
}) async {
  final normalized = plate.normalized;
  if (normalized.isEmpty) {
    throw StateError('پلاک نامعتبر است.');
  }

  final vehicles = ref.read(vehicleRepositoryProvider);
  final existing = await vehicles.findByPlateNormalized(normalized);

  if (existing != null) {
    router.push('/vehicle/${existing.id}?fromScan=1');
    return;
  }

  router.push(
    '/vehicle/new',
    extra: NewVehiclePlateArgs(
      plateNormalized: normalized,
      plateDisplay: plate.display,
    ),
  );
}
