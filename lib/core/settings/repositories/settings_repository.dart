import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  SettingsRepository({
    SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  Stream<Map<String, dynamic>> get settings {
    /*return _firebaseAuth.userChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.anonymous : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });*/
  }


}
