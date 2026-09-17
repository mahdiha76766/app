import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_recognition_result.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/entities/plate_scanner_ui_state.dart';
import 'package:mechanic_assistant/features/plate_scanner/domain/services/plate_scanner_controller.dart';

class FakePlateScannerController implements PlateScannerController {
  FakePlateScannerController({
    this.initialState = const PlateScannerUiState(
      phase: PlateScanPhase.searching,
      statusMessage: 'پلاک را داخل کادر قرار دهید',
    ),
  });

  final PlateScannerUiState initialState;
  final _controller = StreamController<PlateScannerUiState>.broadcast();
  late PlateScannerUiState _state;

  FakePlateScannerController.auto() : this();

  @override
  Stream<PlateScannerUiState> get stateStream => _controller.stream;

  @override
  PlateScannerUiState get currentState => _state;

  @override
  Future<void> initialize() async {
    _state = initialState;
    _controller.add(_state);
  }

  @override
  Future<void> start({
    required CameraController cameraController,
    required Size previewSize,
    required PlateGuideRect guideRect,
  }) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  void rescan() {}

  @override
  PlateRecognitionResult? buildRecognitionResult({required String imagePath}) =>
      null;

  @override
  Future<void> toggleFlash(CameraController controller) async {}

  @override
  void onPreviewSizeChanged(Size previewSize, PlateGuideRect guideRect) {}

  @override
  Future<PlateRecognitionResult?> recognizeSampleBytes(
    List<int> rgbBytes,
    int width,
    int height, {
    required String imagePath,
  }) async =>
      null;
}
