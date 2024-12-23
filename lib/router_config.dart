import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/authentication/auth_status/auth_status_bloc.dart';
import 'package:smartwatch_companion/authentication/login/login_page.dart';
import 'package:smartwatch_companion/authentication/signup/signup_page.dart';
import 'package:smartwatch_companion/dashboard/dashboard_page.dart';
import 'package:smartwatch_companion/loading_page.dart';

final GoRouter routerConfig = GoRouter(
  initialLocation: DashboardPage.path,
  routes: [
    LoadingPage.route,
    LogInPage.route,
    SignUpPage.route,
    DashboardPage.route,
  ],
  redirect: (context, routerState) {
    final authStatus = context.read<AuthStatusBloc>().state.status;

    if (authStatus == AuthStatus.unknown) return LoadingPage.path;

    final isNavigatingToProtectedPage =
        routerState.fullPath != LogInPage.path &&
            routerState.fullPath != SignUpPage.path &&
            routerState.fullPath != LoadingPage.path;

    if (authStatus == AuthStatus.unauthenticated &&
        isNavigatingToProtectedPage) {
      return LogInPage.path;
    }

    return null;
  },
);
