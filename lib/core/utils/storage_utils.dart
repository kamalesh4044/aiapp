import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static late SharedPreferences _prefs;

  /// Initialize shared preferences
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save string
  static Future<bool> saveString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// Get string
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Save int
  static Future<bool> saveInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// Get int
  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Save bool
  static Future<bool> saveBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// Get bool
  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Save double
  static Future<bool> saveDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// Get double
  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Save list of strings
  static Future<bool> saveStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// Get list of strings
  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Remove key
  static Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Clear all
  static Future<bool> clear() async {
    return _prefs.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  static Set<String> getAllKeys() {
    return _prefs.getKeys();
  }
}
