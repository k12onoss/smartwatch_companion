import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/past_health_records/models/health_record.dart';
import 'package:smartwatch_companion/past_health_records/repositories/health_records_repository.dart';
import 'package:smartwatch_companion/realtime_health_data/models/health_data.dart';
import 'package:smartwatch_companion/realtime_health_data/repositories/mock_bluetooth_sdk.dart';

part 'health_records_state.dart';

class PastHealthRecordsCubit extends Cubit<HealthRecordsState> {
  PastHealthRecordsCubit({
    required MockBluetoothSDK sdk,
    required HealthRecordsRepository healthRecordsRepository,
  })  : _mockSdk = sdk,
        _healthRecordsRepository = healthRecordsRepository,
        super(HealthRecordsInitial()) {
    _combinedStream = Stream.periodic(Duration(seconds: 10)).asyncMap(
      (_) async {
        final heartRate = await _mockSdk.getHeartRateStream().first;
        final stepCount = await _mockSdk.getStepCountStream().first;
        final bloodOxygenLevel =
            await _mockSdk.getBloodOxygenLevelStream().first;
        final bodyTemperature = await _mockSdk.getBodyTemperatureStream().first;

        return HealthData(
          heartRate: heartRate,
          stepCount: stepCount,
          bloodOxygenLevel: bloodOxygenLevel,
          bodyTemperature: bodyTemperature,
        );
      },
    );
  }

  final MockBluetoothSDK _mockSdk;
  final HealthRecordsRepository _healthRecordsRepository;

  late final Stream<HealthData> _combinedStream;

  void startPersistingRecords(String userId) {
    _combinedStream.listen((healthData) {
      final healthRecord = HealthRecord(
        userId: userId,
        timestamp: DateTime.now(),
        healthData: healthData,
      );
      _healthRecordsRepository.insertRecord(healthRecord);
    });
  }

  void getRecordsForUser(String userId) async {
    emit(HealthRecordsLoading());
    try {
      final records = await _healthRecordsRepository.getRecordsForUser(userId);
      emit(HealthRecordsLoaded(records));
    } catch (e) {
      emit(HealthRecordsError(e.toString()));
    }
  }
}
