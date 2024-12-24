import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwatch_companion/authentication/models/watch_user.dart';

class LocalUserDetailsRepository {
  const LocalUserDetailsRepository(
      {required SharedPreferencesAsync sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferencesAsync _sharedPreferences;

  Future<void> persistUserAccountDetails(WatchUser user) async {
    await Future.wait([
      _sharedPreferences.setString('user_id', user.uid),
      _sharedPreferences.setString('name', user.name ?? ''),
      _sharedPreferences.setString('email', user.email ?? ''),
      _sharedPreferences.setString('photo_url', user.photo ?? ''),
    ]);
  }

  Future<WatchUser> getUserAccountDetails() async {
    List<String?> userSettings = await Future.wait([
      _sharedPreferences.getString('user_id'),
      _sharedPreferences.getString('name'),
      _sharedPreferences.getString('email'),
      _sharedPreferences.getString('photo_url'),
    ]);

    if (userSettings[0] == null) {
      return WatchUser.empty;
    } else {
      return WatchUser(
        uid: userSettings[0] ?? '',
        name: userSettings[1],
        email: userSettings[2],
        photo: userSettings[3],
      );
    }
  }
}
