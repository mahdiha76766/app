import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mechanic_assistant/features/assistant/data/services/http_assistant_api_client.dart';
import 'package:mechanic_assistant/features/assistant/domain/entities/assistant_models.dart';
import 'package:mechanic_assistant/features/assistant/domain/repositories/assistant_api_client.dart';

void main() {
  test('HttpAssistantApiClient parses structured reply', () async {
    final client = HttpAssistantApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        expect(request.headers['X-Device-Id'], 'device-1');
        return http.Response(
          jsonEncode({
            'reply': {
              'summary': 'احتمال مشکل احتراق',
              'possibleCauses': [
                {
                  'title': 'شمع ضعیف',
                  'likelihood': 'high',
                  'reason': 'ریپ در شتاب‌گیری',
                },
              ],
              'followUpQuestions': ['آیا چک‌انجین روشن است؟'],
              'recommendedTests': ['تست جرقه'],
              'urgency': 'inspect_soon',
              'safetyWarning': 'در صورت لرزش شدید توقف کنید',
              'disclaimer': 'تشخیص نهایی باید توسط تعمیرکار انجام شود',
            },
            'remaining': 9,
            'dailyLimit': 10,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final result = await client.ask(
      deviceId: 'device-1',
      question: 'موتور ریپ می‌زند',
      vehicleContext: const AssistantVehicleContext(vehicleModel: 'پژو ۲۰۶'),
      recentMessages: const [],
    );
    expect(result.remaining, 9);
    expect(result.reply.possibleCauses.first.likelihood, 'high');
  });

  test('HttpAssistantApiClient maps quota exceeded', () async {
    final client = HttpAssistantApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {
              'code': 'quota_exceeded',
              'message': 'سهمیه تمام شد',
            },
            'remaining': 0,
            'dailyLimit': 10,
          }),
          429,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    expect(
      () => client.ask(
        deviceId: 'device-1',
        question: 'سوال',
        vehicleContext: const AssistantVehicleContext(),
        recentMessages: const [],
      ),
      throwsA(
        isA<AssistantApiException>().having((e) => e.isQuota, 'quota', isTrue),
      ),
    );
  });
}
