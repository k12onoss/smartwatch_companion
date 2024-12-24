import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/repositories/authentication_repository.dart';

abstract class SignUpState {}

class SignUpIdle extends SignUpState {}

class SignUpInProgress extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure(this.message);
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(SignUpIdle());

  final AuthenticationRepository _authenticationRepository;

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpInProgress());
    try {
      await _authenticationRepository.signUp(email: email, password: password);
      emit(SignUpSuccess());
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(SignUpFailure(e.message));
    } catch (_) {
      emit(SignUpFailure('An unknown error occurred.'));
    }
  }
}
