import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/models/user_model.dart';

class LocalStorage {
  final SharedPreferences _prefs;

  // Keys
  static const String userKey = 'user_data';
  static const String offlineDataKey = 'offline_data';

  LocalStorage(this._prefs);

  // User data methods
  Future<bool> saveUser(UserModel user) async {
    return await _prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final userData = _prefs.getString(userKey);
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<bool> removeUser() async {
    return await _prefs.remove(userKey);
  }

  // Offline data methods
  Future<bool> saveOfflineData(String key, dynamic data) async {
    Map<String, dynamic> offlineData = getOfflineData() ?? {};
    offlineData[key] = data;
    return await _prefs.setString(offlineDataKey, jsonEncode(offlineData));
  }

  Map<String, dynamic>? getOfflineData() {
    final data = _prefs.getString(offlineDataKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> clearOfflineData() async {
    return await _prefs.remove(offlineDataKey);
  }

  // App state
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  bool isLoggedIn() {
    return _prefs.containsKey(userKey);
  }
}