import '../../domain/entities/plate_frame.dart';

/// پیش‌بینی یک رقم.
class DigitPrediction {
  const DigitPrediction({
    required this.digit,
    required this.confidence,
  });

  final String digit;
  final double confidence;

  bool get isValid => digit.isNotEmpty && confidence > 0;
}

/// پیش‌بینی یک حرف.
class LetterPrediction {
  const LetterPrediction({
    required this.letter,
    required this.confidence,
  });

  final String letter;
  final double confidence;

  bool get isValid => letter.isNotEmpty && confidence > 0;
}

/// بخش‌های crop شده پلاک normalize شده.
class PlateSegments {
  const PlateSegments({
    required this.firstDigit1,
    required this.firstDigit2,
    required this.letter,
    required this.middleDigit1,
    required this.middleDigit2,
    required this.middleDigit3,
    required this.cityDigit1,
    required this.cityDigit2,
    this.normalizedPlate,
  });

  final PlateImage firstDigit1;
  final PlateImage firstDigit2;
  final PlateImage letter;
  final PlateImage middleDigit1;
  final PlateImage middleDigit2;
  final PlateImage middleDigit3;
  final PlateImage cityDigit1;
  final PlateImage cityDigit2;
  final PlateImage? normalizedPlate;

  List<PlateImage> get digitSegments => [
        firstDigit1,
        firstDigit2,
        middleDigit1,
        middleDigit2,
        middleDigit3,
        cityDigit1,
        cityDigit2,
      ];
}
