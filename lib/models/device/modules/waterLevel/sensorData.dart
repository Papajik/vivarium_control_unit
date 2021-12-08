class SensorDataWaterLevel{
  double? level;

  SensorDataWaterLevel({this.level});

  factory SensorDataWaterLevel.fromJson(Map data) {
    return SensorDataWaterLevel(level: data['level'].toDouble());
  }

  @override
  String toString() {
    return '{level: $level}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataWaterLevel &&
          runtimeType == other.runtimeType &&
          level == other.level;

  @override
  int get hashCode => level.hashCode;
}