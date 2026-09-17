import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../domain/entities/plate_scanner_ui_state.dart';

/// پنل debug برای توسعه (فقط debug mode).
class PlateScanDebugPanel extends StatelessWidget {
  const PlateScanDebugPanel({
    super.key,
    required this.stats,
  });

  final PlateScanDebugStats stats;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 8, top: 8),
        padding: const EdgeInsets.all(8),
        width: 220,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white70, fontSize: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (stats.activeEngineName != null)
                Text('engine: ${stats.activeEngineName}'),
              if (stats.modelStatusMessage != null)
                Text('model: ${stats.modelStatusMessage}'),
              Text('FPS cam: ${stats.cameraFps.toStringAsFixed(1)}'),
              Text('FPS proc: ${stats.processFps.toStringAsFixed(1)}'),
              Text('detector: ${stats.detectorMs.toStringAsFixed(0)} ms'),
              Text('classifier: ${stats.classifierMs.toStringAsFixed(0)} ms'),
              Text('total: ${stats.processingMs} ms'),
              Text('det conf: ${stats.detectorConfidence.toStringAsFixed(2)}'),
              Text('letter conf: ${stats.letterConfidence.toStringAsFixed(2)}'),
              if (stats.digitConfidences.isNotEmpty)
                Text(
                  'digits: ${stats.digitConfidences.map((v) => v.toStringAsFixed(2)).join(', ')}',
                ),
              Text('conf: ${stats.confidence.toStringAsFixed(2)}'),
              Text('votes: ${stats.consensusVotes}'),
              if (stats.currentCandidate.isNotEmpty)
                Text('candidate: ${stats.currentCandidate}'),
              if (stats.detectedBbox != null)
                Text('bbox: ${stats.detectedBbox}'),
              if (stats.lastRejection.isNotEmpty)
                Text('reject: ${stats.lastRejection}'),
              if (stats.roiPreviewBytes != null) ...[
                const SizedBox(height: 6),
                _RoiPreview(
                  bytes: stats.roiPreviewBytes!,
                  width: stats.roiPreviewWidth,
                  height: stats.roiPreviewHeight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _RoiPreview extends StatelessWidget {
  const _RoiPreview({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final List<int> bytes;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    final encoded = encodeRoiPreview(bytes, width, height);
    return Container(
      height: 72,
      width: double.infinity,
      color: Colors.white12,
      alignment: Alignment.center,
      child: encoded == null
          ? Text('ROI ${bytes.length} B')
          : Image.memory(
              encoded,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
    );
  }
}

/// ذخیره ROI RGB به PNG برای preview (debug).
Uint8List? encodeRoiPreview(List<int> rgb, int width, int height) {
  if (!kDebugMode || width <= 0 || height <= 0) {
    return null;
  }
  try {
    final image = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: Uint8List.fromList(rgb).buffer,
      numChannels: 3,
      order: img.ChannelOrder.rgb,
    );
    return Uint8List.fromList(img.encodePng(image));
  } catch (_) {
    return null;
  }
}
