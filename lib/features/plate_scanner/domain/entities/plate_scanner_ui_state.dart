/// حالت‌های UI صفحه اسکن خودکار.
enum PlateScanPhase {
  initializing,
  searching,
  aligning,
  reading,
  success,
  permissionDenied,
  cameraError,
  timeout,
}

/// رنگ کادر راهنما.
enum PlateGuideColor {
  grey,
  yellow,
  blue,
  green,
  red,
}

/// وضعیت لحظه‌ای اسکنر برای UI.
class PlateScannerUiState {
  const PlateScannerUiState({
    this.phase = PlateScanPhase.initializing,
    this.guideColor = PlateGuideColor.grey,
    this.statusMessage = 'در حال راه‌اندازی...',
    this.helpVisible = false,
    this.flashOn = false,
    this.frozenPreviewBytes,
    this.frozenRoiWidth = 0,
    this.frozenRoiHeight = 0,
    this.detectedPlateDisplay,
    this.detectedConfidence = 0,
    this.activeEngineName,
    this.modelStatusMessage,
    this.debugStats = const PlateScanDebugStats.empty(),
  });

  final PlateScanPhase phase;
  final PlateGuideColor guideColor;
  final String statusMessage;
  final bool helpVisible;
  final bool flashOn;
  final List<int>? frozenPreviewBytes;
  final int frozenRoiWidth;
  final int frozenRoiHeight;
  final String? detectedPlateDisplay;
  final double detectedConfidence;
  final String? activeEngineName;
  final String? modelStatusMessage;
  final PlateScanDebugStats debugStats;

  PlateScannerUiState copyWith({
    PlateScanPhase? phase,
    PlateGuideColor? guideColor,
    String? statusMessage,
    bool? helpVisible,
    bool? flashOn,
    List<int>? frozenPreviewBytes,
    int? frozenRoiWidth,
    int? frozenRoiHeight,
    String? detectedPlateDisplay,
    double? detectedConfidence,
    String? activeEngineName,
    String? modelStatusMessage,
    PlateScanDebugStats? debugStats,
    bool clearFrozen = false,
  }) {
    return PlateScannerUiState(
      phase: phase ?? this.phase,
      guideColor: guideColor ?? this.guideColor,
      statusMessage: statusMessage ?? this.statusMessage,
      helpVisible: helpVisible ?? this.helpVisible,
      flashOn: flashOn ?? this.flashOn,
      frozenPreviewBytes:
          clearFrozen ? null : (frozenPreviewBytes ?? this.frozenPreviewBytes),
      frozenRoiWidth: clearFrozen ? 0 : (frozenRoiWidth ?? this.frozenRoiWidth),
      frozenRoiHeight:
          clearFrozen ? 0 : (frozenRoiHeight ?? this.frozenRoiHeight),
      detectedPlateDisplay: detectedPlateDisplay ?? this.detectedPlateDisplay,
      detectedConfidence: detectedConfidence ?? this.detectedConfidence,
      activeEngineName: activeEngineName ?? this.activeEngineName,
      modelStatusMessage: modelStatusMessage ?? this.modelStatusMessage,
      debugStats: debugStats ?? this.debugStats,
    );
  }
}

/// آمار debug (فقط debug mode).
class PlateScanDebugStats {
  const PlateScanDebugStats({
    required this.cameraFps,
    required this.processFps,
    required this.detectorMs,
    required this.classifierMs,
    required this.blurScore,
    required this.brightness,
    required this.confidence,
    required this.currentCandidate,
    required this.consensusVotes,
    required this.lastRejection,
    this.roiPreviewBytes,
    this.roiPreviewWidth = 0,
    this.roiPreviewHeight = 0,
    this.activeEngineName,
    this.modelStatusMessage,
    this.detectorConfidence = 0,
    this.digitConfidences = const [],
    this.letterConfidence = 0,
    this.processingMs = 0,
    this.detectedBbox,
  });

  const PlateScanDebugStats.empty()
      : cameraFps = 0,
        processFps = 0,
        detectorMs = 0,
        classifierMs = 0,
        blurScore = 0,
        brightness = 0,
        confidence = 0,
        currentCandidate = '',
        consensusVotes = 0,
        lastRejection = '',
        roiPreviewBytes = null,
        roiPreviewWidth = 0,
        roiPreviewHeight = 0,
        activeEngineName = null,
        modelStatusMessage = null,
        detectorConfidence = 0,
        digitConfidences = const [],
        letterConfidence = 0,
        processingMs = 0,
        detectedBbox = null;

  final double cameraFps;
  final double processFps;
  final double detectorMs;
  final double classifierMs;
  final double blurScore;
  final double brightness;
  final double confidence;
  final String currentCandidate;
  final int consensusVotes;
  final String lastRejection;
  final List<int>? roiPreviewBytes;
  final int roiPreviewWidth;
  final int roiPreviewHeight;
  final String? activeEngineName;
  final String? modelStatusMessage;
  final double detectorConfidence;
  final List<double> digitConfidences;
  final double letterConfidence;
  final int processingMs;
  final String? detectedBbox;
}
