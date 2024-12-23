import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/authentication/auth_status/auth_status_bloc.dart';
import 'package:smartwatch_companion/authentication/login/login_page.dart';
import 'package:smartwatch_companion/authentication/signup/signup_page.dart';

final GoRouter routerConfig = GoRouter(
  redirect: (context, routerState) {
    final isUnauthenticated = context.read<AuthStatusBloc>().state.status ==
        AuthStatus.unauthenticated;
    final isNavigatingToProtectedPage =
        routerState.fullPath != LogInPage.path &&
            routerState.fullPath != SignUpPage.path;
    if (isUnauthenticated && isNavigatingToProtectedPage) {
      return LogInPage.path;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: "/",
      name: "home",
      builder: (context, state) => Center(child: Text("Logged in")),
    ),
    LogInPage.route,
    SignUpPage.route,
  ],
);
