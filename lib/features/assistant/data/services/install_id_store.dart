import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// شناسه پایدار نصب برای سهمیه روزانه روی بک‌اند.
class InstallIdStore {
  static const _key = 'nedicar_install_id';

  Future<String> getOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_key);
    if (existing != null && existing.length >= 8) {
      return existing;
    }
    final id = const Uuid().v4();
    await prefs.setString(_key, id);
    return id;
  }
}
