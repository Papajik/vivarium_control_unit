import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StateLed {
  bool connected;
  int color;

  StateLed({this.connected = false, this.color = 0});

  factory StateLed.fromJson(Map data) => StateLed(
      connected: data[connectedKey] as bool, color: data[ledColorKey] as int);

  Map<String, dynamic> toJson() =>
      {'$connectedKey': connected, '$ledColorKey': color};

  @override
  String toString() {
    return '{connected: $connected, color: $color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateLed &&
          runtimeType == other.runtimeType &&
          connected == other.connected &&
          color == other.color;

  @override
  int get hashCode => connected.hashCode ^ color.hashCode;
}
