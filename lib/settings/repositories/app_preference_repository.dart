import 'package:shared_preferences/shared_preferences.dart';

class AppPreferenceRepository {
  const AppPreferenceRepository({
    required SharedPreferencesAsync sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferencesAsync _sharedPreferences;

  Future<bool?> get getNotificationPreference async =>
      await _sharedPreferences.getBool('notificationPreference');

  Future<bool?> get getDarkModePreference async =>
      await _sharedPreferences.getBool('darkModePreference');

  Future<void> setNotificationsPreference(bool newValue) async =>
      await _sharedPreferences.setBool('notificationsPreference', newValue);

  Future<void> setDarkModePreference(bool newValue) async =>
      await _sharedPreferences.setBool('darkModePreference', newValue);
}
