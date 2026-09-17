import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/iranian_plate_parts.dart';
import '../../domain/entities/plate_recognition_result.dart';
import '../../domain/entities/plate_scanner_ui_state.dart';
import '../../domain/services/plate_recognition_engine.dart';
import '../../domain/services/plate_scanner_controller.dart';
import '../../domain/entities/plate_model_status.dart';
import '../ml/roi_mapper.dart';
import '../ml/tflite_model_loader.dart';
import 'live_tflite_detector_only_service.dart';
import 'live_tflite_plate_scan_pipeline.dart';
import 'plate_recognition_engine_resolver.dart';
import 'tflite_plate_detection_service.dart';

/// کنترلر اسکن سریع TFLite با image stream.
class PlateScannerControllerImpl implements PlateScannerController {
  PlateScannerControllerImpl({
    required TfliteModelLoader modelLoader,
    PlateRecognitionEngineResolver? resolver,
    this.frameInterval = const Duration(milliseconds: 450),
    this.scanTimeout = const Duration(seconds: 30),
  })  : _modelLoader = modelLoader,
        _resolver = resolver ??
            PlateRecognitionEngineResolver(modelLoader: modelLoader);

  final TfliteModelLoader _modelLoader;
  final PlateRecognitionEngineResolver _resolver;

  Duration frameInterval;
  final Duration scanTimeout;

  ResolvedScanEngine? _resolvedEngine;
  LiveTflitePlateScanPipeline? _pipeline;

  final _stateController = StreamController<PlateScannerUiState>.broadcast();
  PlateScannerUiState _state = const PlateScannerUiState();

  CameraController? _camera;
  Size _previewSize = Size.zero;
  PlateGuideRect _guideRect = PlateGuideRect.standard;

  bool _isProcessing = false;
  bool _streamActive = false;
  bool _scanningEnabled = true;
  DateTime? _lastProcessedAt;
  DateTime? _scanStartedAt;
  int _cameraFrameCount = 0;
  int _processedFrameCount = 0;
  DateTime _fpsWindowStart = DateTime.now();

  IranianPlateParts? _acceptedPlate;
  double _acceptedConfidence = 0;
  List<int>? _lastRoiBytes;
  int _lastRoiWidth = 0;
  int _lastRoiHeight = 0;
  String _lastRejection = '';
  double _lastDetectorConfidence = 0;
  List<double> _lastDigitConfidences = const [];
  double _lastLetterConfidence = 0;
  int _lastProcessingMs = 0;

  @override
  Stream<PlateScannerUiState> get stateStream => _stateController.stream;

  @override
  PlateScannerUiState get currentState => _state;

  @override
  Future<void> initialize() async {
    _emit(
      _state.copyWith(
        phase: PlateScanPhase.initializing,
        statusMessage: 'در حال راه‌اندازی...',
        guideColor: PlateGuideColor.grey,
      ),
    );

    _resolvedEngine = await _resolver.resolveForLiveScan();
    final resolved = _resolvedEngine!;
    _pipeline = resolved.pipeline;
    frameInterval = Duration(milliseconds: resolved.frameIntervalMs);
    _scanningEnabled = resolved.pipeline != null;

    if (resolved.kind == ActivePlateEngineKind.tflite) {
      debugPrint('Plate scan: TFLite engine active');
    } else {
      debugPrint('Plate scan: manual fallback (${resolved.statusMessage})');
    }

    _emit(
      _state.copyWith(
        phase: _scanningEnabled
            ? PlateScanPhase.searching
            : PlateScanPhase.timeout,
        statusMessage: resolved.statusMessage,
        guideColor: PlateGuideColor.grey,
        helpVisible: !_scanningEnabled,
        activeEngineName: kDebugMode ? resolved.engineName : null,
        modelStatusMessage:
            kDebugMode ? resolved.modelStatus?.userMessage : null,
      ),
    );
  }

  @override
  Future<void> start({
    required CameraController cameraController,
    required Size previewSize,
    required PlateGuideRect guideRect,
  }) async {
    _camera = cameraController;
    _previewSize = previewSize;
    _guideRect = guideRect;
    _scanStartedAt = DateTime.now();
    _pipeline?.reset();
    _acceptedPlate = null;
    _acceptedConfidence = 0;
    _lastProcessedAt = null;
    _lastRejection = '';
    _scanningEnabled = _pipeline != null;

    if (_streamActive || !_scanningEnabled) {
      return;
    }
    if (!cameraController.value.isInitialized) {
      debugPrint('Plate scan start skipped: camera not initialized');
      return;
    }

    try {
      await cameraController.startImageStream(_onCameraFrame);
    } on CameraException catch (error) {
      debugPrint('Plate scan startImageStream failed: $error');
      return;
    }
    _streamActive = true;
    _emit(
      _state.copyWith(
        phase: PlateScanPhase.searching,
        statusMessage: _resolvedEngine?.statusMessage ?? 'پلاک را داخل کادر قرار دهید',
        guideColor: PlateGuideColor.grey,
        helpVisible: false,
        clearFrozen: true,
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _stateController.close();
    _scanningEnabled = false;
    await _modelLoader.dispose();
    await _pipeline?.dispose();
  }

  @override
  Future<void> stop() async {
    final camera = _camera;
    if (camera != null && _streamActive && camera.value.isStreamingImages) {
      await camera.stopImageStream();
    }
    _streamActive = false;
    _isProcessing = false;
  }

  @override
  void rescan() {
    _pipeline?.reset();
    _acceptedPlate = null;
    _acceptedConfidence = 0;
    _scanStartedAt = DateTime.now();
    _lastRejection = '';
    _scanningEnabled = _pipeline != null;
    _streamActive = false;
    _isProcessing = false;
    // دوربین قبلی ممکن است dispose شده باشد؛ UI باید دوباره start را صدا بزند.
    _camera = null;

    _emit(
      _state.copyWith(
        phase: _scanningEnabled
            ? PlateScanPhase.searching
            : PlateScanPhase.timeout,
        statusMessage:
            _resolvedEngine?.statusMessage ?? 'پلاک را داخل کادر قرار دهید',
        guideColor: PlateGuideColor.grey,
        helpVisible: !_scanningEnabled,
        clearFrozen: true,
      ),
    );
  }

  @override
  PlateRecognitionResult? buildRecognitionResult({required String imagePath}) {
    final plate = _acceptedPlate;
    if (plate == null) {
      return null;
    }
    // detector-only: فیلدهای خالی مجاز است تا کاربر دستی وارد کند.
    return PlateRecognitionResult(
      rawText: plate.rawCompact,
      normalizedPlate: plate.normalized,
      firstTwoDigits: plate.firstTwoDigits,
      middleThreeDigits: plate.middleThreeDigits,
      letter: plate.letter,
      cityCode: plate.cityCode,
      confidence: _acceptedConfidence,
      imagePath: imagePath,
    );
  }

  @override
  Future<void> toggleFlash(CameraController controller) async {
    final next = !_state.flashOn;
    await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    _emit(_state.copyWith(flashOn: next));
  }

  @override
  void onPreviewSizeChanged(Size previewSize, PlateGuideRect guideRect) {
    _previewSize = previewSize;
    _guideRect = guideRect;
  }

  /// پردازش تصویر نمونه (debug) با همان pipeline.
  @override
  Future<PlateRecognitionResult?> recognizeSampleBytes(
    List<int> rgbBytes,
    int width,
    int height, {
    required String imagePath,
  }) async {
    final pipeline = _pipeline;
    if (pipeline == null) {
      return null;
    }

    final candidate = await pipeline.recognition.recognize(
      Uint8List.fromList(rgbBytes),
      width,
      height,
    );
    if (candidate == null) {
      return null;
    }

    _acceptedPlate = candidate.plate;
    _acceptedConfidence = candidate.confidence;

    if (candidate.detectorOnly &&
        pipeline.recognition is LiveTfliteDetectorOnlyService) {
      final detectorOnly =
          pipeline.recognition as LiveTfliteDetectorOnlyService;
      if (detectorOnly.lastCroppedBytes != null) {
        _lastRoiBytes = detectorOnly.lastCroppedBytes;
        _lastRoiWidth = detectorOnly.lastCroppedWidth;
        _lastRoiHeight = detectorOnly.lastCroppedHeight;
      }
    } else {
      _lastRoiBytes = rgbBytes;
      _lastRoiWidth = width;
      _lastRoiHeight = height;
    }

    _emit(
      _state.copyWith(
        frozenPreviewBytes: _lastRoiBytes,
        frozenRoiWidth: _lastRoiWidth,
        frozenRoiHeight: _lastRoiHeight,
        statusMessage: candidate.detectorOnly
            ? PlateModelStatus.detectedManualEntryMessage
            : _state.statusMessage,
      ),
    );

    return buildRecognitionResult(imagePath: imagePath);
  }

  void _applySensorOrientation(int degrees) {
    final recognition = _pipeline?.recognition;
    if (recognition is LiveTfliteDetectorOnlyService &&
        recognition.detector is TflitePlateDetectionService) {
      (recognition.detector as TflitePlateDetectionService)
          .sensorOrientationDegrees = degrees;
      return;
    }
    // سایر سرویس‌های TFLite هم در صورت نیاز orientation می‌گیرند
    try {
      final dynamic service = recognition;
      final detector = service?.detector;
      if (detector is TflitePlateDetectionService) {
        detector.sensorOrientationDegrees = degrees;
      }
    } catch (_) {}
  }

  Future<void> _onCameraFrame(CameraImage image) async {
    _cameraFrameCount++;
    _updateFps();

    if (_state.phase == PlateScanPhase.success || !_scanningEnabled) {
      return;
    }

    if (_isProcessing) {
      return;
    }

    final now = DateTime.now();
    if (_lastProcessedAt != null &&
        now.difference(_lastProcessedAt!) < frameInterval) {
      return;
    }
    _lastProcessedAt = now;

    final pipeline = _pipeline;
    final camera = _camera;
    if (pipeline == null || camera == null || !camera.value.isInitialized) {
      return;
    }

    _isProcessing = true;
    final started = DateTime.now();

    try {
      final isDetectorOnly = _resolvedEngine?.detectorOnly == true;
      _applySensorOrientation(camera.description.sensorOrientation);

      final previewRect = _guideRect.toPreviewRect(_previewSize);
      final sensorRect = RoiMapper.mapPreviewRectToSensor(
        previewRect: previewRect,
        previewSize: _previewSize,
        sensorSize: Size(image.width.toDouble(), image.height.toDouble()),
        rotationDegrees: camera.description.sensorOrientation,
        // detector-only هم باید بیشتر روی همان کادر مرئی کاربر تکیه کند.
        expandFactor: isDetectorOnly ? 1.35 : 1.2,
      );

      if (kDebugMode && _processedFrameCount % 4 == 0) {
        debugPrint(
          'ROI sensor=${sensorRect.width.toStringAsFixed(0)}x'
          '${sensorRect.height.toStringAsFixed(0)} '
          'frame=${image.width}x${image.height} '
          'rot=${camera.description.sensorOrientation} '
          'detectorOnly=$isDetectorOnly',
        );
      }

      if (sensorRect.width <= 1 || sensorRect.height <= 1) {
        _lastRejection = 'ROI نامعتبر';
        _emit(
          _state.copyWith(
            phase: PlateScanPhase.searching,
            guideColor: PlateGuideColor.red,
            statusMessage: 'پلاک را داخل کادر قرار دهید',
          ),
        );
        return;
      }

      final result = await pipeline.processFrame(
        cameraImage: image,
        sensorRoi: sensorRect,
      );

      _processedFrameCount++;
      _lastRoiBytes = result.roiImage.bytes;
      _lastRoiWidth = result.roiImage.width;
      _lastRoiHeight = result.roiImage.height;
      _lastProcessingMs = DateTime.now().difference(started).inMilliseconds;

      if (result.candidate != null) {
        _lastDetectorConfidence = result.candidate!.detectorConfidence;
        _lastDigitConfidences = result.candidate!.digitConfidences;
        _lastLetterConfidence = result.candidate!.letterConfidence;
      }

      if (result.rejected) {
        _lastRejection = result.quality.rejectionReason ?? 'ROI نامعتبر';
        _emitSearching(
          phase: PlateScanPhase.searching,
          color: PlateGuideColor.grey,
          message: 'پلاک را داخل کادر قرار دهید',
          result: result,
        );
      } else if (result.noDetection) {
        _lastRejection = 'پلاک یافت نشد';
        _emitSearching(
          phase: PlateScanPhase.searching,
          color: PlateGuideColor.grey,
          message: 'پلاک را داخل کادر قرار دهید',
          result: result,
        );
      } else if (result.consensus.isAccepted) {
        debugPrint(
          'Plate scan ACCEPT conf=${result.consensus.averageConfidence} '
          'detectorOnly=${result.candidate?.detectorOnly}',
        );
        final plate = result.consensus.plate ??
            LiveTfliteDetectorOnlyService.emptyPlate;
        if (result.candidate?.detectorOnly == true) {
          final detectorOnly =
              _pipeline?.recognition is LiveTfliteDetectorOnlyService
                  ? _pipeline!.recognition as LiveTfliteDetectorOnlyService
                  : null;
          if (detectorOnly?.lastCroppedBytes != null) {
            _lastRoiBytes = detectorOnly!.lastCroppedBytes;
            _lastRoiWidth = detectorOnly.lastCroppedWidth;
            _lastRoiHeight = detectorOnly.lastCroppedHeight;
          }
        }
        await _handleSuccess(
          plate,
          result.consensus.averageConfidence,
          detectorOnly: result.candidate?.detectorOnly == true,
        );
      } else if (result.candidate != null) {
        _lastRejection = 'در حال خواندن...';
        _emitSearching(
          phase: PlateScanPhase.reading,
          color: PlateGuideColor.blue,
          message: 'در حال خواندن پلاک...',
          result: result,
        );
      } else {
        _emitSearching(
          phase: PlateScanPhase.searching,
          color: PlateGuideColor.grey,
          message: 'پلاک را داخل کادر قرار دهید',
          result: result,
        );
      }

      _checkTimeout();
    } catch (error) {
      debugPrint('Frame processing error: $error');
      _lastRejection = error.toString();
    } finally {
      _isProcessing = false;
    }
  }

  void _emitSearching({
    required PlateScanPhase phase,
    required PlateGuideColor color,
    required String message,
    required LivePipelineResult result,
  }) {
    if (_state.phase == phase &&
        _state.guideColor == color &&
        _state.statusMessage == message &&
        _state.helpVisible == false) {
      return;
    }
    _emit(
      _state.copyWith(
        phase: phase,
        guideColor: color,
        statusMessage: message,
        debugStats: kDebugMode ? _buildDebugStats(result) : _state.debugStats,
      ),
    );
  }

  Future<void> _handleSuccess(
    IranianPlateParts plate,
    double confidence, {
    bool detectorOnly = false,
  }) async {
    if (_state.phase == PlateScanPhase.success) {
      return;
    }

    _acceptedPlate = plate;
    _acceptedConfidence = confidence;
    _scanningEnabled = false;

    await stop();

    await HapticFeedback.mediumImpact();
    if (kDebugMode) {
      await SystemSound.play(SystemSoundType.click);
    }

    final statusMessage = detectorOnly
        ? PlateModelStatus.detectedManualEntryMessage
        : 'پلاک خوانده شد';

    _emit(
      _state.copyWith(
        phase: PlateScanPhase.success,
        guideColor: PlateGuideColor.green,
        statusMessage: statusMessage,
        detectedPlateDisplay:
            detectorOnly ? statusMessage : plate.display,
        detectedConfidence: confidence,
        frozenPreviewBytes: _lastRoiBytes,
        frozenRoiWidth: _lastRoiWidth,
        frozenRoiHeight: _lastRoiHeight,
        debugStats: _state.debugStats.copyWithPlaceholder(
          confidence: confidence,
          currentCandidate:
              detectorOnly ? 'detector-only crop' : plate.display,
        ),
      ),
    );
  }

  void _checkTimeout() {
    if (_state.phase == PlateScanPhase.success) {
      return;
    }
    final started = _scanStartedAt;
    if (started == null) {
      return;
    }
    if (DateTime.now().difference(started) >= scanTimeout) {
      _emit(
        _state.copyWith(
          phase: PlateScanPhase.timeout,
          helpVisible: true,
          statusMessage: 'ورود دستی',
          guideColor: PlateGuideColor.yellow,
        ),
      );
    }
  }

  void _updateFps() {
    if (!kDebugMode) {
      return;
    }
    final elapsed = DateTime.now().difference(_fpsWindowStart);
    if (elapsed.inMilliseconds < 1000) {
      return;
    }
    final cameraFps = _cameraFrameCount * 1000 / elapsed.inMilliseconds;
    final processFps = _processedFrameCount * 1000 / elapsed.inMilliseconds;
    _cameraFrameCount = 0;
    _processedFrameCount = 0;
    _fpsWindowStart = DateTime.now();

    _emit(
      _state.copyWith(
        debugStats: _state.debugStats.copyWithPlaceholder(
          cameraFps: cameraFps,
          processFps: processFps,
        ),
      ),
    );
  }

  PlateScanDebugStats _buildDebugStats(LivePipelineResult result) {
    return PlateScanDebugStats(
      cameraFps: _state.debugStats.cameraFps,
      processFps: _state.debugStats.processFps,
      detectorMs: _lastProcessingMs * 0.4,
      classifierMs: _lastProcessingMs * 0.6,
      blurScore: result.quality.blurScore,
      brightness: result.quality.brightness,
      confidence: result.candidate?.confidence ?? 0,
      currentCandidate: result.candidate?.plate.display ?? '',
      consensusVotes: result.consensus.voteCount,
      lastRejection: _lastRejection,
      roiPreviewBytes: null,
      roiPreviewWidth: 0,
      roiPreviewHeight: 0,
      activeEngineName: kDebugMode ? _resolvedEngine?.engineName : null,
      modelStatusMessage: kDebugMode ? _resolvedEngine?.modelStatus?.userMessage : null,
      detectorConfidence: _lastDetectorConfidence,
      digitConfidences: _lastDigitConfidences,
      letterConfidence: _lastLetterConfidence,
      processingMs: _lastProcessingMs,
      detectedBbox: result.detectedBbox != null
          ? '${result.detectedBbox!.left.toStringAsFixed(2)},'
              '${result.detectedBbox!.top.toStringAsFixed(2)}'
          : null,
    );
  }

  void _emit(PlateScannerUiState next) {
    _state = next;
    if (!_stateController.isClosed) {
      _stateController.add(next);
    }
  }
}

extension on PlateScanDebugStats {
  PlateScanDebugStats copyWithPlaceholder({
    double? cameraFps,
    double? processFps,
    double? confidence,
    String? currentCandidate,
  }) {
    return PlateScanDebugStats(
      cameraFps: cameraFps ?? this.cameraFps,
      processFps: processFps ?? this.processFps,
      detectorMs: detectorMs,
      classifierMs: classifierMs,
      blurScore: blurScore,
      brightness: brightness,
      confidence: confidence ?? this.confidence,
      currentCandidate: currentCandidate ?? this.currentCandidate,
      consensusVotes: consensusVotes,
      lastRejection: lastRejection,
      roiPreviewBytes: roiPreviewBytes,
      roiPreviewWidth: roiPreviewWidth,
      roiPreviewHeight: roiPreviewHeight,
      activeEngineName: activeEngineName,
      modelStatusMessage: modelStatusMessage,
      detectorConfidence: detectorConfidence,
      digitConfidences: digitConfidences,
      letterConfidence: letterConfidence,
      processingMs: processingMs,
      detectedBbox: detectedBbox,
    );
  }
}
