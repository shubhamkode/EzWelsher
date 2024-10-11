import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHydratedStorage implements Storage {
  final SharedPreferences _preferences;

  AppHydratedStorage({required SharedPreferences preferences})
      : _preferences = preferences;

  @override
  dynamic read(String key) {
    return _preferences.get(key);
  }

  @override
  Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    }
    if (value is bool) {
      await _preferences.setBool(key, value);
    }
    if (value is int) {
      await _preferences.setInt(key, value);
    }
    if (value is double) {
      await _preferences.setDouble(key, value);
    }
    if (value is List<String>) {
      await _preferences.setStringList(key, value);
    }
  }

  @override
  Future<void> delete(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  @override
  Future<void> close() async {}
}
