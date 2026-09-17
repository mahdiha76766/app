/// حالت فعال مدل‌های آفلاین.
enum PlateModelMode {
  /// detector + recognizer (CRNN و مشابه).
  detectorRecognizer,

  /// detector + digit/letter classifiers.
  detectorClassifiers,

  /// فقط detector.
  detectorOnly,

  /// هیچ مدلی موجود نیست.
  none,
}

/// وضعیت در دسترس بودن مدل‌های آفلاین پلاک.
enum PlateModelAvailability {
  /// اسکن خودکار کامل فعال است.
  fullTflite,

  /// فقط detector موجود؛ خواندن نیست.
  detectorOnly,

  /// هیچ مدلی موجود نیست.
  none,
}

class PlateModelStatus {
  const PlateModelStatus({
    required this.availability,
    required this.mode,
    required this.detectorPresent,
    required this.recognizerPresent,
    required this.digitClassifierPresent,
    required this.letterClassifierPresent,
    this.message,
  });

  const PlateModelStatus.none()
      : availability = PlateModelAvailability.none,
        mode = PlateModelMode.none,
        detectorPresent = false,
        recognizerPresent = false,
        digitClassifierPresent = false,
        letterClassifierPresent = false,
        message = 'اسکن آفلاین هنوز نصب نشده';

  final PlateModelAvailability availability;
  final PlateModelMode mode;
  final bool detectorPresent;
  final bool recognizerPresent;
  final bool digitClassifierPresent;
  final bool letterClassifierPresent;
  final String? message;

  bool get canAutoScan =>
      availability == PlateModelAvailability.fullTflite;

  bool get canDetectOnly =>
      availability == PlateModelAvailability.detectorOnly;

  String get userTitle => switch (availability) {
        PlateModelAvailability.fullTflite => 'پلاک را داخل کادر قرار دهید',
        PlateModelAvailability.detectorOnly => 'پلاک را داخل کادر قرار دهید',
        PlateModelAvailability.none => 'اسکن آفلاین هنوز نصب نشده',
      };

  String get userSubtitle => switch (availability) {
        PlateModelAvailability.fullTflite => '',
        PlateModelAvailability.detectorOnly =>
          'پس از پیدا شدن پلاک، شماره را تأیید یا وارد کنید',
        PlateModelAvailability.none =>
          'فعلاً می‌توانید پلاک را دستی وارد کنید',
      };

  String get userMessage => switch (availability) {
        PlateModelAvailability.fullTflite => 'پلاک را داخل کادر قرار دهید',
        PlateModelAvailability.detectorOnly => 'پلاک را داخل کادر قرار دهید',
        PlateModelAvailability.none =>
          'اسکن آفلاین هنوز نصب نشده\nفعلاً می‌توانید پلاک را دستی وارد کنید',
      };

  static const detectedManualEntryMessage =
      'پلاک پیدا شد؛ شماره را تأیید یا وارد کنید';

  String get debugEngineLabel => switch (mode) {
        PlateModelMode.detectorRecognizer => 'TFLite detector+recognizer',
        PlateModelMode.detectorClassifiers => 'TFLite detector+classifiers',
        PlateModelMode.detectorOnly => 'TFLite detector-only',
        PlateModelMode.none => 'Manual fallback',
      };
}
