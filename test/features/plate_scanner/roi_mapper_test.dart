import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mechanic_assistant/features/plate_scanner/data/ml/roi_mapper.dart';

void main() {
  group('RoiMapper', () {
    test('کادر مرکزی preview به crop سنسور ۰ درجه map می‌شود', () {
      const previewSize = Size(400, 800);
      const sensorSize = Size(1280, 720);
      const previewRect = Rect.fromLTWH(28, 254, 344, 96);

      final sensorRect = RoiMapper.mapPreviewRectToSensor(
        previewRect: previewRect,
        previewSize: previewSize,
        sensorSize: sensorSize,
        rotationDegrees: 0,
      );

      expect(sensorRect.width, greaterThan(0));
      expect(sensorRect.height, greaterThan(0));
      expect(sensorRect.left, greaterThanOrEqualTo(0));
      expect(sensorRect.top, greaterThanOrEqualTo(0));
      expect(sensorRect.right, lessThanOrEqualTo(sensorSize.width));
      expect(sensorRect.bottom, lessThanOrEqualTo(sensorSize.height));
    });

    test('rotation ۹۰ درجه ابعاد را جابه‌جا می‌کند', () {
      const previewSize = Size(400, 800);
      const sensorSize = Size(1280, 720);
      const previewRect = Rect.fromLTWH(28, 254, 344, 96);

      final rect0 = RoiMapper.mapPreviewRectToSensor(
        previewRect: previewRect,
        previewSize: previewSize,
        sensorSize: sensorSize,
        rotationDegrees: 0,
      );
      final rect90 = RoiMapper.mapPreviewRectToSensor(
        previewRect: previewRect,
        previewSize: previewSize,
        sensorSize: sensorSize,
        rotationDegrees: 90,
      );

      expect(rect0, isNot(equals(rect90)));
    });

    test('BoxFit.cover crop معتبر در rotation ۹۰ درجه تولید می‌کند', () {
      const previewSize = Size(1080, 1920);
      const sensorSize = Size(1920, 1080);
      final centerRect = Rect.fromCenter(
        center: const Offset(540, 729.6),
        width: 928.8,
        height: 260.064,
      );

      final mapped = RoiMapper.mapPreviewRectToSensor(
        previewRect: centerRect,
        previewSize: previewSize,
        sensorSize: sensorSize,
        rotationDegrees: 90,
      );

      expect(mapped.width, greaterThan(0));
      expect(mapped.height, greaterThan(0));
      expect(mapped.left, greaterThanOrEqualTo(0));
      expect(mapped.top, greaterThanOrEqualTo(0));
    });
  });
}
