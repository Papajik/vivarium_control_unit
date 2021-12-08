import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsDht {
  double maxHum;
  double minHum;
  double maxTemp;
  double minTemp;

  SettingsDht({required this.maxHum, required this.minHum, required this.maxTemp, required this.minTemp});

  factory SettingsDht.fromJson(Map data) => SettingsDht(
        maxHum: data[dhtMaxHumKey].toDouble(),
        minHum: data[dhtMinHumKey].toDouble(),
        maxTemp: data[dhtMaxTempKey].toDouble(),
        minTemp: data[dhtMinTempKey].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        '$dhtMaxHumKey': maxHum,
        '$dhtMinHumKey': minHum,
        '$dhtMaxTempKey': maxTemp,
        '$dhtMinTempKey': minTemp,
      };

  @override
  String toString() {
    return '{ $dhtMaxHumKey: $maxHum, $dhtMinHumKey: $minHum, $dhtMaxTempKey: $maxTemp, $dhtMinTempKey: $minTemp }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsDht &&
          runtimeType == other.runtimeType &&
          maxHum == other.maxHum &&
          minHum == other.minHum &&
          maxTemp == other.maxTemp &&
          minTemp == other.minTemp;

  @override
  int get hashCode =>
      maxHum.hashCode ^ minHum.hashCode ^ maxTemp.hashCode ^ minTemp.hashCode;
}
