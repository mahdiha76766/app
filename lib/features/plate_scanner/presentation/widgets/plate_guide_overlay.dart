import 'package:flutter/material.dart';

import '../../domain/entities/plate_scanner_ui_state.dart';
import '../../domain/services/plate_scanner_controller.dart';

/// کادر راهنمای پلاک با رنگ متناسب وضعیت.
class PlateGuideOverlay extends StatelessWidget {
  const PlateGuideOverlay({
    super.key,
    required this.guideColor,
    this.guideRect = PlateGuideRect.standard,
  });

  final PlateGuideColor guideColor;
  final PlateGuideRect guideRect;

  Color _borderColor() {
    return switch (guideColor) {
      PlateGuideColor.grey => Colors.white70,
      PlateGuideColor.yellow => const Color(0xFFFFC107),
      PlateGuideColor.blue => const Color(0xFF42A5F5),
      PlateGuideColor.green => const Color(0xFF66BB6A),
      PlateGuideColor.red => const Color(0xFFEF5350),
    };
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _PlateGuidePainter(
          guideRect: guideRect,
          borderColor: _borderColor(),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PlateGuidePainter extends CustomPainter {
  _PlateGuidePainter({
    required this.guideRect,
    required this.borderColor,
  });

  final PlateGuideRect guideRect;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final frameRect = guideRect.toPreviewRect(size);

    final overlayPaint = Paint()..color = const Color(0x55000000);
    final fullPath = Path()..addRect(Offset.zero & size);
    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(frameRect, const Radius.circular(12)),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, holePath),
      overlayPaint,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(12)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlateGuidePainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.guideRect != guideRect;
  }
}
