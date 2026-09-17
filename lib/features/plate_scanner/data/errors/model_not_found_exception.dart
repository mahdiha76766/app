/// خطای نبود یا خرابی مدل TFLite.
class ModelNotFoundException implements Exception {
  const ModelNotFoundException(this.message);

  final String message;

  @override
  String toString() => message;
}
