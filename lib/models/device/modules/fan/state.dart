import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StateFan {
  bool connected;
  double speed;

  StateFan({this.connected = false, this.speed = 0});

  factory StateFan.fromJson(Map data) => StateFan(
      connected: data[connectedKey] as bool,
      speed: data[fanSpeedKey]?.toDouble());

  Map<String, dynamic> toJson() => {'$connectedKey': connected};

  @override
  String toString() {
    return '{$connectedKey: $connected, $fanSpeedKey: $speed}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateFan &&
          runtimeType == other.runtimeType &&
          connected == other.connected &&
          speed == other.speed;

  @override
  int get hashCode => connected.hashCode ^ speed.hashCode;
}
