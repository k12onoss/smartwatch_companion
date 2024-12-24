part of 'auth_status_bloc.dart';

sealed class AuthStatusEvent {
  const AuthStatusEvent();
}

final class AuthStatusRequestedEvent extends AuthStatusEvent {
  const AuthStatusRequestedEvent();
}

final class LogoutEvent extends AuthStatusEvent {
  const LogoutEvent();
}
