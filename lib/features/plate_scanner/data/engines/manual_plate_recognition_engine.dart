import '../../domain/entities/plate_recognition_result.dart';
import '../../domain/services/plate_recognition_engine.dart';

/// موتور ورود دستی — تشخیص خودکار انجام نمی‌دهد.
class ManualPlateRecognitionEngine implements PlateRecognitionEngine {
  const ManualPlateRecognitionEngine();

  @override
  String get name => 'Manual';

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<PlateRecognitionResult> recognize(String imagePath) async {
    return PlateRecognitionResult(
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
}
