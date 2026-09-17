import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../errors/model_not_found_exception.dart';
import 'iran_plate_models_config.dart';

/// بارگذاری مدل‌های TFLite پلاک.
class TfliteModelLoader {
  TfliteModelLoader({
    this.configAsset = IranPlateModelsConfig.assetPath,
    IranPlateModelsConfig? config,
  }) : _configOverride = config;

  final String configAsset;
  final IranPlateModelsConfig? _configOverride;

  IranPlateModelsConfig? _config;
  Interpreter? _detector;
  Interpreter? _recognizer;
  Interpreter? _digitClassifier;
  Interpreter? _letterClassifier;

  bool _detectorLoaded = false;
  bool _recognizerLoaded = false;
  bool _digitLoaded = false;
  bool _letterLoaded = false;

  IranPlateModelsConfig get config {
    final value = _config ?? _configOverride;
    if (value == null) {
      throw const ModelNotFoundException('تنظیمات مدل پلاک بارگذاری نشده است.');
    }
    return value;
  }

  bool get isFullyLoaded =>
      (_detectorLoaded && _recognizerLoaded) ||
      (_detectorLoaded && _digitLoaded && _letterLoaded);

  bool get isDetectorLoaded => _detectorLoaded;
  bool get isRecognizerLoaded => _recognizerLoaded;
  bool get isDigitClassifierLoaded => _digitLoaded;
  bool get isLetterClassifierLoaded => _letterLoaded;
  bool get isClassifiersLoaded => _digitLoaded && _letterLoaded;

  Future<IranPlateModelsConfig> loadConfig() async {
    if (_config != null) {
      return _config!;
    }
    if (_configOverride != null) {
      _config = _configOverride;
      return _config!;
    }
    _config = await IranPlateModelsConfig.loadFromAssets(configAsset);
    return _config!;
  }

  Future<bool> assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// بارگذاری بهترین ترکیب موجود: recognizer ترجیح دارد.
  Future<bool> tryLoadBestAvailable() async {
    await loadConfig();
    final cfg = config;
    final detectorOk = await assetExists(cfg.detector.path);
    if (!detectorOk) {
      return false;
    }

    final recognizerOk = await assetExists(cfg.recognizer.path);
    if (recognizerOk) {
      try {
        await loadDetector();
        await loadRecognizer();
        return true;
      } on ModelNotFoundException {
        return false;
      }
    }

    final digitOk = await assetExists(cfg.digitClassifier.path);
    final letterOk = await assetExists(cfg.letterClassifier.path);
    if (digitOk && letterOk) {
      try {
        await loadDetector();
        await loadDigitClassifier();
        await loadLetterClassifier();
        return true;
      } on ModelNotFoundException {
        return false;
      }
    }

    return false;
  }

  Future<bool> tryLoadAll() => tryLoadBestAvailable();

  Future<bool> tryLoadDetector() async {
    await loadConfig();
    if (!await assetExists(config.detector.path)) {
      return false;
    }
    try {
      await loadDetector();
      return true;
    } on ModelNotFoundException {
      return false;
    }
  }

  Future<void> loadAll() async {
    await loadConfig();
    await loadDetector();
    if (await assetExists(config.recognizer.path)) {
      await loadRecognizer();
      return;
    }
    await loadDigitClassifier();
    await loadLetterClassifier();
  }

  Future<void> loadDetector() async {
    if (_detectorLoaded) {
      return;
    }
    await loadConfig();
    final path = config.detector.path;
    if (!await assetExists(path)) {
      throw ModelNotFoundException('مدل تشخیص پلاک ($path) یافت نشد.');
    }
    _detector = await Interpreter.fromAsset(
      path,
      options: InterpreterOptions()..threads = 4,
    );
    _detectorLoaded = true;
  }

  Future<void> loadRecognizer() async {
    if (_recognizerLoaded) {
      return;
    }
    await loadConfig();
    final path = config.recognizer.path;
    if (!await assetExists(path)) {
      throw ModelNotFoundException('مدل recognizer پلاک ($path) یافت نشد.');
    }
    _recognizer = await Interpreter.fromAsset(path);
    _recognizerLoaded = true;
  }

  Future<void> loadDigitClassifier() async {
    if (_digitLoaded) {
      return;
    }
    await loadConfig();
    final path = config.digitClassifier.path;
    if (!await assetExists(path)) {
      throw ModelNotFoundException('مدل classifier عدد ($path) یافت نشد.');
    }
    _digitClassifier = await Interpreter.fromAsset(path);
    _digitLoaded = true;
  }

  Future<void> loadLetterClassifier() async {
    if (_letterLoaded) {
      return;
    }
    await loadConfig();
    final path = config.letterClassifier.path;
    if (!await assetExists(path)) {
      throw ModelNotFoundException('مدل classifier حرف ($path) یافت نشد.');
    }
    _letterClassifier = await Interpreter.fromAsset(path);
    _letterLoaded = true;
  }

  Interpreter get detector {
    final interpreter = _detector;
    if (interpreter == null) {
      throw const ModelNotFoundException('مدل detector بارگذاری نشده است.');
    }
    return interpreter;
  }

  Interpreter get recognizer {
    final interpreter = _recognizer;
    if (interpreter == null) {
      throw const ModelNotFoundException('مدل recognizer بارگذاری نشده است.');
    }
    return interpreter;
  }

  Interpreter get digitClassifier {
    final interpreter = _digitClassifier;
    if (interpreter == null) {
      throw const ModelNotFoundException('مدل digit classifier بارگذاری نشده است.');
    }
    return interpreter;
  }

  Interpreter get letterClassifier {
    final interpreter = _letterClassifier;
    if (interpreter == null) {
      throw const ModelNotFoundException('مدل letter classifier بارگذاری نشده است.');
    }
    return interpreter;
  }

  Future<void> dispose() async {
    _detector?.close();
    _recognizer?.close();
    _digitClassifier?.close();
    _letterClassifier?.close();
    _detector = null;
    _recognizer = null;
    _digitClassifier = null;
    _letterClassifier = null;
    _detectorLoaded = false;
    _recognizerLoaded = false;
    _digitLoaded = false;
    _letterLoaded = false;
  }

  @Deprecated('Use tryLoadBestAvailable instead')
  Future<bool> tryLoad() => tryLoadBestAvailable();

  @Deprecated('Use loadAll instead')
  Future<void> load() => loadAll();
}
