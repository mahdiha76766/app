import '../../domain/entities/plate_model_status.dart';
import '../../domain/services/plate_recognition_engine.dart';
import '../engines/manual_plate_recognition_engine.dart';
import '../engines/tflite_plate_recognition_engine.dart';
import '../ml/tflite_model_loader.dart';
import '../services/fast_plate_voting_service.dart';
import '../services/laplacian_plate_quality_service.dart';
import '../services/live_tflite_detector_only_service.dart';
import '../services/live_tflite_detector_recognizer_service.dart';
import '../services/live_tflite_plate_recognition_service.dart';
import '../services/live_tflite_plate_scan_pipeline.dart';
import '../services/passthrough_plate_quality_service.dart';
import '../services/plate_model_availability_service_impl.dart';
import '../services/tflite_plate_character_classifier.dart';
import '../services/tflite_plate_detection_service.dart';

/// نتیجه انتخاب موتور برای اسکن زنده.
class ResolvedScanEngine {
  const ResolvedScanEngine({
    required this.kind,
    required this.engineName,
    required this.statusMessage,
    this.warningMessage,
    this.pipeline,
    this.modelStatus,
    this.frameIntervalMs = 200,
    this.detectorOnly = false,
  });

  final ActivePlateEngineKind kind;
  final String engineName;
  final String statusMessage;
  final String? warningMessage;
  final LiveTflitePlateScanPipeline? pipeline;
  final PlateModelStatus? modelStatus;
  final int frameIntervalMs;
  final bool detectorOnly;
}

/// انتخاب موتور live scan: full TFLite → detector-only → Manual.
class PlateRecognitionEngineResolver {
  PlateRecognitionEngineResolver({
    required TfliteModelLoader modelLoader,
    FastPlateVotingService? voting,
  })  : _modelLoader = modelLoader,
        _availability = PlateModelAvailabilityServiceImpl(modelLoader),
        _voting = voting ?? FastPlateVotingService();

  final TfliteModelLoader _modelLoader;
  final PlateModelAvailabilityServiceImpl _availability;
  final FastPlateVotingService _voting;
  final ManualPlateRecognitionEngine _manualEngine =
      const ManualPlateRecognitionEngine();

  Future<ResolvedScanEngine> resolveForLiveScan() async {
    final status = await _availability.check();

    if (status.canAutoScan) {
      final loaded = await _modelLoader.tryLoadBestAvailable();
      if (loaded) {
        final detector = TflitePlateDetectionService(_modelLoader);
        final recognition = status.mode == PlateModelMode.detectorRecognizer
            ? LiveTfliteDetectorRecognizerService(
                detector: detector,
                loader: _modelLoader,
              )
            : LiveTflitePlateRecognitionService(
                detector: detector,
                classifier: TflitePlateCharacterClassifier(_modelLoader),
              );

        return ResolvedScanEngine(
          kind: ActivePlateEngineKind.tflite,
          engineName: status.debugEngineLabel,
          statusMessage: status.userMessage,
          modelStatus: status,
          frameIntervalMs: 200,
          pipeline: LiveTflitePlateScanPipeline(
            recognition: recognition,
            quality: const LaplacianPlateQualityService(),
            voting: _voting,
          ),
        );
      }
    }

    if (status.canDetectOnly) {
      final loaded = await _modelLoader.tryLoadDetector();
      if (loaded) {
        final detectorOnly = LiveTfliteDetectorOnlyService(
          detector: TflitePlateDetectionService(_modelLoader),
          acceptThreshold: 0.40,
        );
        return ResolvedScanEngine(
          kind: ActivePlateEngineKind.tflite,
          engineName: status.debugEngineLabel,
          statusMessage: status.userMessage,
          modelStatus: status,
          // preview روان مهم‌تر است؛ اسکن با مکث کوتاه انجام می‌شود.
          frameIntervalMs: 1500,
          detectorOnly: true,
          pipeline: LiveTflitePlateScanPipeline(
            recognition: detectorOnly,
            quality: const PassthroughPlateQualityService(),
            voting: FastPlateVotingService(
              mediumConfidenceThreshold: 0.35,
              highConfidenceThreshold: 0.55,
            ),
          ),
        );
      }
    }

    return ResolvedScanEngine(
      kind: ActivePlateEngineKind.manual,
      engineName: status.debugEngineLabel,
      statusMessage: status.userMessage,
      warningMessage: status.message,
      modelStatus: status,
      frameIntervalMs: 200,
      pipeline: null,
    );
  }

  Future<PlateRecognitionEngine> resolveForStillImage() async {
    if (await _modelLoader.tryLoadBestAvailable()) {
      return TflitePlateRecognitionEngine(_modelLoader);
    }
    if (await _modelLoader.tryLoadDetector()) {
      return TflitePlateRecognitionEngine(_modelLoader);
    }
    return _manualEngine;
  }
}
