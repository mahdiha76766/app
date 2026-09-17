/// وضعیت ضبط صدای شرح مشکل.
enum ProblemVoiceRecorderState {
  idle,
  recording,
  processing,
  unavailable,
}

/// Interface ضبط صدای مشکل مشتری — پیاده‌سازی واقعی بعداً اضافه می‌شود.
abstract interface class ProblemVoiceRecorder {
  Stream<ProblemVoiceRecorderState> get stateChanges;

  ProblemVoiceRecorderState get currentState;

  Future<void> start();

  /// مسیر فایل صوتی ذخیره‌شده یا null در صورت لغو/خطا.
  Future<String?> stop();

  Future<void> cancel();
}
