import '../entities/plate_frame.dart';
import '../entities/plate_ocr_candidate.dart';

/// OCR اختصاصی پلاک ایرانی روی تصویر cropشده.
abstract interface class IranianPlateOcrService {
  Future<PlateOcrCandidate?> recognize(PlateImage plateImage);

  Future<void> dispose();
}
