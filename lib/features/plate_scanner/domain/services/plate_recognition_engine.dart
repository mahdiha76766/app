import '../entities/plate_recognition_result.dart';

/// موتور تشخیص پلاک — TFLite، Tesseract یا ورود دستی.
abstract interface class PlateRecognitionEngine {
  String get name;

  Future<bool> isAvailable();

  Future<PlateRecognitionResult> recognize(String imagePath);
}

/// نوع موتور فعال برای اسکن زنده.
enum ActivePlateEngineKind {
  tflite,
  tesseract,
  manual,
}

extension ActivePlateEngineKindX on ActivePlateEngineKind {
  String get displayName => switch (this) {
        ActivePlateEngineKind.tflite => 'TFLite',
        ActivePlateEngineKind.tesseract => 'Tesseract',
        ActivePlateEngineKind.manual => 'Manual',
      };
}
