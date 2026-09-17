import 'dart:convert';

import 'package:flutter/services.dart';

/// تنظیمات مدل detector.
class DetectorModelConfig {
  const DetectorModelConfig({
    required this.path,
    required this.inputWidth,
    required this.inputHeight,
    required this.confidenceThreshold,
    required this.iouThreshold,
  });

  final String path;
  final int inputWidth;
  final int inputHeight;
  final double confidenceThreshold;
  final double iouThreshold;

  factory DetectorModelConfig.fromJson(Map<String, dynamic> json) {
    return DetectorModelConfig(
      path: json['path'] as String,
      inputWidth: json['inputWidth'] as int,
      inputHeight: json['inputHeight'] as int,
      confidenceThreshold: (json['confidenceThreshold'] as num).toDouble(),
      iouThreshold: (json['iouThreshold'] as num).toDouble(),
    );
  }
}

/// تنظیمات recognizer (CRNN و مشابه).
class RecognizerModelConfig {
  const RecognizerModelConfig({
    required this.path,
    required this.inputWidth,
    required this.inputHeight,
    required this.confidenceThreshold,
  });

  final String path;
  final int inputWidth;
  final int inputHeight;
  final double confidenceThreshold;

  factory RecognizerModelConfig.fromJson(Map<String, dynamic> json) {
    return RecognizerModelConfig(
      path: json['path'] as String,
      inputWidth: json['inputWidth'] as int,
      inputHeight: json['inputHeight'] as int,
      confidenceThreshold: (json['confidenceThreshold'] as num).toDouble(),
    );
  }
}

/// تنظیمات classifier.
class ClassifierModelConfig {
  const ClassifierModelConfig({
    required this.path,
    required this.inputWidth,
    required this.inputHeight,
    required this.classes,
    required this.confidenceThreshold,
  });

  final String path;
  final int inputWidth;
  final int inputHeight;
  final List<String> classes;
  final double confidenceThreshold;

  factory ClassifierModelConfig.fromJson(Map<String, dynamic> json) {
    return ClassifierModelConfig(
      path: json['path'] as String,
      inputWidth: json['inputWidth'] as int,
      inputHeight: json['inputHeight'] as int,
      classes: (json['classes'] as List<dynamic>).cast<String>(),
      confidenceThreshold: (json['confidenceThreshold'] as num).toDouble(),
    );
  }
}

/// تنظیمات normalization پلاک.
class PlateNormalizationConfig {
  const PlateNormalizationConfig({
    required this.plateWidth,
    required this.plateHeight,
  });

  final int plateWidth;
  final int plateHeight;

  factory PlateNormalizationConfig.fromJson(Map<String, dynamic> json) {
    return PlateNormalizationConfig(
      plateWidth: json['plateWidth'] as int,
      plateHeight: json['plateHeight'] as int,
    );
  }

  static const defaults = PlateNormalizationConfig(
    plateWidth: 280,
    plateHeight: 64,
  );
}

/// تنظیمات کامل مدل‌های پلاک.
class IranPlateModelsConfig {
  const IranPlateModelsConfig({
    required this.mode,
    required this.detector,
    required this.recognizer,
    required this.digitClassifier,
    required this.letterClassifier,
    required this.normalization,
  });

  /// auto | detector_recognizer | detector_classifiers
  final String mode;
  final DetectorModelConfig detector;
  final RecognizerModelConfig recognizer;
  final ClassifierModelConfig digitClassifier;
  final ClassifierModelConfig letterClassifier;
  final PlateNormalizationConfig normalization;

  static const assetPath = 'assets/models/iran_plate_models_config.json';

  static Future<IranPlateModelsConfig> loadFromAssets([
    String path = assetPath,
  ]) async {
    final raw = await rootBundle.loadString(path);
    return fromJsonString(raw);
  }

  static IranPlateModelsConfig fromJsonString(String raw) {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return IranPlateModelsConfig(
      mode: (json['mode'] as String?) ?? 'auto',
      detector: DetectorModelConfig.fromJson(
        json['detector'] as Map<String, dynamic>,
      ),
      recognizer: RecognizerModelConfig.fromJson(
        json['recognizer'] as Map<String, dynamic>? ??
            const {
              'path': 'assets/models/iran_plate_recognizer.tflite',
              'inputWidth': 160,
              'inputHeight': 48,
              'confidenceThreshold': 0.65,
            },
      ),
      digitClassifier: ClassifierModelConfig.fromJson(
        json['digitClassifier'] as Map<String, dynamic>,
      ),
      letterClassifier: ClassifierModelConfig.fromJson(
        json['letterClassifier'] as Map<String, dynamic>,
      ),
      normalization: json['normalization'] != null
          ? PlateNormalizationConfig.fromJson(
              json['normalization'] as Map<String, dynamic>,
            )
          : PlateNormalizationConfig.defaults,
    );
  }
}
