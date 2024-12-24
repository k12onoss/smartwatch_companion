import 'package:smartwatch_companion/past_health_records/repositories/health_records_repository.dart';
import 'package:smartwatch_companion/realtime_health_data/models/health_data.dart';

class HealthRecord {
  final int? id; // Nullable for new records not yet stored
  final String userId;
  final DateTime timestamp;
  final HealthData healthData;

  HealthRecord({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.healthData,
  });

  Map<String, dynamic> toMap() {
    return {
      HealthRecordsRepository.columnId: id,
      HealthRecordsRepository.columnUserId: userId,
      HealthRecordsRepository.columnTimestamp: timestamp.millisecondsSinceEpoch,
      HealthRecordsRepository.columnHeartRate: healthData.heartRate,
      HealthRecordsRepository.columnStepCount: healthData.stepCount,
      HealthRecordsRepository.columnBloodOxygenLevel:
          healthData.bloodOxygenLevel,
      HealthRecordsRepository.columnBodyTemperature: healthData.bodyTemperature,
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map[HealthRecordsRepository.columnId],
      userId: map[HealthRecordsRepository.columnUserId],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map[HealthRecordsRepository.columnTimestamp],
      ),
      healthData: HealthData(
        heartRate: map[HealthRecordsRepository.columnHeartRate],
        stepCount: map[HealthRecordsRepository.columnStepCount],
        bloodOxygenLevel: map[HealthRecordsRepository.columnBloodOxygenLevel],
        bodyTemperature: map[HealthRecordsRepository.columnBodyTemperature],
      ),
    );
  }
}
