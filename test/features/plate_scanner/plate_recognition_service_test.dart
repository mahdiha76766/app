import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/core/errors/not_implemented_exception.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/api_plate_recognition_service.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/manual_plate_recognition_service.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/mock_plate_recognition_service.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/plate_scan_flow.dart';

void main() {
  group('PlateRecognitionService implementations', () {
    test('Mock پلاک نمونه معتبر برمی‌گرداند', () async {
      const service = MockPlateRecognitionService();
      final result = await service.recognize('/tmp/plate.jpg');

      expect(result.imagePath, '/tmp/plate.jpg');
      expect(result.firstTwoDigits, '45');
      expect(result.middleThreeDigits, '123');
      expect(result.letter, 'ب');
      expect(result.cityCode, '11');
      expect(result.normalizedPlate, '45-B-123-11');
      expect(result.confidence, greaterThan(0));
      expect(result.hasRecognizedPlate, isTrue);
    });

    test('Manual پلاک خالی برای اصلاح دستی برمی‌گرداند', () async {
      const service = ManualPlateRecognitionService();
      final result = await service.recognize('/tmp/manual.jpg');

      expect(result.imagePath, '/tmp/manual.jpg');
      expect(result.firstTwoDigits, isEmpty);
      expect(result.middleThreeDigits, isEmpty);
      expect(result.letter, isEmpty);
      expect(result.cityCode, isEmpty);
      expect(result.normalizedPlate, isEmpty);
      expect(result.confidence, 0);
      expect(result.hasRecognizedPlate, isFalse);
    });

    test('Api با NotImplementedException خطا می‌دهد', () async {
      const service = ApiPlateRecognitionService(
        baseUrl: 'https://api.example.com',
      );

      expect(service.recognizeEndpoint?.toString(), contains('/api/v1/plates/recognize'));
      await expectLater(
        service.recognize('/tmp/api.jpg'),
        throwsA(isA<NotImplementedException>()),
      );
    });
  });

  group('PlateScanFlow', () {
    test('عکس را با سرویس فعال پردازش می‌کند', () async {
      const service = MockPlateRecognitionService(
        firstTwoDigits: '78',
        middleThreeDigits: '456',
        letter: 'ص',
        cityCode: '12',
      );
      const flow = PlateScanFlow(service);

      final result = await flow.processCapturedImage('/captures/a.jpg');

      expect(result.imagePath, '/captures/a.jpg');
      expect(result.normalizedPlate, '78-C-456-12');
      expect(result.letter, 'ص');
    });

    test('خطای Api را از flow عبور می‌دهد', () async {
      const flow = PlateScanFlow(ApiPlateRecognitionService());

      await expectLater(
        flow.processCapturedImage('/captures/b.jpg'),
        throwsA(isA<NotImplementedException>()),
      );
    });

    test('حالت manual را برای صفحه تأیید خالی آماده می‌کند', () async {
      const flow = PlateScanFlow(ManualPlateRecognitionService());
      final result = await flow.processCapturedImage('/captures/c.jpg');

      expect(result.hasRecognizedPlate, isFalse);
      expect(result.imagePath, '/captures/c.jpg');
    });
  });
}
