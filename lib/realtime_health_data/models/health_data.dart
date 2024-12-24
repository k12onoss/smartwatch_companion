class HealthData {
  final int heartRate;
  final int stepCount;
  final double bloodOxygenLevel;
  final double bodyTemperature;

  const HealthData({
    required this.heartRate,
    required this.stepCount,
    required this.bloodOxygenLevel,
    required this.bodyTemperature,
  });

  static const empty = HealthData(
    heartRate: 0,
    stepCount: 0,
    bloodOxygenLevel: 0.0,
    bodyTemperature: 0.0,
  );

  HealthData copyWith({
    int? heartRate,
    int? stepCount,
    double? bloodOxygenLevel,
    double? bodyTemperature,
  }) {
    return HealthData(
      heartRate: heartRate ?? this.heartRate,
      stepCount: stepCount ?? this.stepCount,
      bloodOxygenLevel: bloodOxygenLevel ?? this.bloodOxygenLevel,
      bodyTemperature: bodyTemperature ?? this.bodyTemperature,
    );
  }
}
