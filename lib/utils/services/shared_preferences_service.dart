import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  static const darkModeEnabled = 'darkModeEnabled';
}

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

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

  Future<void> setDarkModeEnabled(bool value) async {
    await _preferences.setBool(SharedPreferencesKeys.darkModeEnabled, value);
  }

  bool get isDarkModeEnabled {
    return _preferences.getBool(SharedPreferencesKeys.darkModeEnabled);
  }
}
