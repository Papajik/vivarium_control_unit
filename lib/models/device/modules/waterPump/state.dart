import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StatePump {
  bool connected;
  bool running;

  StatePump({this.connected = false, this.running = false});

  factory StatePump.fromJson(Map data) => StatePump(
      connected: data[connectedKey] as bool,
      running: data[pumpRunningKey] as bool);

  Map<String, dynamic> toJson() =>
      {'$connectedKey': connected, '$pumpRunningKey': running};

  @override
  String toString() {
    return '{connected: $connected, running: $running}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatePump &&
          runtimeType == other.runtimeType &&
          connected == other.connected &&
          running == other.running;

  @override
  int get hashCode => connected.hashCode ^ running.hashCode;
}
