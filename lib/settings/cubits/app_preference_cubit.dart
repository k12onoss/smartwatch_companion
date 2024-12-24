import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/settings/repositories/app_preference_repository.dart';

class AppPreferenceState {
  final bool notificationsEnabled;
  final bool darkModeEnabled;

  const AppPreferenceState({
    required this.notificationsEnabled,
    required this.darkModeEnabled,
  });

  AppPreferenceState copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
  }) {
    return AppPreferenceState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  static const AppPreferenceState defaultState = AppPreferenceState(
    notificationsEnabled: true,
    darkModeEnabled: false,
  );
}

class AppPreferenceCubit extends Cubit<AppPreferenceState> {
  AppPreferenceCubit({required AppPreferenceRepository appPreferenceRepository})
      : _appPreferenceRepository = appPreferenceRepository,
        super(AppPreferenceState.defaultState);

  final AppPreferenceRepository _appPreferenceRepository;

  void toggleNotifications(bool newValue) async {
    await _appPreferenceRepository.setNotificationsPreference(newValue);
    emit(state.copyWith(notificationsEnabled: newValue));
  }

  void toggleDarkMode(bool newValue) async {
    await _appPreferenceRepository.setDarkModePreference(newValue);
    emit(state.copyWith(darkModeEnabled: newValue));
  }
}
