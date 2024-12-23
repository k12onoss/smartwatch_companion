import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/authentication_repository.dart';

enum LogInState { inProgress, success, failure }

class LogInCubit extends Cubit<LogInState> {
  LogInCubit(this._authenticationRepository) : super(LogInState.inProgress);

  final AuthenticationRepository _authenticationRepository;

  void loginWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(LogInState.inProgress);

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);

      emit(LogInState.success);
    } catch (_) {
      emit(LogInState.failure);
    }
  }

  void loginWithGoogle() async {
    emit(LogInState.inProgress);

    try {
      await _authenticationRepository.logInWithGoogle();

      emit(LogInState.success);
    } catch (_) {
      emit(LogInState.failure);
    }
  }
}
