import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_scaffold.dart';
import '../../features/assistant/presentation/assistant_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/plate_scanner/presentation/confirm_plate_screen.dart';
import '../../features/plate_scanner/presentation/scan_plate_screen.dart';
import '../../features/plate_scanner/domain/entities/plate_recognition_result.dart';
import '../../features/finance/presentation/finance_dashboard_page.dart';
import '../../features/invoices/presentation/invoice_detail_page.dart';
import '../../features/invoices/presentation/invoices_page.dart';
import '../../features/messaging/presentation/repair_message_preview_page.dart';
import '../../features/reminders/presentation/add_reminder_page.dart';
import '../../features/reminders/presentation/reminders_page.dart';
import '../../features/repair_orders/presentation/new_repair_page.dart';
import '../../features/repair_orders/presentation/repair_intake_page.dart';
import '../../features/vehicles/presentation/edit_vehicle_page.dart';
import '../../features/repair_orders/presentation/repair_parts_page.dart';
import '../../features/repair_orders/presentation/repair_summary_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/vehicles/domain/entities/new_vehicle_plate_args.dart';
import '../../features/vehicles/presentation/new_vehicle_page.dart';
import '../../features/vehicles/presentation/vehicle_detail_page.dart';
import '../../features/vehicles/presentation/vehicles_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/vehicles',
            name: 'vehicles',
            builder: (context, state) => const VehiclesPage(),
          ),
          GoRoute(
            path: '/reminders',
            name: 'reminders',
            builder: (context, state) => const RemindersPage(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/finance',
        name: 'finance',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FinanceDashboardPage(),
      ),
      GoRoute(
        path: '/invoices',
        name: 'invoices',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const InvoicesPage(),
      ),
      GoRoute(
        path: '/invoices/:repairOrderId',
        name: 'invoiceDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['repairOrderId'] ?? '';
          return InvoiceDetailPage(repairOrderId: id);
        },
      ),
      GoRoute(
        path: '/scan',
        name: 'scan',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ScanPlateScreen(),
      ),
      GoRoute(
        path: '/scan/confirm',
        name: 'scanConfirm',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! PlateRecognitionResult) {
            return const Scaffold(
              body: Center(child: Text('نتیجه تشخیص پلاک نامعتبر است.')),
            );
          }
          return ConfirmPlateScreen(result: extra);
        },
      ),
      GoRoute(
        path: '/vehicle/new',
        name: 'newVehicle',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra;
          if (args is! NewVehiclePlateArgs) {
            return const Scaffold(
              body: Center(child: Text('اطلاعات پلاک نامعتبر است.')),
            );
          }
          return NewVehiclePage(args: args);
        },
      ),
      GoRoute(
        path: '/vehicle/:vehicleId/edit',
        name: 'editVehicle',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId'] ?? '';
          return EditVehiclePage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: '/vehicle/:vehicleId',
        name: 'vehicleDetail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId'] ?? '';
          final fromScan = state.uri.queryParameters['fromScan'] == '1';
          return VehicleDetailPage(
            vehicleId: vehicleId,
            showScanSuccess: fromScan,
          );
        },
      ),
      GoRoute(
        path: '/repair/new/:vehicleId',
        name: 'newRepair',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId'] ?? '';
          return NewRepairPage(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: '/repair/:repairId/intake',
        name: 'repairIntake',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repairId = state.pathParameters['repairId'] ?? '';
          return RepairIntakePage(repairId: repairId);
        },
      ),
      GoRoute(
        path: '/repair/:repairId/parts',
        name: 'repairParts',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repairId = state.pathParameters['repairId'] ?? '';
          return RepairPartsPage(repairId: repairId);
        },
      ),
      GoRoute(
        path: '/repair/:repairId/summary',
        name: 'repairSummary',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repairId = state.pathParameters['repairId'] ?? '';
          return RepairSummaryPage(repairId: repairId);
        },
      ),
      GoRoute(
        path: '/repair/:repairId/assistant',
        name: 'repairAssistant',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repairId = state.pathParameters['repairId'] ?? '';
          return AssistantPage(repairId: repairId);
        },
      ),
      GoRoute(
        path: '/repair/:repairId/message',
        name: 'repairMessage',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repairId = state.pathParameters['repairId'] ?? '';
          return RepairMessagePreviewPage(repairId: repairId);
        },
      ),
      GoRoute(
        path: '/repair/:repairId/reminder',
        name: 'addRepairReminder',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final repairId = state.pathParameters['repairId'] ?? '';
          return AddReminderPage(repairId: repairId);
        },
      ),
      GoRoute(
        path: '/vehicle/:vehicleId/reminder',
        name: 'addVehicleReminder',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId'] ?? '';
          return AddReminderPage(vehicleId: vehicleId);
        },
      ),
    ],
  );
});
