import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/authentication/blocs/auth_status_bloc.dart';
import 'package:smartwatch_companion/authentication/models/watch_user.dart';
import 'package:smartwatch_companion/past_health_records/pages/past_health_records_page.dart';
import 'package:smartwatch_companion/realtime_health_data/cubits/realtime_health_data_cubit.dart';
import 'package:smartwatch_companion/realtime_health_data/models/health_data.dart';

class DashboardPage extends StatelessWidget {
  static String get path => "/dashboard";
  static String get name => "dashboard";
  static GoRoute get route => GoRoute(
        path: path,
        name: name,
        builder: (context, _) {
          AuthStatusState authState = context.read<AuthStatusBloc>().state;
          return DashboardPage(user: authState.user);
        },
      );

  const DashboardPage({super.key, required this.user});

  final WatchUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: user.photo != null && user.photo!.isNotEmpty
                    ? CircleAvatar(
                        // radius: 50,
                        backgroundImage: NetworkImage(user.photo!),
                      )
                    : const CircleAvatar(
                        // radius: 50,
                        backgroundColor: Colors.grey,
                      ),
                title: Text(
                  user.name ?? 'User',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  user.email ?? 'Email',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your Health Metrics:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<RealtimeHealthDataCubit, HealthData>(
                  builder: (context, state) {
                    if (state == HealthData.empty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        children: [
                          _MetricCard(
                            title: 'Step Count',
                            value: '${state.stepCount} steps',
                            icon: Icons.directions_walk,
                            iconColor: Colors.blue,
                          ),
                          _MetricCard(
                            title: 'Heart Rate',
                            value: '${state.heartRate} bpm',
                            icon: Icons.favorite,
                            iconColor: Colors.red,
                          ),
                          _MetricCard(
                            title: 'Blood Oxygen',
                            value:
                                '${state.bloodOxygenLevel.toStringAsFixed(2)}%',
                            icon: Icons.bloodtype,
                            iconColor: Colors.purple,
                          ),
                          _MetricCard(
                            title: 'Body Temperature',
                            value:
                                '${state.bodyTemperature.toStringAsFixed(2)}°C',
                            icon: Icons.thermostat,
                            iconColor: Colors.orange,
                          ),
                        ],
                      );
                    }
                    // else {
                    //   return const Center(
                    //     child:
                    //         Text('Failed to load metrics. Please try again.'),
                    //   );
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: GestureDetector(
        onTap: () => context.goNamed(PastHealthRecordsPage.name),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
