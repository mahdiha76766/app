import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/plate_frame.dart';

/// پیش‌پردازش ROI پلاک قبل از OCR.
class PlateImagePreprocessor {
  const PlateImagePreprocessor({
    this.targetWidth = 320,
    this.contrastAmount = 1.35,
  });

  final int targetWidth;
  final double contrastAmount;

  /// تبدیل PlateImage به PNG موقت و برگرداندن مسیر + bytes پردازش‌شده.
  Future<PreprocessedPlateImage?> preprocess(PlateImage source) async {
    if (source.width <= 0 ||
        source.height <= 0 ||
        source.bytes.length < source.width * source.height * source.channels) {
      return null;
    }

    final image = img.Image.fromBytes(
      width: source.width,
      height: source.height,
      bytes: Uint8List.fromList(source.bytes).buffer,
      numChannels: source.channels,
      order: img.ChannelOrder.rgb,
    );

    var processed = img.grayscale(image);
    final scale = targetWidth / processed.width;
    if (scale > 0 && (scale - 1).abs() > 0.05) {
      processed = img.copyResize(
        processed,
        width: targetWidth,
        height: (processed.height * scale).round().clamp(1, 4096),
        interpolation: img.Interpolation.linear,
      );
    }
    processed = img.adjustColor(processed, contrast: contrastAmount);
    processed = img.gaussianBlur(processed, radius: 1);
    processed = _fastThreshold(processed, threshold: 150);

    final pngBytes = img.encodePng(processed);
    final tempDir = await getTemporaryDirectory();
    final filePath = p.join(
      tempDir.path,
      'plate_roi_${DateTime.now().microsecondsSinceEpoch}.png',
    );
    await File(filePath).writeAsBytes(pngBytes, flush: true);

    return PreprocessedPlateImage(
      filePath: filePath,
      image: processed,
      pngBytes: pngBytes,
    );
  }

  img.Image _fastThreshold(img.Image gray, {required int threshold}) {
    final output = img.Image(width: gray.width, height: gray.height);
    for (var y = 0; y < gray.height; y++) {
      for (var x = 0; x < gray.width; x++) {
        final pixel = gray.getPixel(x, y).r.toInt();
        final value = pixel >= threshold ? 255 : 0;
        output.setPixelRgb(x, y, value, value, value);
      }
    }
    return output;
  }
}

class PreprocessedPlateImage {
  const PreprocessedPlateImage({
    required this.filePath,
    required this.image,
    required this.pngBytes,
  });

  final String filePath;
  final img.Image image;
  final Uint8List pngBytes;
}
