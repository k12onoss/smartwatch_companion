import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/repositories/authentication_repository.dart';

abstract class LogInState {}

class LogInIdle extends LogInState {}

class LogInInProgress extends LogInState {}

class LogInSuccess extends LogInState {}

class LogInFailure extends LogInState {
  final String message;

  LogInFailure(this.message);
}

class LogInCubit extends Cubit<LogInState> {
  LogInCubit(this._authenticationRepository) : super(LogInIdle());

  final AuthenticationRepository _authenticationRepository;

  void loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LogInInProgress());

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);

      emit(LogInSuccess());
    } on LogInWithEmailAndPasswordFailure catch (failure) {
      emit(LogInFailure(failure.message));
    } catch (_) {
      emit(LogInFailure("An unknown error occurred."));
    }
  }

  void loginWithGoogle() async {
    emit(LogInInProgress());

    try {
      await _authenticationRepository.logInWithGoogle();

      emit(LogInSuccess());
    } on LogInWithGoogleFailure catch (e) {
      emit(LogInFailure(e.message));
    } catch (_) {
      emit(LogInFailure("An unknown error occurred."));
    }
  }
}
