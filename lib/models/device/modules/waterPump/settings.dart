import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsWaterPump {
  double goalLevel;

  SettingsWaterPump({required this.goalLevel});

  factory SettingsWaterPump.fromJson(Map data) => SettingsWaterPump(
        goalLevel: data[pumpLevelGoal].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        '$pumpLevelGoal': goalLevel,
      };

  @override
  String toString() {
    return '{ $pumpLevelGoal: $goalLevel }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsWaterPump &&
          runtimeType == other.runtimeType &&
          goalLevel == other.goalLevel;

  @override
  int get hashCode => goalLevel.hashCode;
}
