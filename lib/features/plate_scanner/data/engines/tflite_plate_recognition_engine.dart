import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../../domain/entities/plate_recognition_result.dart';
import '../../domain/services/plate_recognition_engine.dart';
import '../ml/tflite_model_loader.dart';
import '../services/live_tflite_detector_recognizer_service.dart';
import '../services/live_tflite_plate_recognition_service.dart';
import '../services/tflite_plate_character_classifier.dart';
import '../services/tflite_plate_detection_service.dart';

/// موتور TFLite برای تشخیص پلاک از تصویر ثابت.
class TflitePlateRecognitionEngine implements PlateRecognitionEngine {
  TflitePlateRecognitionEngine(this._modelLoader);

  final TfliteModelLoader _modelLoader;
  LiveTflitePlateRecognitionService? _classifiersRecognition;
  LiveTfliteDetectorRecognizerService? _recognizerRecognition;

  @override
  String get name => 'TFLite';

  @override
  Future<bool> isAvailable() => _modelLoader.tryLoadBestAvailable();

  @override
  Future<PlateRecognitionResult> recognize(String imagePath) async {
    final loaded = await _modelLoader.tryLoadBestAvailable();
    if (!loaded) {
      return _empty(imagePath);
    }

    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return _empty(imagePath);
    }

    final rgb = decoded.getBytes(order: img.ChannelOrder.rgb);
    final detector = TflitePlateDetectionService(_modelLoader);

    final candidate = _modelLoader.isRecognizerLoaded
        ? await (_recognizerRecognition ??= LiveTfliteDetectorRecognizerService(
            detector: detector,
            loader: _modelLoader,
          ))
            .recognize(
            Uint8List.fromList(rgb),
            decoded.width,
            decoded.height,
          )
        : await (_classifiersRecognition ??= LiveTflitePlateRecognitionService(
            detector: detector,
            classifier: TflitePlateCharacterClassifier(_modelLoader),
          ))
            .recognize(
            Uint8List.fromList(rgb),
            decoded.width,
            decoded.height,
          );

    if (candidate == null) {
      return _empty(imagePath);
    }

    final plate = candidate.plate;
    return PlateRecognitionResult(
      rawText: plate.rawCompact,
      normalizedPlate: plate.normalized,
      firstTwoDigits: plate.firstTwoDigits,
      middleThreeDigits: plate.middleThreeDigits,
      letter: plate.letter,
      cityCode: plate.cityCode,
      confidence: candidate.confidence,
      imagePath: imagePath,
    );
  }

  PlateRecognitionResult _empty(String imagePath) => PlateRecognitionResult(
        rawText: '',
        normalizedPlate: '',
        firstTwoDigits: '',
        middleThreeDigits: '',
        letter: '',
        cityCode: '',
        confidence: 0,
        imagePath: imagePath,
      );
}
