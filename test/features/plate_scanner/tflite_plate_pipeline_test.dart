import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/widgets/iranian_plate_widget.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/iran_plate_models_config.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/iran_plate_yolo_labels.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/plate_character_segment_layout.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/plate_detector_output_parser.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/fast_plate_voting_service.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/iranian_plate_parts.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_frame.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_recognition_candidate.dart';

void main() {
  group('IranPlateModelsConfig', () {
    test('fromJsonString parses detector, recognizer and classifiers', () {
      const raw = '''
{
  "mode": "auto",
  "detector": {
    "path": "assets/models/iran_plate_detector.tflite",
    "inputWidth": 320,
    "inputHeight": 320,
    "confidenceThreshold": 0.55,
    "iouThreshold": 0.45
  },
  "recognizer": {
    "path": "assets/models/iran_plate_recognizer.tflite",
    "inputWidth": 160,
    "inputHeight": 48,
    "confidenceThreshold": 0.65
  },
  "digitClassifier": {
    "path": "assets/models/iran_plate_digit_classifier.tflite",
    "inputWidth": 32,
    "inputHeight": 48,
    "classes": ["0","1","2","3","4","5","6","7","8","9"],
    "confidenceThreshold": 0.70
  },
  "letterClassifier": {
    "path": "assets/models/iran_plate_letter_classifier.tflite",
    "inputWidth": 40,
    "inputHeight": 48,
    "classes": ["ب","ج","د"],
    "confidenceThreshold": 0.65
  }
}
''';
      final config = IranPlateModelsConfig.fromJsonString(raw);
      expect(config.mode, 'auto');
      expect(config.detector.confidenceThreshold, 0.55);
      expect(config.recognizer.inputWidth, 160);
      expect(config.digitClassifier.classes, hasLength(10));
      expect(config.letterClassifier.classes.first, 'ب');
    });
  });

  group('PlateCharacterSegmentLayout', () {
    test('8 segment rects inside normalized plate', () {
      const w = 280;
      const h = 64;
      final rects = [
        PlateCharacterSegmentLayout.firstDigit1Rect(w, h),
        PlateCharacterSegmentLayout.firstDigit2Rect(w, h),
        PlateCharacterSegmentLayout.letterRect(w, h),
        PlateCharacterSegmentLayout.middleDigit1Rect(w, h),
        PlateCharacterSegmentLayout.middleDigit2Rect(w, h),
        PlateCharacterSegmentLayout.middleDigit3Rect(w, h),
        PlateCharacterSegmentLayout.cityDigit1Rect(w, h),
        PlateCharacterSegmentLayout.cityDigit2Rect(w, h),
      ];

      expect(rects, hasLength(8));
      for (final rect in rects) {
        expect(rect.width, greaterThan(0));
        expect(rect.height, greaterThan(0));
        expect(rect.right, lessThanOrEqualTo(w.toDouble()));
        expect(rect.bottom, lessThanOrEqualTo(h.toDouble()));
      }

      expect(
        PlateCharacterSegmentLayout.cityDigit2Rect(w, h).right,
        greaterThan(PlateCharacterSegmentLayout.cityDigit1Rect(w, h).left),
      );
    });
  });

  group('PlateDetectorOutputParser', () {
    test('parse YOLO-like output and pick best', () {
      final output = <double>[
        0.5, 0.5, 0.8, 0.2, 0.9, 0,
        0.1, 0.1, 0.2, 0.1, 0.3, 0,
      ];
      final parsed = PlateDetectorOutputParser.parseYoloLike(
        output: output,
        shape: [1, 2, 6],
        confidenceThreshold: 0.55,
      );
      final best = PlateDetectorOutputParser.pickBest(parsed);
      expect(best, isNotNull);
      expect(best!.confidence, 0.9);
    });

    test('parse Ultralytics channels-first output', () {
      final output = <double>[
        160, 10,
        160, 10,
        80, 5,
        40, 5,
        0.92, 0.1,
      ];
      final parsed = PlateDetectorOutputParser.parseYoloLike(
        output: output,
        shape: [1, 5, 2],
        confidenceThreshold: 0.55,
        inputWidth: 320,
        inputHeight: 320,
      );
      final best = PlateDetectorOutputParser.pickBest(parsed);
      expect(best, isNotNull);
      expect(best!.confidence, closeTo(0.92, 0.001));
      expect(best.left, greaterThan(0));
      expect(best.right, lessThan(1));
      // بزرگ‌ترین باکس انتخاب می‌شود (نه فقط بالاترین confidence)
      expect(best.width * best.height, greaterThan(0.01));
    });
  });

  group('FastPlateVotingService', () {
    test('high confidence accepts immediately', () {
      final voting = FastPlateVotingService();
      final candidate = PlateRecognitionCandidate(
        plate: const IranianPlateParts(
          firstTwoDigits: '52',
          letter: 'د',
          middleThreeDigits: '689',
          cityCode: '11',
        ),
        confidence: 0.9,
        timestamp: DateTime.now(),
      );

      final result = voting.addCandidate(candidate);
      expect(result.isAccepted, isTrue);
      expect(result.plate?.display, contains('۱۱'));
    });

    test('two similar medium-confidence frames accepted', () {
      final voting = FastPlateVotingService();
      final plate = const IranianPlateParts(
        firstTwoDigits: '52',
        letter: 'د',
        middleThreeDigits: '689',
        cityCode: '11',
      );
      final now = DateTime.now();

      voting.addCandidate(
        PlateRecognitionCandidate(
          plate: plate,
          confidence: 0.75,
          timestamp: now,
        ),
      );
      final result = voting.addCandidate(
        PlateRecognitionCandidate(
          plate: plate,
          confidence: 0.76,
          timestamp: now.add(const Duration(milliseconds: 100)),
        ),
      );

      expect(result.isAccepted, isTrue);
      expect(result.voteCount, 2);
    });
  });

  group('IranianPlateValue', () {
    test('display and normalized storage order', () {
      const value = IranianPlateValue(
        firstTwoDigits: '52',
        letter: 'د',
        middleThreeDigits: '689',
        cityCode: '11',
      );

      expect(value.display, contains('۱۱'));
      expect(value.normalized, '52-D-689-11');
      expect(value.isComplete, isTrue);
    });
  });

  group('PlateYoloCharacterAssembler', () {
    test('assembles LTR character boxes into Iranian plate parts', () {
      // 95 م 881 99
      final detections = <DetectedPlate>[
        const DetectedPlate(
          left: 0.10,
          top: 0.4,
          right: 0.90,
          bottom: 0.6,
          confidence: 0.9,
          classId: 30,
        ),
        const DetectedPlate(
          left: 0.12,
          top: 0.42,
          right: 0.18,
          bottom: 0.58,
          confidence: 0.9,
          classId: 9,
        ),
        const DetectedPlate(
          left: 0.20,
          top: 0.42,
          right: 0.26,
          bottom: 0.58,
          confidence: 0.9,
          classId: 5,
        ),
        const DetectedPlate(
          left: 0.30,
          top: 0.42,
          right: 0.38,
          bottom: 0.58,
          confidence: 0.9,
          classId: 24,
        ),
        const DetectedPlate(
          left: 0.42,
          top: 0.42,
          right: 0.48,
          bottom: 0.58,
          confidence: 0.9,
          classId: 8,
        ),
        const DetectedPlate(
          left: 0.50,
          top: 0.42,
          right: 0.56,
          bottom: 0.58,
          confidence: 0.9,
          classId: 8,
        ),
        const DetectedPlate(
          left: 0.58,
          top: 0.42,
          right: 0.64,
          bottom: 0.58,
          confidence: 0.9,
          classId: 1,
        ),
        const DetectedPlate(
          left: 0.70,
          top: 0.42,
          right: 0.76,
          bottom: 0.58,
          confidence: 0.9,
          classId: 9,
        ),
        const DetectedPlate(
          left: 0.78,
          top: 0.42,
          right: 0.84,
          bottom: 0.58,
          confidence: 0.9,
          classId: 9,
        ),
      ];

      final plate = PlateYoloCharacterAssembler.assemble(detections);
      expect(plate, isNotNull);
      expect(plate!.firstTwoDigits, '95');
      expect(plate.letter, 'م');
      expect(plate.middleThreeDigits, '881');
      expect(plate.cityCode, '99');
    });
  });
}
