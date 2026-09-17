import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../entities/plate_recognition_result.dart';
import '../entities/plate_scanner_ui_state.dart';

/// کنترلر اسکن خودکار — بدون وابستگی به Widget.
abstract interface class PlateScannerController {
  Stream<PlateScannerUiState> get stateStream;

  PlateScannerUiState get currentState;

  /// بارگذاری مدل‌ها و آماده‌سازی pipeline.
  Future<void> initialize();

  /// شروع image stream و پردازش خودکار.
  Future<void> start({
    required CameraController cameraController,
    required Size previewSize,
    required PlateGuideRect guideRect,
  });

  Future<void> stop();

  Future<void> dispose();

  /// ریست consensus و ادامه اسکن.
  void rescan();

  /// تأیید پلاک تشخیص‌داده‌شده و ساخت نتیجه.
  PlateRecognitionResult? buildRecognitionResult({required String imagePath});

  Future<void> toggleFlash(CameraController controller);

  void onPreviewSizeChanged(Size previewSize, PlateGuideRect guideRect);

  /// پردازش تصویر نمونه (debug).
  Future<PlateRecognitionResult?> recognizeSampleBytes(
    List<int> rgbBytes,
    int width,
    int height, {
    required String imagePath,
  });
}

/// مستطیل راهنمای پلاک (کسر از اندازه preview).
class PlateGuideRect {
  const PlateGuideRect({
    required this.centerXFraction,
    required this.centerYFraction,
    required this.widthFraction,
    required this.heightFraction,
  });

  /// کادر پیش‌فرض مطابق overlay فعلی.
  static const standard = PlateGuideRect(
    centerXFraction: 0.5,
    centerYFraction: 0.38,
    widthFraction: 0.86,
    heightFraction: 0.86 * 0.28,
  );

  final double centerXFraction;
  final double centerYFraction;
  final double widthFraction;
  final double heightFraction;

  Rect toPreviewRect(Size previewSize) {
    final width = previewSize.width * widthFraction;
    final height = previewSize.height * heightFraction;
    final center = Offset(
      previewSize.width * centerXFraction,
      previewSize.height * centerYFraction,
    );
    return Rect.fromCenter(center: center, width: width, height: height);
  }
}
