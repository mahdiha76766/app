import '../entities/assistant_models.dart';

class AssistantApiException implements Exception {
  AssistantApiException({
    required this.code,
    required this.message,
    this.remaining,
    this.dailyLimit,
  });

  final String code;
  final String message;
  final int? remaining;
  final int? dailyLimit;

  bool get isOffline =>
      code == 'offline' || code == 'network' || code == 'timeout';
  bool get isQuota => code == 'quota_exceeded';
  bool get isRateLimited => code == 'rate_limited';

  @override
  String toString() => message;
}

class AssistantAskResult {
  const AssistantAskResult({
    required this.reply,
    required this.remaining,
    required this.dailyLimit,
  });

  final AssistantReply reply;
  final int remaining;
  final int dailyLimit;
}

abstract class AssistantApiClient {
  Future<AssistantAskResult> ask({
    required String deviceId,
    required String question,
    required AssistantVehicleContext vehicleContext,
    required List<Map<String, String>> recentMessages,
  });
}
