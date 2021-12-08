import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsWaterTemp {
  double maxTemp;
  double minTemp;

  SettingsWaterTemp({required this.maxTemp, required this.minTemp});

  factory SettingsWaterTemp.fromJson(Map data) =>SettingsWaterTemp(
    maxTemp: data[waterTempMaxTemp].toDouble(),
    minTemp: data[waterTempMinTemp].toDouble(),
        );

  Map<String, dynamic> toJson() => {
        '$waterTempMaxTemp': maxTemp,
        '$waterTempMinTemp': minTemp,
      };

  @override
  String toString() {
    return '{ $waterTempMaxTemp: $maxTemp,$waterTempMinTemp: $minTemp  }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsWaterTemp &&
          runtimeType == other.runtimeType &&
          maxTemp == other.maxTemp &&
          minTemp == other.minTemp;

  @override
  int get hashCode => maxTemp.hashCode ^ minTemp.hashCode;
}
