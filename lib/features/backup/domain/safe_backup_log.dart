/// لاگ امن بدون افشای اطلاعات حساس مشتری/حساب.
abstract final class SafeBackupLog {
  static const _sensitiveKeys = {
    'phone',
    'cardNumber',
    'accountNumber',
    'fullName',
    'accountHolderName',
    'trackingCode',
    'address',
    'mechanicName',
  };

  static void info(String message) {
    // ignore: avoid_print
    print('[NediCarBackup] $message');
  }

  static void error(String message, [Object? error]) {
    final safe = error == null ? message : '$message (${_sanitize(error)})';
    // ignore: avoid_print
    print('[NediCarBackup][error] $safe');
  }

  static String _sanitize(Object error) {
    var text = error.toString();
    for (final key in _sensitiveKeys) {
      text = text.replaceAllMapped(
        RegExp('$key["\']?\\s*[:=]\\s*["\']?[^,"\'}\\]]+', caseSensitive: false),
        (m) => '$key=***',
      );
    }
    // شماره موبایل تقریبی
    text = text.replaceAll(RegExp(r'09\d{9}'), '09*********');
    text = text.replaceAll(RegExp(r'\b\d{16}\b'), '****************');
    return text;
  }
}
