import 'dart:math';

class MockBluetoothSDK {
  // Simulated heart rate.
  Stream<int> getHeartRateStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      yield (60 + (10 * (1 - Random().nextDouble())).toInt());
    }
  }

  // Simulated step increment.
  Stream<int> getStepCountStream() async* {
    int steps = 0;
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      steps += Random().nextInt(10);
      yield steps;
    }
  }

  // Simulated Blood Oxygen Level Stream (SpO2) (95% - 100%)
  Stream<double> getBloodOxygenLevelStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 4));
      yield (95 + Random().nextDouble() * 5);
    }
  }

  // Simulated Body Temperature (36.5°C - 37.5°C)
  Stream<double> getBodyTemperatureStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 5));
      yield (36.5 + Random().nextDouble() * 1.0);
    }
  }
}
