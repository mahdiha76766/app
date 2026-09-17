import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../domain/entities/assistant_models.dart';
import '../../domain/repositories/assistant_api_client.dart';
import '../assistant_config.dart';

class HttpAssistantApiClient implements AssistantApiClient {
  HttpAssistantApiClient({
    http.Client? client,
    String? baseUrl,
    this._timeout = const Duration(seconds: 45),
  })  : _client = client ?? http.Client(),
        _baseUrl =
            (baseUrl ?? AssistantConfig.apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;

  @override
  Future<AssistantAskResult> ask({
    required String deviceId,
    required String question,
    required AssistantVehicleContext vehicleContext,
    required List<Map<String, String>> recentMessages,
  }) async {
    final uri = Uri.parse('$_baseUrl/v1/assistant/ask');
    try {
      final response = await _client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'X-Device-Id': deviceId,
            },
            body: jsonEncode({
              'question': question,
              'vehicleContext': vehicleContext.toJson(),
              'recentMessages': recentMessages,
            }),
          )
          .timeout(_timeout);

      final body = response.body.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final replyJson = body['reply'];
        if (replyJson is! Map) {
          throw AssistantApiException(
            code: 'invalid_output',
            message: 'پاسخ نامعتبر از سرور دریافت شد.',
          );
        }
        return AssistantAskResult(
          reply: AssistantReply.fromJson(Map<String, dynamic>.from(replyJson)),
          remaining: (body['remaining'] as num?)?.toInt() ?? 0,
          dailyLimit: (body['dailyLimit'] as num?)?.toInt() ?? 10,
        );
      }

      final error = body['error'];
      final code = error is Map
          ? (error['code'] as String? ?? 'server_error')
          : 'server_error';
      final message = error is Map
          ? (error['message'] as String? ?? 'خطای سرور')
          : 'خطای سرور (${response.statusCode})';
      throw AssistantApiException(
        code: code,
        message: message,
        remaining: (body['remaining'] as num?)?.toInt(),
        dailyLimit: (body['dailyLimit'] as num?)?.toInt(),
      );
    } on TimeoutException {
      throw AssistantApiException(
        code: 'timeout',
        message: 'پاسخ سرور طول کشید. اتصال اینترنت را بررسی کنید.',
      );
    } on SocketException {
      throw AssistantApiException(
        code: 'offline',
        message:
            'اتصال به اینترنت یا سرور دستیار برقرار نیست. امکانات آفلاین برنامه همچنان در دسترس‌اند.',
      );
    } on http.ClientException {
      throw AssistantApiException(
        code: 'network',
        message:
            'خطای شبکه در ارتباط با دستیار. امکانات آفلاین برنامه مختل نمی‌شوند.',
      );
    } on AssistantApiException {
      rethrow;
    } on FormatException {
      throw AssistantApiException(
        code: 'invalid_output',
        message: 'پاسخ سرور قابل خواندن نبود.',
      );
    }
  }
}
