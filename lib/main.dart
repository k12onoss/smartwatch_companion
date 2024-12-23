import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/authentication/auth_status/auth_status_bloc.dart';
import 'package:smartwatch_companion/authentication/authentication_repository.dart';
import 'package:smartwatch_companion/authentication/login/login_cubit.dart';
import 'package:smartwatch_companion/authentication/signup/signup_cubit.dart';
import 'package:smartwatch_companion/dashboard/health_data_cubit.dart';
import 'package:smartwatch_companion/dashboard/mock_bluetooth_sdk.dart';
import 'package:smartwatch_companion/router_config.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider<MockBluetoothSDK>(create: (_) => MockBluetoothSDK()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthStatusBloc(context.read<AuthenticationRepository>())
                  ..add(AuthStatusRequestedEvent()),
          ),
          BlocProvider(
            create: (context) =>
                LogInCubit(context.read<AuthenticationRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                SignUpCubit(context.read<AuthenticationRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                HealthDataCubit(context.read<MockBluetoothSDK>())
                  ..getHealthData(),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthStatusBloc, AuthStatusState>(
      listener: (context, state) => routerConfig.refresh(),
      child: MaterialApp.router(
        title: 'Smartwatch companion',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal[700]!),
        ),
        routerConfig: routerConfig,
      ),
    );
  }
}
