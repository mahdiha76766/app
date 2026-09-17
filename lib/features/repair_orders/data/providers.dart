import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../domain/repositories/repair_order_repository.dart';
import '../domain/services/problem_voice_recorder.dart';
import 'repositories/repair_order_repository_impl.dart';
import 'services/stub_problem_voice_recorder.dart';

final repairOrderRepositoryProvider = Provider<RepairOrderRepository>((ref) {
  return RepairOrderRepositoryImpl(ref.watch(appDatabaseProvider));
});

final problemVoiceRecorderProvider = Provider<ProblemVoiceRecorder>((ref) {
  final recorder = StubProblemVoiceRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});
