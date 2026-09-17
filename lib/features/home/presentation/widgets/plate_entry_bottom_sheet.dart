import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/iranian_plate_input.dart';
import '../../../vehicles/data/providers.dart';
import '../../../vehicles/domain/entities/new_vehicle_plate_args.dart';

Future<void> showPlateEntryBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const PlateSearchSheet(),
  );
}

/// شیت قابل‌استفاده برای ورود پلاک و جستجوی خودرو.
class PlateSearchSheet extends ConsumerStatefulWidget {
  const PlateSearchSheet({super.key});

  @override
  ConsumerState<PlateSearchSheet> createState() => _PlateSearchSheetState();
}

class _PlateSearchSheetState extends ConsumerState<PlateSearchSheet> {
  IranianPlateValue _plate = const IranianPlateValue();
  String? _errorText;
  bool _isSearching = false;

  Future<void> _search() async {
    if (!_plate.isComplete) {
      setState(() => _errorText = 'لطفاً همه بخش‌های پلاک را کامل کنید.');
      return;
    }

    final normalized = _plate.normalized;
    if (normalized.isEmpty) {
      setState(() => _errorText = 'پلاک واردشده معتبر نیست.');
      return;
    }

    setState(() {
      _errorText = null;
      _isSearching = true;
    });

    try {
      final router = GoRouter.of(context);
      final display = _plate.display;
      final vehicles = ref.read(vehicleRepositoryProvider);
      final existing = await vehicles.findByPlateNormalized(normalized);

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();

      if (existing != null) {
        router.push('/vehicle/${existing.id}');
      } else {
        router.push(
          '/vehicle/new',
          extra: NewVehiclePlateArgs(
            plateNormalized: normalized,
            plateDisplay: display,
          ),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSearching = false;
        _errorText = 'خطا در جستجوی خودرو. دوباره تلاش کنید.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'ورود دستی پلاک',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'هر بخش را جداگانه لمس کنید',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            IranianPlateInput(
              initialValue: _plate,
              onChanged: (value) {
                setState(() {
                  _plate = value;
                  _errorText = null;
                });
              },
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isSearching ? null : _search,
              child: _isSearching
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Text('جستجوی خودرو'),
            ),
          ],
        ),
      ),
    );
  }
}
