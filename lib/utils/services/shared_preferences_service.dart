import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  static const settings = 'settings';
}

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;
  static Map<String, dynamic> _settings;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  Future<void> loadSettings() async {
    final settings = _preferences.getString(SharedPreferencesKeys.settings);
    _settings = settings != null ? jsonDecode(settings) : null;
  }

  Future<void> setSettings(Map<String, dynamic> json) async {
    await _preferences.setString(
      SharedPreferencesKeys.settings,
      jsonEncode(json),
    );
  }

  Map<String, dynamic> get settings {
    return _settings;
  }
}
