import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StateDht {
  bool connected;

  StateDht({this.connected = false});

  factory StateDht.fromJson(Map data) =>
      StateDht(connected: data[connectedKey] as bool);

  Map<String, dynamic> toJson() =>
      {'$connectedKey': connected};

  @override
  String toString(){
    return '{connected: $connected}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateDht &&
          runtimeType == other.runtimeType &&
          connected == other.connected;

  @override
  int get hashCode => connected.hashCode;
}