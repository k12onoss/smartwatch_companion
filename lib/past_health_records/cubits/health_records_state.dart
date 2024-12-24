part of 'past_health_records_cubit.dart';

abstract class HealthRecordsState {}

class HealthRecordsInitial extends HealthRecordsState {}

class HealthRecordsLoading extends HealthRecordsState {}

class HealthRecordsLoaded extends HealthRecordsState {
  final List<HealthRecord> records;
  HealthRecordsLoaded(this.records);
}

class HealthRecordsError extends HealthRecordsState {
  final String message;
  HealthRecordsError(this.message);
}
