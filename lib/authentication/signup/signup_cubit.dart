import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/authentication_repository.dart';

enum SignUpState {
  inProgress,
  success,
  failure,
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(SignUpState.inProgress);

  final AuthenticationRepository _authenticationRepository;

  void signUp(
      {required String name,
      required String email,
      required String password}) async {
    emit(SignUpState.inProgress);
    try {
      await _authenticationRepository.signUp(email: email, password: password);
      emit(SignUpState.success);
    } catch (_) {
      emit(SignUpState.failure);
    }
  }
}
