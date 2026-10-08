import 'package:shared_preferences/shared_preferences.dart';

/// Storage contract abstracting key-value persistence.
abstract class LocalStorage {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<List<String>?> getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);
  Future<bool> remove(String key);
  Future<bool> clear();
}

/// Implementation of [LocalStorage] backed by [SharedPreferences].
class SharedPreferencesStorage implements LocalStorage {
  final SharedPreferences _prefs;

  SharedPreferencesStorage(this._prefs);

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return _prefs.clear();
  }
}
