import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/services/laplacian_plate_quality_service.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_frame.dart';

PlateImage _solidImage(int value) {
  const w = 40;
  const h = 12;
  final bytes = List<int>.filled(w * h * 3, value);
  return PlateImage(bytes: bytes, width: w, height: h);
}

PlateImage _sharpCheckerImage() {
  const w = 160;
  const h = 40;
  final bytes = <int>[];
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final v = (x + y) % 2 == 0 ? 20 : 220;
      bytes.addAll([v, v, v]);
    }
  }
  return PlateImage(bytes: bytes, width: w, height: h);
}

void main() {
  group('LaplacianPlateQualityService', () {
    const service = LaplacianPlateQualityService();

    test('تصویر یکنواخت تار تشخیص داده می‌شود', () {
      final quality = service.evaluate(_solidImage(120));
      expect(quality.isAcceptable, isTrue);
      expect(quality.rejectionReason, 'گوشی را ثابت نگه دارید');
    });

    test('تصویر checkerboard واضح پذیرفته می‌شود', () {
      const service = LaplacianPlateQualityService(minBlurScore: 10);
      final quality = service.evaluate(
        _sharpCheckerImage(),
        detectedPlate: const DetectedPlate(
          left: 0.05,
          top: 0.38,
          right: 0.95,
          bottom: 0.63,
          confidence: 0.9,
        ),
      );
      expect(quality.isAcceptable, isTrue);
    });

    test('نور بسیار کم هم OCR را متوقف نمی‌کند', () {
      const service = LaplacianPlateQualityService(minBlurScore: 1);
      final dark = service.evaluate(_solidImage(5));
      expect(dark.isAcceptable, isTrue);
    });
  });
}
