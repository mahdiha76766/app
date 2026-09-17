/// نتیجه تشخیص پلاک از تصویر.
class PlateRecognitionResult {
  const PlateRecognitionResult({
    required this.rawText,
    required this.normalizedPlate,
    required this.firstTwoDigits,
    required this.middleThreeDigits,
    required this.letter,
    required this.cityCode,
    required this.confidence,
    required this.imagePath,
  });

  final String rawText;
  final String normalizedPlate;
  final String firstTwoDigits;
  final String middleThreeDigits;
  final String letter;
  final String cityCode;
  final double confidence;
  final String imagePath;

  bool get hasRecognizedPlate =>
      firstTwoDigits.isNotEmpty &&
      middleThreeDigits.isNotEmpty &&
      letter.isNotEmpty &&
      cityCode.isNotEmpty;

  String get displayPlate =>
      rawText.isNotEmpty ? rawText : normalizedPlate;

  PlateRecognitionResult copyWith({
    String? rawText,
    String? normalizedPlate,
    String? firstTwoDigits,
    String? middleThreeDigits,
    String? letter,
    String? cityCode,
    double? confidence,
    String? imagePath,
  }) {
    return PlateRecognitionResult(
      rawText: rawText ?? this.rawText,
      normalizedPlate: normalizedPlate ?? this.normalizedPlate,
      firstTwoDigits: firstTwoDigits ?? this.firstTwoDigits,
      middleThreeDigits: middleThreeDigits ?? this.middleThreeDigits,
      letter: letter ?? this.letter,
      cityCode: cityCode ?? this.cityCode,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
