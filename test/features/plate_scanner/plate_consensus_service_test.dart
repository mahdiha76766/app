import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/plate_consensus_service_impl.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/iranian_plate_parts.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_consensus_result.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_ocr_candidate.dart';

PlateOcrCandidate _candidate({
  required String firstTwoDigits,
  required String letter,
  required String middleThreeDigits,
  required String cityCode,
  double confidence = 0.9,
}) {
  return PlateOcrCandidate(
    plate: IranianPlateParts(
      firstTwoDigits: firstTwoDigits,
      letter: letter,
      middleThreeDigits: middleThreeDigits,
      cityCode: cityCode,
    ),
    confidence: confidence,
    timestamp: DateTime.now(),
  );
}

void main() {
  group('PlateConsensusServiceImpl', () {
    test('با ۲ فریم یکسان پلاک را می‌پذیرد', () {
      final service = PlateConsensusServiceImpl();
      PlateConsensusResult? last;

      for (var i = 0; i < 2; i++) {
        last = service.addCandidate(
          _candidate(
            firstTwoDigits: '12',
            letter: 'ب',
            middleThreeDigits: '345',
            cityCode: '67',
          ),
        );
      }

      expect(last!.isAccepted, isTrue);
      expect(last.plate?.display, contains('۱۲'));
      expect(last.plate?.middleThreeDigits, '345');
      expect(last.averageConfidence, greaterThanOrEqualTo(0.85));
    });

    test('دو نتیجه مشابه پشت‌سرهم پذیرفته می‌شود', () {
      final service = PlateConsensusServiceImpl();

      service.addCandidate(
        _candidate(
          firstTwoDigits: '12',
          letter: 'ب',
          middleThreeDigits: '345',
          cityCode: '67',
        ),
      );
      final last = service.addCandidate(
        _candidate(
          firstTwoDigits: '12',
          letter: 'ب',
          middleThreeDigits: '345',
          cityCode: '67',
        ),
      );

      expect(last.isAccepted, isTrue);
      expect(last.plate?.middleThreeDigits, '345');
    });

    test('یک فریم به‌تنهایی پذیرفته نمی‌شود', () {
      final service = PlateConsensusServiceImpl();
      final result = service.addCandidate(
        _candidate(
          firstTwoDigits: '12',
          letter: 'ب',
          middleThreeDigits: '345',
          cityCode: '67',
        ),
      );

      expect(result.isAccepted, isFalse);
      expect(result.voteCount, 1);
    });

    test('confidence پایین رد می‌شود', () {
      final service = PlateConsensusServiceImpl();
      PlateConsensusResult? last;
      for (var i = 0; i < 2; i++) {
        last = service.addCandidate(
          _candidate(
            firstTwoDigits: '12',
            letter: 'ب',
            middleThreeDigits: '345',
            cityCode: '67',
            confidence: 0.5,
          ),
        );
      }

      expect(last!.isAccepted, isFalse);
    });

    test('reset بافر را پاک می‌کند', () {
      final service = PlateConsensusServiceImpl();
      service.addCandidate(
        _candidate(
          firstTwoDigits: '12',
          letter: 'ب',
          middleThreeDigits: '345',
          cityCode: '67',
        ),
      );
      service.reset();
      final result = service.addCandidate(
        _candidate(
          firstTwoDigits: '12',
          letter: 'ب',
          middleThreeDigits: '345',
          cityCode: '67',
        ),
      );
      expect(result.voteCount, 1);
    });
  });
}
