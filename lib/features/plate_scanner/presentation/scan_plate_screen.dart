import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_page_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';


import '../../home/presentation/widgets/plate_entry_bottom_sheet.dart';
import '../data/providers.dart';
import '../domain/entities/plate_scanner_ui_state.dart';
import '../domain/services/plate_scanner_controller.dart';
import 'widgets/plate_guide_overlay.dart';
import 'widgets/plate_scan_debug_panel.dart';

/// صفحه اسکن خودکار پلاک با image stream و consensus.
class ScanPlateScreen extends ConsumerStatefulWidget {
  const ScanPlateScreen({super.key});

  @override
  ConsumerState<ScanPlateScreen> createState() => _ScanPlateScreenState();
}

class _ScanPlateScreenState extends ConsumerState<ScanPlateScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  StreamSubscription<PlateScannerUiState>? _stateSub;
  PlateScannerUiState _uiState = const PlateScannerUiState();
  bool _permissionDenied = false;
  String? _cameraError;
  final _previewKey = GlobalKey();
  Size _previewSize = Size.zero;
  bool _isNavigatingToConfirm = false;
  bool _isLeavingScanner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_lockPortrait());
    unawaited(_bootstrap());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateSub?.cancel();
    final camera = _controller;
    _controller = null;
    // قبل از dispose ویجت، رفرنس را بگیر؛ بعد از super.dispose دیگر ref مجاز نیست.
    final scanner = ref.read(plateScannerControllerProvider);
    unawaited(camera?.dispose());
    unawaited(scanner.stop());
    unawaited(_restoreOrientation());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      unawaited(_stopStream());
      unawaited(controller.dispose());
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      unawaited(_setupCamera());
    }
  }

  Future<void> _lockPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Future<void> _restoreOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  Future<void> _bootstrap() async {
    final scanner = ref.read(plateScannerControllerProvider);
    _stateSub = scanner.stateStream.listen((state) {
      if (!mounted) return;
      // فقط وقتی وضعیت واقعاً عوض شد UI را rebuild کن تا preview روان بماند.
      final phaseChanged = state.phase != _uiState.phase;
      final colorChanged = state.guideColor != _uiState.guideColor;
      final helpChanged = state.helpVisible != _uiState.helpVisible;
      if (!phaseChanged && !colorChanged && !helpChanged) {
        return;
      }
      setState(() => _uiState = state);
      if (state.phase == PlateScanPhase.success && !_isNavigatingToConfirm) {
        _isNavigatingToConfirm = true;
        unawaited(_confirmPlate());
      }
    });
    await scanner.initialize();
    await _setupCamera();
  }

  Future<void> _setupCamera() async {
    if (_isLeavingScanner) {
      return;
    }

    setState(() {
      _permissionDenied = false;
      _cameraError = null;
    });

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (!mounted) {
        return;
      }
      setState(() => _permissionDenied = true);
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw StateError('دوربینی روی این دستگاه پیدا نشد.');
      }

      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: defaultTargetPlatform == TargetPlatform.android
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);
      await controller.setFocusMode(FocusMode.auto);
      await controller.setExposureMode(ExposureMode.auto);

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _controller = controller);
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScan());
    } catch (error) {
      debugPrint('Camera init error: $error');
      if (!mounted) {
        return;
      }
      setState(
        () => _cameraError = 'خطا در راه‌اندازی دوربین. دوباره تلاش کنید.',
      );
    }
  }


  Future<void> _startAutoScan() async {
    if (_isLeavingScanner) {
      return;
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final box = _previewKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      _previewSize = box.size;
    } else {
      _previewSize = MediaQuery.sizeOf(context);
    }

    final scanner = ref.read(plateScannerControllerProvider);
    scanner.onPreviewSizeChanged(_previewSize, PlateGuideRect.standard);
    await scanner.start(
      cameraController: controller,
      previewSize: _previewSize,
      guideRect: PlateGuideRect.standard,
    );
  }

  Future<void> _stopStream() async {
    await ref.read(plateScannerControllerProvider).stop();
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    await ref.read(plateScannerControllerProvider).toggleFlash(controller);
  }

  void _openManualEntry() {
    showPlateEntryBottomSheet(context);
  }

  Future<void> _testWithSampleImage() async {
    if (_isNavigatingToConfirm || _isLeavingScanner) {
      return;
    }
    try {
      final data = await rootBundle.load('assets/branding/pelak.jpg');
      final decoded = img.decodeImage(data.buffer.asUint8List());
      if (decoded == null || !mounted) {
        return;
      }
      final rgb = decoded.getBytes(order: img.ChannelOrder.rgb);
      final appDir = await getApplicationDocumentsDirectory();
      final capturesDir = Directory(p.join(appDir.path, 'plate_captures'));
      if (!await capturesDir.exists()) {
        await capturesDir.create(recursive: true);
      }
      final sampleFile = File(p.join(capturesDir.path, 'sample_pelak.jpg'));
      await sampleFile.writeAsBytes(data.buffer.asUint8List());

      final scanner = ref.read(plateScannerControllerProvider);
      final result = await scanner.recognizeSampleBytes(
        rgb,
        decoded.width,
        decoded.height,
        imagePath: sampleFile.path,
      );
      if (!mounted) {
        return;
      }
      if (result == null) {
        final engine = scanner.currentState.activeEngineName ?? '';
        final hasDetector = engine.contains('detector');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hasDetector
                  ? 'پلاک در تصویر نمونه پیدا نشد'
                  : 'مدل آفلاین هنوز نصب نشده؛ اول مدل‌ها را اضافه کنید',
            ),
          ),
        );
        return;
      }

      // اگر crop پلاک در controller ذخیره شده، همان را برای تأیید بنویس.
      var imagePath = result.imagePath;
      final frozen = scanner.currentState.frozenPreviewBytes;
      final fw = scanner.currentState.frozenRoiWidth;
      final fh = scanner.currentState.frozenRoiHeight;
      if (frozen != null && frozen.isNotEmpty && fw > 0 && fh > 0) {
        final cropPath = p.join(capturesDir.path, 'sample_pelak_crop.png');
        final image = img.Image.fromBytes(
          width: fw,
          height: fh,
          bytes: Uint8List.fromList(frozen).buffer,
          numChannels: 3,
          order: img.ChannelOrder.rgb,
        );
        await File(cropPath).writeAsBytes(img.encodePng(image));
        imagePath = cropPath;
      }

      _isNavigatingToConfirm = true;
      _isLeavingScanner = true;
      await _releaseCameraForNavigation();
      if (!mounted) {
        return;
      }
      await context.push(
        '/scan/confirm',
        extra: result.copyWith(imagePath: imagePath),
      );
      if (mounted) {
        await _resumeScanningAfterConfirm();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در تست نمونه: $error')),
        );
      }
    }
  }

  Future<void> _confirmPlate() async {
    if (_isLeavingScanner) {
      return;
    }
    _isLeavingScanner = true;
    final scanner = ref.read(plateScannerControllerProvider);
    final imagePath = await _persistFrozenPreview();
    final result = scanner.buildRecognitionResult(imagePath: imagePath);
    if (result == null || !mounted) {
      _isLeavingScanner = false;
      _isNavigatingToConfirm = false;
      return;
    }
    await _releaseCameraForNavigation();
    if (!mounted) {
      return;
    }
    await context.push('/scan/confirm', extra: result);
    if (mounted) {
      await _resumeScanningAfterConfirm();
    }
  }

  /// بعد از برگشت از صفحه تأیید، اسکن را از نو فعال کن.
  Future<void> _resumeScanningAfterConfirm() async {
    _isLeavingScanner = false;
    _isNavigatingToConfirm = false;
    ref.read(plateScannerControllerProvider).rescan();
    if (!mounted) {
      return;
    }
    await _setupCamera();
  }

  Future<void> _releaseCameraForNavigation() async {
    await _stopStream();
    final controller = _controller;
    if (mounted) {
      setState(() => _controller = null);
    } else {
      _controller = null;
    }
    if (controller != null) {
      await controller.dispose();
    }
  }

  Future<String> _persistFrozenPreview() async {
    final bytes = _uiState.frozenPreviewBytes;
    final directory = await getApplicationDocumentsDirectory();
    final platesDir = Directory(p.join(directory.path, 'plate_captures'));
    if (!await platesDir.exists()) {
      await platesDir.create(recursive: true);
    }
    final targetPath = p.join(platesDir.path, '${const Uuid().v4()}.png');

    if (bytes != null && bytes.isNotEmpty && _uiState.frozenRoiWidth > 0) {
      final image = img.Image.fromBytes(
        width: _uiState.frozenRoiWidth,
        height: _uiState.frozenRoiHeight,
        bytes: Uint8List.fromList(bytes).buffer,
        numChannels: 3,
        order: img.ChannelOrder.rgb,
      );
      await File(targetPath).writeAsBytes(img.encodePng(image));
      return targetPath;
    }
    await File(targetPath).writeAsBytes([]);
    return targetPath;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppPageAppBar(
        title: 'اسکن پلاک',
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_permissionDenied)
            _PermissionDeniedView(onRetry: _setupCamera)
          else if (_cameraError != null)
            _CameraErrorView(message: _cameraError!, onRetry: _setupCamera)
          else if (_controller == null ||
              !_controller!.value.isInitialized ||
              _isLeavingScanner)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else
            KeyedSubtree(
              key: _previewKey,
              child: CameraPreview(_controller!),
            ),
          if (!_permissionDenied && _cameraError == null) ...[
            PlateGuideOverlay(
              guideColor: _uiState.guideColor,
              guideRect: PlateGuideRect.standard,
            ),
            if (kDebugMode)
              PlateScanDebugPanel(stats: _uiState.debugStats),
            if (kDebugMode)
              Positioned(
                left: 8,
                bottom: 100,
                child: TextButton(
                  onPressed: _testWithSampleImage,
                  style: TextButton.styleFrom(foregroundColor: Colors.white70),
                  child: const Text('تست با تصویر نمونه'),
                ),
              ),
            if (_uiState.helpVisible)
              Positioned(
                left: 20,
                right: 20,
                top: MediaQuery.paddingOf(context).top + 56,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'پلاک پیدا نشد — دستی وارد کنید',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 120,
              child: Text(
                _uiState.phase == PlateScanPhase.reading
                    ? 'در حال خواندن...'
                    : 'پلاک را در کادر قرار دهید',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  shadows: const [
                    Shadow(color: Colors.black54, blurRadius: 6),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 28,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filled(
                      onPressed: _openManualEntry,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white24,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.keyboard_outlined),
                      tooltip: 'ورود دستی',
                    ),
                    const SizedBox(width: 16),
                    IconButton.filled(
                      onPressed: _toggleFlash,
                      style: IconButton.styleFrom(
                        backgroundColor: _uiState.flashOn
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white24,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(
                        _uiState.flashOn ? Icons.flash_on : Icons.flash_off,
                      ),
                      tooltip: 'فلش',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  const _PermissionDeniedView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography_outlined,
                color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              'دسترسی به دوربین لازم است',
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('درخواست مجدد')),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: openAppSettings,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('باز کردن تنظیمات'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('تلاش مجدد')),
          ],
        ),
      ),
    );
  }
}

/// سازگاری با نام قبلی مسیر.
typedef ScanPage = ScanPlateScreen;
