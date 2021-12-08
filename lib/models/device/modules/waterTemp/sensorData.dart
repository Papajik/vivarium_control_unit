class SensorDataWaterTemp{
  double? currentTemp;

  SensorDataWaterTemp({this.currentTemp});

  factory SensorDataWaterTemp.fromJson(Map data) =>SensorDataWaterTemp(currentTemp: data['temp']?.toDouble());

  @override
  String toString() {
    return '{temp: $currentTemp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataWaterTemp &&
          runtimeType == other.runtimeType &&
          currentTemp == other.currentTemp;

  @override
  int get hashCode => currentTemp.hashCode;
}