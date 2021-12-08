import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsHumidifier {
  double goalHum;

  SettingsHumidifier({required this.goalHum});

  factory SettingsHumidifier.fromJson(Map data) =>
      SettingsHumidifier(goalHum: data[humidifierGoalKey].toDouble());

  Map<String, dynamic> toJson() => {
        '$humidifierGoalKey': goalHum,
      };

  @override
  String toString() {
    return '{ $humidifierGoalKey: $goalHum }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsHumidifier &&
          runtimeType == other.runtimeType &&
          goalHum == other.goalHum;

  @override
  int get hashCode => goalHum.hashCode;
}
