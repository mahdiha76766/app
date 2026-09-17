/// برای قابلیت‌هایی که هنوز پیاده‌سازی نشده‌اند.
class NotImplementedException implements Exception {
  NotImplementedException(this.message);

  final String message;

  @override
  String toString() => 'NotImplementedException: $message';
}
