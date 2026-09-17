import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mechanic_assistant/app/app.dart';
import 'package:mechanic_assistant/features/home/data/providers.dart';
import 'package:mechanic_assistant/features/home/domain/entities/home_dashboard.dart';
import 'package:mechanic_assistant/features/home/domain/repositories/home_repository.dart';
import 'package:mechanic_assistant/features/settings/data/providers.dart';
import 'package:mechanic_assistant/features/settings/domain/entities/workshop.dart';

class _EmptyHomeRepository implements HomeRepository {
  @override
  Future<HomeDashboard> getDashboard({DateTime? now}) async {
    return HomeDashboard.empty;
  }
}

void main() {
  testWidgets('اپ با صفحه خانه فارسی بارگذاری می‌شود', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(_EmptyHomeRepository()),
          workshopProvider.overrideWith(
            (ref) async => Workshop(
              id: 'ws-1',
              name: 'تعمیرگاه من',
              createdAt: DateTime(2026, 1, 1),
            ),
          ),
        ],
        child: const MechanicAssistantApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعمیرگاه من'), findsOneWidget);
    expect(find.text('خانه'), findsWidgets);
  });
}
