import '../../domain/entities/iranian_plate_parts.dart';
import '../../domain/entities/plate_frame.dart';
import '../services/plate_ocr_text_parser.dart';

/// برچسب‌های مدل makhresearch (از app.py؛ نه model.names خراب‌شده).
abstract final class IranPlateYoloLabels {
  static const plateClassId = 30;

  /// کلاس → کاراکتر فارسی / رقم انگلیسی.
  static const charByClassId = <int, String>{
    0: '0',
    1: '1',
    2: '2',
    3: '3',
    4: '4',
    5: '5',
    6: '6',
    7: '7',
    8: '8',
    9: '9',
    10: 'ا',
    11: 'ب',
    12: 'ت',
    13: 'ث',
    14: 'ج',
    15: 'د',
    16: 'س',
    17: 'ش',
    18: 'ص',
    19: 'ط',
    20: 'ظ',
    21: 'ع',
    22: 'ق',
    23: 'ل',
    24: 'م',
    25: 'ن',
    26: 'ه',
    27: 'و',
    28: 'پ',
    29: 'ژ',
    31: 'ی',
  };

  static bool isPlateClass(int classId) => classId == plateClassId;

  static bool isCharacterClass(int classId) =>
      charByClassId.containsKey(classId);

  static String? charFor(int classId) => charByClassId[classId];
}

/// ساخت پلاک ایرانی از باکس‌های کاراکتر YOLO (مرتب‌سازی چپ→راست).
abstract final class PlateYoloCharacterAssembler {
  /// اگر ساختار ۸تایی کامل باشد [۲رقم][حرف][۳رقم][۲شهر] برمی‌گرداند.
  static IranianPlateParts? assemble(List<DetectedPlate> detections) {
    final chars = _characterBoxes(detections);
    if (chars.isEmpty) {
      return null;
    }

    final text = chars
        .map((box) => IranPlateYoloLabels.charFor(box.classId)!)
        .join();

    final parsed = PlateOcrTextParser.parseFreeform(text);
    if (parsed != null) {
      return parsed;
    }

    return _assembleBySlots(chars);
  }

  static List<DetectedPlate> _characterBoxes(List<DetectedPlate> detections) {
    final plateBox = detections
        .where((d) => IranPlateYoloLabels.isPlateClass(d.classId))
        .fold<DetectedPlate?>(null, (best, box) {
      if (best == null) {
        return box;
      }
      final bestArea = best.width * best.height;
      final boxArea = box.width * box.height;
      if (boxArea > bestArea) {
        return box;
      }
      if (boxArea == bestArea && box.confidence > best.confidence) {
        return box;
      }
      return best;
    });

    var chars = detections
        .where((d) => IranPlateYoloLabels.isCharacterClass(d.classId))
        .toList();

    if (plateBox != null) {
      final inside = chars.where((c) {
        final cx = c.centerX;
        final cy = c.centerY;
        return cx >= plateBox.left - 0.02 &&
            cx <= plateBox.right + 0.02 &&
            cy >= plateBox.top - 0.05 &&
            cy <= plateBox.bottom + 0.05;
      }).toList();
      if (inside.length >= 5) {
        chars = inside;
      }
    }

    chars.sort((a, b) => a.centerX.compareTo(b.centerX));
    return chars;
  }

  /// وقتی parseFreeform شکست بخورد ولی الگوی ۸ کاراکتر واضح باشد.
  static IranianPlateParts? _assembleBySlots(List<DetectedPlate> chars) {
    if (chars.length < 7) {
      return null;
    }

    // بهترین پنجره ۸تایی حول یک حرف
    for (var start = 0; start <= chars.length - 8; start++) {
      final window = chars.sublist(start, start + 8);
      final symbols =
          window.map((b) => IranPlateYoloLabels.charFor(b.classId)!).toList();
      final letterIndex = symbols.indexWhere((s) => RegExp(r'^\D$').hasMatch(s));
      if (letterIndex != 2) {
        continue;
      }
      final parts = PlateOcrTextParser.fromSegments(
        firstTwoDigits: '${symbols[0]}${symbols[1]}',
        letter: symbols[2],
        middleThreeDigits: '${symbols[3]}${symbols[4]}${symbols[5]}',
        cityCode: '${symbols[6]}${symbols[7]}',
      );
      if (parts != null) {
        return parts;
      }
      // حرف غیرمجاز در لیست selectable: باز هم فیلدها را پر کن
      if (RegExp(r'^\d{2}$').hasMatch('${symbols[0]}${symbols[1]}') &&
          RegExp(r'^\d{3}$').hasMatch('${symbols[3]}${symbols[4]}${symbols[5]}') &&
          RegExp(r'^\d{2}$').hasMatch('${symbols[6]}${symbols[7]}') &&
          symbols[2].length == 1) {
        return IranianPlateParts(
          firstTwoDigits: '${symbols[0]}${symbols[1]}',
          letter: symbols[2],
          middleThreeDigits: '${symbols[3]}${symbols[4]}${symbols[5]}',
          cityCode: '${symbols[6]}${symbols[7]}',
        );
      }
    }

    // ۷ کاراکتر: گاهی یک رقم جا می‌افتد — بهترین تلاش با حرف در ایندکس ۲
    if (chars.length == 7) {
      final symbols =
          chars.map((b) => IranPlateYoloLabels.charFor(b.classId)!).toList();
      if (RegExp(r'^\D$').hasMatch(symbols[2])) {
        return IranianPlateParts(
          firstTwoDigits: '${symbols[0]}${symbols[1]}',
          letter: symbols[2],
          middleThreeDigits: '${symbols[3]}${symbols[4]}${symbols[5]}',
          cityCode: symbols[6].padLeft(2, '0').substring(0, 2),
        );
      }
    }

    return null;
  }
}
