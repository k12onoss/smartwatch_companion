import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smartwatch_companion/authentication/blocs/auth_status_bloc.dart';
import 'package:smartwatch_companion/past_health_records/cubits/past_health_records_cubit.dart';
import 'package:smartwatch_companion/past_health_records/models/health_record.dart';

class PastHealthRecordsPage extends StatelessWidget {
  static String get path => "health_records";
  static String get name => "health_records";
  static GoRoute get route => GoRoute(
        path: path,
        name: name,
        builder: (context, _) {
          String userId = context.read<AuthStatusBloc>().state.user.uid;
          context.read<PastHealthRecordsCubit>().getRecordsForUser(userId);
          return PastHealthRecordsPage();
        },
      );

  const PastHealthRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Health Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<PastHealthRecordsCubit, HealthRecordsState>(
          builder: (context, state) {
            if (state is HealthRecordsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HealthRecordsLoaded) {
              final records = state.records;

              if (records.isEmpty) {
                return const Center(
                  child: Text(
                    'No health records yet.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return _HealthRecordCard(record: record);
                },
              );
            } else if (state is HealthRecordsError) {
              return Center(child: Text('Error occurred!\n${state.message}'));
            } else {
              return const Center(
                child: Text('Failed to load records. Please try again.'),
              );
            }
          },
        ),
      ),
    );
  }
}

class _HealthRecordCard extends StatelessWidget {
  const _HealthRecordCard({required HealthRecord record}) : _record = record;

  final HealthRecord _record;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${_record.timestamp}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Step Count: ${_record.healthData.stepCount}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'Heart Rate: ${_record.healthData.heartRate} bpm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'Blood Oxygen: ${_record.healthData.bloodOxygenLevel.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'Body Temperature: ${_record.healthData.bodyTemperature.toStringAsFixed(2)}°C',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
