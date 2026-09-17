import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/plate_recognition_mode.dart';
import '../domain/services/plate_recognition_service.dart';
import '../domain/services/plate_scanner_controller.dart';
import 'ml/tflite_model_loader.dart';
import 'services/manual_plate_recognition_service.dart';
import 'services/api_plate_recognition_service.dart';
import 'services/plate_recognition_engine_resolver.dart';
import 'services/plate_scanner_controller_impl.dart';

final plateRecognitionModeProvider =
    StateProvider<PlateRecognitionMode>((ref) {
  return kDebugMode
      ? PlateRecognitionMode.manual
      : PlateRecognitionMode.manual;
});

final plateRecognitionEngineResolverProvider =
    Provider<PlateRecognitionEngineResolver>((ref) {
  return PlateRecognitionEngineResolver(
    modelLoader: ref.watch(tfliteModelLoaderProvider),
  );
});

final plateRecognitionServiceProvider = Provider<PlateRecognitionService>((ref) {
  final mode = ref.watch(plateRecognitionModeProvider);
  switch (mode) {
    case PlateRecognitionMode.mock:
      return const ManualPlateRecognitionService();
    case PlateRecognitionMode.manual:
      return const ManualPlateRecognitionService();
    case PlateRecognitionMode.api:
      return const ApiPlateRecognitionService();
  }
});

final tfliteModelLoaderProvider = Provider<TfliteModelLoader>((ref) {
  final loader = TfliteModelLoader();
  ref.onDispose(loader.dispose);
  return loader;
});

final plateScannerControllerProvider = Provider<PlateScannerController>((ref) {
  final controller = PlateScannerControllerImpl(
    modelLoader: ref.watch(tfliteModelLoaderProvider),
    resolver: ref.watch(plateRecognitionEngineResolverProvider),
  );
  ref.onDispose(controller.dispose);
  return controller;
});
