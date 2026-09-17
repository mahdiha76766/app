/// تنظیمات کلاینت دستیار — بدون API Key.
abstract final class AssistantConfig {
  /// از `--dart-define=ASSISTANT_API_BASE_URL=http://IP:8787` خوانده می‌شود.
  static const String apiBaseUrl = String.fromEnvironment(
    'ASSISTANT_API_BASE_URL',
    defaultValue: 'http://10.156.88.192:8787',
  );

  static const int maxQuestionChars = 500;
  static const int recentMessagePairs = 3;
}
