import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StatePh {
  bool connected;

  StatePh({this.connected = false});

  factory StatePh.fromJson(Map data) =>
      StatePh(connected: data[connectedKey] as bool);

  Map<String, dynamic> toJson() =>
      {'$connectedKey': connected};

  @override
  String toString(){
    return '{connected: $connected}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatePh &&
          runtimeType == other.runtimeType &&
          connected == other.connected;

  @override
  int get hashCode => connected.hashCode;
}
