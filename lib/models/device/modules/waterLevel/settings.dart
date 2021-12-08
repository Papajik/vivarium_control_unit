import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsWaterLevel {
  double maxLevel;
  double minLevel;
  double sensorHeight;

  SettingsWaterLevel({required this.maxLevel, required this.sensorHeight, required this.minLevel});

  factory SettingsWaterLevel.fromJson(Map data) {
    return SettingsWaterLevel(
          sensorHeight: data[waterLevelSensorHeightKey].toDouble(),
          maxLevel: data[waterLevelMaxLevelKey].toDouble(),
          minLevel: data[waterLevelMinLevelKey].toDouble(),
        );
  }

  Map<String, dynamic> toJson() => {
        '$waterLevelSensorHeightKey': sensorHeight,
        '$waterLevelMaxLevelKey': maxLevel,
        '$waterLevelMinLevelKey': minLevel,
      };

  @override
  String toString() {
    return '{ $waterLevelSensorHeightKey: $sensorHeight,$waterLevelMaxLevelKey: $maxLevel ,$waterLevelMinLevelKey: $minLevel  }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsWaterLevel &&
          runtimeType == other.runtimeType &&
          maxLevel == other.maxLevel &&
          minLevel == other.minLevel &&
          sensorHeight == other.sensorHeight;

  @override
  int get hashCode =>
      maxLevel.hashCode ^ minLevel.hashCode ^ sensorHeight.hashCode;
}
