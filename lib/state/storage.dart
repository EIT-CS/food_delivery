import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Аппын төлвийг төхөөрөмж дээр JSON хэлбэрээр хадгална.
/// (Жинхэнэ апп-д энэ хэсгийг сервер/өгөгдлийн сангаар солино.)
class AppStorage {
  AppStorage._(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'food_delivery_state_v1';

  static Future<AppStorage> open() async =>
      AppStorage._(await SharedPreferences.getInstance());

  /// Хадгалсан төлөв. Байхгүй эсвэл эвдэрсэн бол null.
  Map<String, dynamic>? read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      final data = jsonDecode(raw);
      return data is Map<String, dynamic> ? data : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> write(Map<String, dynamic> data) =>
      _prefs.setString(_key, jsonEncode(data));

  Future<void> clear() => _prefs.remove(_key);
}
