import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartwatch_companion/dashboard/health_data.dart';
import 'package:smartwatch_companion/dashboard/mock_bluetooth_sdk.dart';

class HealthDataCubit extends Cubit<HealthData> {
  final MockBluetoothSDK sdk;
  StreamSubscription<int>? _heartRateSubscription;
  StreamSubscription<int>? _stepCountSubscription;
  StreamSubscription<double>? _bloodOxygenSubscription;
  StreamSubscription<double>? _bodyTemperatureSubscription;

  HealthDataCubit(this.sdk) : super(HealthData.empty);

  void getHealthData() {
    _heartRateSubscription = sdk
        .getHeartRateStream()
        .listen((heartRate) => emit(state.copyWith(heartRate: heartRate)));
    _stepCountSubscription = sdk
        .getStepCountStream()
        .listen((stepCount) => emit(state.copyWith(stepCount: stepCount)));
    _bloodOxygenSubscription = sdk.getBloodOxygenLevelStream().listen(
        (bloodOxygenLevel) =>
            emit(state.copyWith(bloodOxygenLevel: bloodOxygenLevel)));
    _bodyTemperatureSubscription = sdk.getBodyTemperatureStream().listen(
        (bodyTemperature) =>
            emit(state.copyWith(bodyTemperature: bodyTemperature)));
  }

  @override
  Future<void> close() {
    _heartRateSubscription?.cancel();
    _stepCountSubscription?.cancel();
    _bloodOxygenSubscription?.cancel();
    _bodyTemperatureSubscription?.cancel();
    return super.close();
  }
}
