import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:smartwatch_companion/authentication/blocs/auth_status_bloc.dart';
import 'package:smartwatch_companion/authentication/cubits/login_cubit.dart';
import 'package:smartwatch_companion/authentication/cubits/signup_cubit.dart';
import 'package:smartwatch_companion/authentication/repositories/authentication_repository.dart';
import 'package:smartwatch_companion/config/router_config.dart';
import 'package:smartwatch_companion/past_health_records/cubits/past_health_records_cubit.dart';
import 'package:smartwatch_companion/past_health_records/repositories/health_records_repository.dart';
import 'package:smartwatch_companion/realtime_health_data/cubits/realtime_health_data_cubit.dart';
import 'package:smartwatch_companion/realtime_health_data/repositories/mock_bluetooth_sdk.dart';
import 'package:sqflite/sqflite.dart';

import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'health_records.db'),
    onCreate: (db, version) {
      return db.execute(HealthRecordsRepository.createTableQuery);
    },
    version: 1,
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(App(database: database));
}

class App extends StatelessWidget {
  const App({super.key, required Database database}) : _database = database;

  final Database _database;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider<MockBluetoothSDK>(create: (_) => MockBluetoothSDK()),
        RepositoryProvider<HealthRecordsRepository>(
          create: (_) => HealthRecordsRepository(_database),
        ),
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
                RealtimeHealthDataCubit(context.read<MockBluetoothSDK>()),
          ),
          BlocProvider(
            create: (context) => PastHealthRecordsCubit(
              sdk: context.read<MockBluetoothSDK>(),
              healthRecordsRepository: context.read<HealthRecordsRepository>(),
            ),
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
      listener: (context, state) {
        routerConfig.refresh();
        if (state.status == AuthStatus.authenticated) {
          context.read<RealtimeHealthDataCubit>().getHealthData();
          context
              .read<PastHealthRecordsCubit>()
              .startPersistingRecords(state.user.uid);
        }
      },
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
