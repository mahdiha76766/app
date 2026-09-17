import 'dart:async';

import '../../../../core/errors/not_implemented_exception.dart';
import '../../domain/services/problem_voice_recorder.dart';

/// اسکلت ضبط صدا — فعلاً در دسترس نیست.
class StubProblemVoiceRecorder implements ProblemVoiceRecorder {
  final _controller =
      StreamController<ProblemVoiceRecorderState>.broadcast();

  @override
  ProblemVoiceRecorderState get currentState =>
      ProblemVoiceRecorderState.unavailable;

  @override
  Stream<ProblemVoiceRecorderState> get stateChanges => _controller.stream;

  @override
  Future<void> start() async {
    throw NotImplementedException(
      'ضبط صدای شرح مشکل هنوز پیاده‌سازی نشده است.',
    );
  }

  @override
  Future<String?> stop() async => null;

  @override
  Future<void> cancel() async {}

  void dispose() {
    _controller.close();
  }
}
