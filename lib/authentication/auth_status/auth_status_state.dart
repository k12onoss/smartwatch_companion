part of 'auth_status_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthStatusState {
  const AuthStatusState({WatchUser? user})
      : this._(
          status: user == null
              ? AuthStatus.unknown
              : user == WatchUser.empty
                  ? AuthStatus.unauthenticated
                  : AuthStatus.authenticated,
          user: user ?? WatchUser.empty,
        );

  const AuthStatusState._({required this.status, this.user = WatchUser.empty});

  final AuthStatus status;
  final WatchUser user;
}
