import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/messaging/domain/entities/repair_ready_message_input.dart';
import 'package:mechanic_assistant/features/messaging/domain/services/repair_ready_message_composer.dart';

void main() {
  group('RepairReadyMessageComposer', () {
    test('پیام کامل با گروه‌های خدمت و قطعه', () {
      final text = RepairReadyMessageComposer.compose(
        const RepairReadyMessageInput(
          customerName: 'علی رضایی',
          vehicleModel: 'پژو ۲۰۶',
          serviceGroups: [
            MessageServiceGroup(
              serviceTitle: 'جلوبندی',
              parts: [
                MessagePartLine(
                  title: 'طبق جلو',
                  quantity: 1,
                  unitPrice: 1000000,
                  lineTotal: 1000000,
                ),
                MessagePartLine(
                  title: 'سیبک',
                  quantity: 2,
                  unitPrice: 500000,
                  lineTotal: 1000000,
                ),
              ],
            ),
          ],
          grandTotalToman: 3200000,
          workshopName: 'تعمیرگاه نمونه',
          laborAmount: 1200000,
        ),
      );

      expect(text, contains('سلام علی رضایی'));
      expect(text, contains('خودروی پژو ۲۰۶ شما آماده تحویل است.'));
      expect(text, contains('▸ جلوبندی'));
      expect(text, contains('• طبق جلو'));
      expect(text, contains('• سیبک'));
      expect(text, contains('۳٬۲۰۰٬۰۰۰ تومان'));
      expect(text, contains('تعمیرگاه نمونه'));
      expect(text, isNot(contains('مشتری عزیز')));
    });

    test('جزئیات قیمت وقتی فعال باشد در پیام می‌آید', () {
      final text = RepairReadyMessageComposer.compose(
        const RepairReadyMessageInput(
          customerName: 'رضا',
          vehicleModel: 'دنا',
          serviceGroups: [
            MessageServiceGroup(
              serviceTitle: 'سرویس دوره‌ای',
              parts: [
                MessagePartLine(
                  title: 'تسمه تایم',
                  quantity: 1,
                  unitPrice: 800000,
                  lineTotal: 800000,
                ),
              ],
            ),
          ],
          grandTotalToman: 1500000,
          workshopName: 'نیدی‌کار',
          laborAmount: 700000,
          includePriceDetails: true,
        ),
      );

      expect(text, contains('جزئیات مبلغ:'));
      expect(text, contains('اجرت'));
      expect(text, contains('تسمه تایم'));
      expect(text, contains('۸۰۰٬۰۰۰'));
    });

    test('زمان تحویل در پیام می‌آید', () {
      final text = RepairReadyMessageComposer.compose(
        RepairReadyMessageInput(
          customerName: 'سارا',
          vehicleModel: 'پراید',
          serviceGroups: const [],
          grandTotalToman: 500000,
          workshopName: 'تعمیرگاه',
          deliveryLine: RepairReadyMessageComposer.formatDeliveryLine(
            DateTime(2026, 7, 22, 17),
          ),
        ),
      );

      expect(text, contains('زمان تحویل:'));
      expect(text, contains('عصر ساعت ۱۷'));
    });

    test('یادآوری در متن پیام می‌آید', () {
      final text = RepairReadyMessageComposer.compose(
        const RepairReadyMessageInput(
          customerName: 'رضا',
          vehicleModel: 'دنا',
          serviceGroups: [
            MessageServiceGroup(serviceTitle: 'سرویس دوره‌ای'),
          ],
          grandTotalToman: 1000000,
          workshopName: 'نیدی‌کار',
          reminderLines: ['تسمه تایم — ۲۰۰ کیلومتر دیگر'],
        ),
      );

      expect(text, contains('یادآوری سرویس:'));
      expect(text, contains('• تسمه تایم — ۲۰۰ کیلومتر دیگر'));
    });

    test('نام خالی به مشتری عزیز تبدیل می‌شود', () {
      final text = RepairReadyMessageComposer.compose(
        const RepairReadyMessageInput(
          customerName: '   ',
          vehicleModel: 'پراید',
          serviceGroups: [],
          grandTotalToman: 500000,
          workshopName: '',
        ),
      );

      expect(text, contains('سلام مشتری عزیز'));
      expect(text, contains('خدمات و قطعات:\nثبت نشده'));
      expect(text, contains('تعمیرگاه: تعمیرگاه'));
    });
  });
}
