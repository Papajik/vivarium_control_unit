class SensorDataPh{
  double? currentPh;

  SensorDataPh({this.currentPh});

  factory SensorDataPh.fromJson(Map data) =>SensorDataPh(currentPh: data['ph'].toDouble());

  @override
  String toString() {
    return '{currentPh: $currentPh}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorDataPh &&
          runtimeType == other.runtimeType &&
          currentPh == other.currentPh;

  @override
  int get hashCode => currentPh.hashCode;
}