import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/database/app_database.dart';
import 'package:mechanic_assistant/core/database/enums.dart';
import 'package:mechanic_assistant/features/assistant/data/repositories/assistant_chat_repository_impl.dart';
import 'package:mechanic_assistant/features/assistant/domain/entities/assistant_models.dart';
import 'package:mechanic_assistant/features/assistant/domain/services/assistant_context_builder.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_order.dart';
import 'package:mechanic_assistant/features/repair_orders/domain/entities/repair_service.dart';
import 'package:mechanic_assistant/features/vehicles/domain/entities/vehicle.dart';

void main() {
  late AppDatabase db;
  late AssistantChatRepositoryImpl repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = AssistantChatRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('stores and loads assistant conversation for repair', () async {
    final now = DateTime(2026, 7, 24);
    await db.into(db.vehicles).insert(
          VehiclesCompanion.insert(
            id: 'v1',
            plateNormalized: '12-B-345-67',
            plateDisplay: '۱۲ ب ۳۴۵ ایران ۶۷',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db.into(db.repairOrders).insert(
          RepairOrdersCompanion.insert(
            id: 'r1',
            vehicleId: 'v1',
            status: RepairOrderStatus.inRepair.value,
            paymentStatus: PaymentStatus.unpaid.value,
            createdAt: now,
          ),
        );

    await repo.appendUserMessage(
      id: 'm1',
      repairOrderId: 'r1',
      content: 'موتور داغ می‌کند',
      createdAt: now,
    );
    await repo.appendAssistantMessage(
      id: 'm2',
      repairOrderId: 'r1',
      createdAt: now.add(const Duration(seconds: 1)),
      reply: const AssistantReply(
        summary: 'احتمال مشکل خنک‌کاری',
        possibleCauses: [
          AssistantCause(
            title: 'کمبود آب رادیاتور',
            likelihood: 'medium',
            reason: 'داغ شدن در ترافیک',
          ),
        ],
        followUpQuestions: ['آیا فن روشن می‌شود؟'],
        recommendedTests: ['بررسی سطح آب'],
        urgency: 'inspect_soon',
        safetyWarning: 'در صورت بخار توقف کنید',
        disclaimer: 'تشخیص نهایی باید توسط تعمیرکار انجام شود',
      ),
    );

    final messages = await repo.listForRepair('r1');
    expect(messages, hasLength(2));
    expect(messages.first.content, 'موتور داغ می‌کند');
    expect(messages.last.reply?.summary, contains('خنک'));
  });

  test('context builder omits plate and customer PII', () {
    final order = RepairOrder(
      id: 'r1',
      vehicleId: 'v1',
      status: RepairOrderStatus.inRepair,
      complaintText: 'صدای جلوبندی',
      mileage: 90000,
      laborAmount: 0,
      discountAmount: 0,
      paymentStatus: PaymentStatus.unpaid,
      paidAmount: 0,
      createdAt: DateTime(2026, 7, 24),
    );
    final vehicle = Vehicle(
      id: 'v1',
      customerId: 'secret-customer',
      plateNormalized: 'SECRET-PLATE',
      plateDisplay: 'پلاک محرمانه',
      manufacturer: 'پژو',
      model: '۲۰۶',
      lastMileage: 90000,
      createdAt: DateTime(2026, 7, 1),
      updatedAt: DateTime(2026, 7, 1),
    );
    final ctx = AssistantContextBuilder.build(
      vehicle: vehicle,
      order: order,
      services: [
        RepairService(
          id: 's1',
          repairOrderId: 'r1',
          title: 'جلوبندی',
          amount: 0,
          createdAt: DateTime(2026, 7, 24),
        ),
      ],
      recentOrders: const [],
      servicesByOrderId: const {},
    );
    final encoded = ctx.toJson().toString();
    expect(encoded.contains('SECRET'), isFalse);
    expect(encoded.contains('secret-customer'), isFalse);
    expect(encoded.contains('پلاک'), isFalse);
    expect(ctx.vehicleModel, 'پژو ۲۰۶');
    expect(ctx.complaint, 'صدای جلوبندی');
  });
}
