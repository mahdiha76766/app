import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mechanic_assistant/app/theme/app_theme.dart';
import 'package:mechanic_assistant/core/widgets/app_scaffold.dart';
import 'package:mechanic_assistant/core/widgets/iranian_plate_input.dart';
import 'package:mechanic_assistant/features/home/data/providers.dart';
import 'package:mechanic_assistant/features/home/domain/entities/home_dashboard.dart';
import 'package:mechanic_assistant/features/home/domain/entities/recent_visit.dart';
import 'package:mechanic_assistant/features/home/domain/repositories/home_repository.dart';
import 'package:mechanic_assistant/features/home/presentation/home_page.dart';
import 'package:mechanic_assistant/features/settings/data/providers.dart';
import 'package:mechanic_assistant/features/settings/domain/entities/workshop.dart';

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository({
    required this.dashboard,
    this.error,
    this.completer,
  });

  final HomeDashboard dashboard;
  final Object? error;
  final Completer<HomeDashboard>? completer;

  @override
  Future<HomeDashboard> getDashboard({DateTime? now}) {
    if (completer != null) {
      return completer!.future;
    }
    if (error != null) {
      return Future.error(error!);
    }
    return Future.value(dashboard);
  }
}

Widget _buildTestApp({
  required HomeRepository repository,
  ValueChanged<GoRouter>? onRouterCreated,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('صفحه اسکن تست')),
        ),
      ),
    ],
  );
  onRouterCreated?.call(router);

  return ProviderScope(
    overrides: [
      homeRepositoryProvider.overrideWithValue(repository),
      workshopProvider.overrideWith(
        (ref) async => Workshop(
          id: 'ws-1',
          name: 'تعمیرگاه من',
          mechanicName: 'علی مکانیک',
          createdAt: DateTime(2026, 1, 1),
        ),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light(),
      locale: const Locale('fa', 'IR'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: router,
    ),
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  final sampleVisit = RecentVisit(
    repairOrderId: 'ro-1',
    vehicleId: 'veh-1',
    vehicleModel: 'پژو ۲۰۶',
    serviceType: 'تعویض لنت',
    invoiceTotal: 3200000,
    visitDate: DateTime(2026, 7, 20),
  );

  testWidgets('صفحه اصلی عنوان، سلام و دکمه‌ها را نشان می‌دهد', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(dashboard: HomeDashboard.empty),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعمیرگاه من'), findsOneWidget);
    expect(find.text('سلام، علی مکانیک'), findsOneWidget);
    expect(find.text('اسکن پلاک'), findsOneWidget);
    expect(find.text('ورود دستی پلاک'), findsOneWidget);
    expect(find.text('خودروهای امروز'), findsOneWidget);
    expect(find.text('دریافت امروز'), findsOneWidget);
    expect(find.text('یادآوری‌ها'), findsOneWidget);
    expect(find.text('خانه'), findsOneWidget);
  });

  testWidgets('حالت خالی آخرین مراجعه‌ها نمایش داده می‌شود', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(dashboard: HomeDashboard.empty),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('هنوز مراجعه‌ای ثبت نشده است'), findsOneWidget);
  });

  testWidgets('آخرین مراجعه‌ها را با مبلغ فارسی نشان می‌دهد', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(
          dashboard: HomeDashboard(
            todayVehicleCount: 2,
            todayIncome: 1500000,
            dueReminderCount: 1,
            unpaidDebtCount: 0,
            activeRepairs: const [],
            recentVisits: [sampleVisit],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('پژو ۲۰۶'), findsOneWidget);
    expect(find.text('تعویض لنت'), findsOneWidget);
    expect(find.text('۳٬۲۰۰٬۰۰۰ تومان'), findsOneWidget);
    expect(find.text('۱۴۰۵/۰۴/۲۹'), findsOneWidget);
    expect(find.text('۲'), findsOneWidget);
    expect(find.text('۱'), findsOneWidget);
  });

  testWidgets('حالت خطا و تلاش مجدد را نشان می‌دهد', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(
          dashboard: HomeDashboard.empty,
          error: Exception('fail'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('خطا در دریافت اطلاعات صفحه اصلی'), findsOneWidget);
    expect(find.text('تلاش مجدد'), findsOneWidget);
  });

  testWidgets('حالت بارگذاری را نشان می‌دهد', (tester) async {
    final completer = Completer<HomeDashboard>();
    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(
          dashboard: HomeDashboard.empty,
          completer: completer,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('در حال بارگذاری...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(HomeDashboard.empty);
    await tester.pumpAndSettle();
  });

  testWidgets('دکمه اسکن پلاک به /scan می‌رود', (tester) async {
    late GoRouter router;
    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(dashboard: HomeDashboard.empty),
        onRouterCreated: (value) => router = value,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.photo_camera_outlined));
    await tester.pump();

    expect(router.state.uri.path, '/scan');
  });

  testWidgets('دکمه ورود دستی پلاک bottom sheet را باز می‌کند', (tester) async {
    await tester.pumpWidget(
      _buildTestApp(
        repository: _FakeHomeRepository(dashboard: HomeDashboard.empty),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('ورود دستی پلاک'));
    await tester.pumpAndSettle();

    expect(find.text('هر بخش را جداگانه لمس کنید'), findsOneWidget);
    expect(find.text('جستجوی خودرو'), findsOneWidget);
    expect(find.byType(IranianPlateInput), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
  });
}
