import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/models/watch_user.dart';
import 'package:smartwatch_companion/settings/repositories/local_user_details_repository.dart';

class UserAccountSettingsCubit extends Cubit<WatchUser> {
  UserAccountSettingsCubit(
      {required LocalUserDetailsRepository settingsRepository})
      : _settingsRepository = settingsRepository,
        super(WatchUser.empty);

  final LocalUserDetailsRepository _settingsRepository;

  void persistUserAccountDetails(WatchUser user) async {
    await _settingsRepository.persistUserAccountDetails(user);
    emit(user);
  }
}
