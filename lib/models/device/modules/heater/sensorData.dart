class SensorDataHeater {
  double? power;
  double? tempGoal;

  SensorDataHeater({this.power, this.tempGoal});

  factory SensorDataHeater.fromJson(Map data) => SensorDataHeater(
      power: (data['power'] as num?)?.toDouble() ?? 0,
      tempGoal: (data['goal'] as num).toDouble());

  @override
  String toString() {
    return '{currentPower: $power, goal: $tempGoal}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataHeater &&
          runtimeType == other.runtimeType &&
          power == other.power &&
          tempGoal == other.tempGoal;

  @override
  int get hashCode => power.hashCode ^ tempGoal.hashCode;
}
