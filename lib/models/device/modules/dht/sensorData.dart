class SensorDataDht{
  double? humidity;
  double? temperature;

  SensorDataDht({this.humidity, this.temperature});

  factory SensorDataDht.fromJson(Map data) {
    return SensorDataDht(humidity: data['hum'].toDouble(), temperature: data['temp'].toDouble());
  }

  @override
  String toString() {
    return '{humidity: $humidity, temperature: $temperature}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataDht &&
          runtimeType == other.runtimeType &&
          humidity == other.humidity &&
          temperature == other.temperature;

  @override
  int get hashCode => humidity.hashCode ^ temperature.hashCode;
}