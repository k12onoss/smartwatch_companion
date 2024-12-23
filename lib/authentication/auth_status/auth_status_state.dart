part of 'auth_status_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

final class AuthStatusState {
  const AuthStatusState({WatchUser user = WatchUser.empty})
      : this._(
          status: user == WatchUser.empty
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          user: user,
        );

  const AuthStatusState._({required this.status, this.user = WatchUser.empty});

  final AuthStatus status;
  final WatchUser user;
}
