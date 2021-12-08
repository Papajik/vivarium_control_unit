import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StateHum {
  bool connected;
  bool running;

  StateHum({this.connected = false, this.running = false});

  factory StateHum.fromJson(Map data) => StateHum(
      connected: data[connectedKey] as bool,
      running: data[humRunningKey] as bool);

  Map<String, dynamic> toJson() =>
      {'$connectedKey': connected, '$humRunningKey': running};

  @override
  String toString() {
    return '{connected: $connected, running: $running}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateHum &&
          runtimeType == other.runtimeType &&
          connected == other.connected &&
          running == other.running;

  @override
  int get hashCode => connected.hashCode ^ running.hashCode;
}
