import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final SharedPreferences preferences;

  SharedPrefHelper({required this.preferences});

  static const _LAST_CHECKED = "last_checked";
  static const _CHECK_INTERVAL = "check_interval";
  static const _DATA = "data";
  static const _THEME = "theme";

  Future<bool> storeCache(String key, String json,
      {int? lastChecked, int interval = 600000}) {
    lastChecked ??= DateTime.now().millisecondsSinceEpoch;
    return preferences.setString(
        key,
        jsonEncode({
          _LAST_CHECKED: lastChecked,
          _CHECK_INTERVAL: interval,
          _DATA: json
        }));
  }

  Future<String?> getCache(String key) async {
    var stored = preferences.getString(key);
    if (stored == null) return null;
    Map map = jsonDecode(stored);
    var lastChecked = map[_LAST_CHECKED];
    var interval = map[_CHECK_INTERVAL];
    if ((DateTime.now().millisecondsSinceEpoch - lastChecked) > interval) {
      preferences.remove(key);
      return null;
    }
    return map[_DATA];
  }

  Future<Map?> getFullCache(String key) async {
    var stored = preferences.getString(key);
    if (stored == null) return null;
    Map map = jsonDecode(stored);
    var lastChecked = map[_LAST_CHECKED];
    var interval = map[_CHECK_INTERVAL];
    if ((DateTime.now().millisecondsSinceEpoch - lastChecked) > interval) {
      preferences.remove(key);
      return null;
    }
    return map;
  }

  Future saveValueDarkTheme(bool value) async {
    preferences.setBool(_THEME, value);
  }

  Future<bool> getValueDarkTheme() async {
    return preferences.getBool(_THEME) ?? false;
  }
}
