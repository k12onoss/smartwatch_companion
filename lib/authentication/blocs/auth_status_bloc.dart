import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/models/watch_user.dart';
import 'package:smartwatch_companion/authentication/repositories/authentication_repository.dart';

part 'auth_status_event.dart';
part 'auth_status_state.dart';

class AuthStatusBloc extends Bloc<AuthStatusEvent, AuthStatusState> {
  AuthStatusBloc(this._authenticationRepository) : super(AuthStatusState()) {
    on<AuthStatusRequestedEvent>(_onAuthStatusRequestedEvent);
    on<LogoutEvent>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onAuthStatusRequestedEvent(
    AuthStatusRequestedEvent event,
    Emitter<AuthStatusState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) => emit(AuthStatusState(user: user)),
      onError: addError,
    );
  }

  void _onLogoutPressed(
    LogoutEvent event,
    Emitter<AuthStatusState> emit,
  ) {
    _authenticationRepository.logOut();
  }
}
