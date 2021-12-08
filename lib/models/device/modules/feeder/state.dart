import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StateFeeder {
  bool connected;

  StateFeeder({this.connected = false});

  factory StateFeeder.fromJson(Map data) =>
      StateFeeder(connected: data[connectedKey] as bool);

  Map<String, dynamic> toJson() =>
      {'$connectedKey': connected};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateFeeder &&
          runtimeType == other.runtimeType &&
          connected == other.connected;

  @override
  int get hashCode => connected.hashCode;
}