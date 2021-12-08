import 'package:vivarium_control_unit/models/device/modules/dht/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/keys.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';
import 'package:vivarium_control_unit/models/device/modules/ph/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/waterLevel/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/waterTemp/sensorData.dart';

/// Representation of sensor data from Firebase Database
/// Contains possible data of each module
/// Module data can be null in case device doesn't support given module.
class DeviceSensorData {
  final SensorDataPh? ph;
  final SensorDataHeater? heater;
  final SensorDataWaterTemp? waterTemp;
  final SensorDataDht? dht;
  final SensorDataWaterLevel? waterLevel;

  DeviceSensorData copyWith(
          {SensorDataHeater? heater,
          SensorDataWaterTemp? waterTemp,
          SensorDataPh? ph,
          SensorDataDht? dht,
          SensorDataWaterLevel? waterLevel}) =>
      DeviceSensorData(
          ph: ph ?? this.ph,
          heater: heater ?? this.heater,
          waterTemp: waterTemp ?? this.waterTemp,
          dht: dht ?? this.dht,
          waterLevel: waterLevel ?? this.waterLevel);

  DeviceSensorData(
      {this.heater, this.waterTemp, this.ph, this.dht, this.waterLevel});

  factory DeviceSensorData.fromJson(Map data) {
    return DeviceSensorData(
      ph: data[pHKey] == null ? null : SensorDataPh.fromJson(data[pHKey]),
      dht: data[dhtKey] == null ? null : SensorDataDht.fromJson(data[dhtKey]),
      heater: data[heaterKey] == null
          ? null
          : SensorDataHeater.fromJson(data[heaterKey]),
      waterTemp: data[waterTempKey] == null
          ? null
          : SensorDataWaterTemp.fromJson(data[waterTempKey]),
      waterLevel: data[waterLevelKey] == null
          ? null
          : SensorDataWaterLevel.fromJson(data[waterLevelKey]),
    );
  }

  /// Create Full DeviceSensorData object
  factory DeviceSensorData.empty() => DeviceSensorData(
      ph: SensorDataPh(),
      waterLevel: SensorDataWaterLevel(),
      dht: SensorDataDht(),
      heater: SensorDataHeater(),
      waterTemp: SensorDataWaterTemp());

  /// Create deviceSensorData object from the list of modules
  factory DeviceSensorData.emptyFromModules(List<VivariumModule> modules) =>
      DeviceSensorData(
        waterLevel:
            modules.contains(VivariumModule.WL) ? SensorDataWaterLevel() : null,
        dht: modules.contains(VivariumModule.DHT) ? SensorDataDht() : null,
        heater:
            modules.contains(VivariumModule.HEATER) ? SensorDataHeater() : null,
        waterTemp:
            modules.contains(VivariumModule.WT) ? SensorDataWaterTemp() : null,
        ph: modules.contains(VivariumModule.PH) ? SensorDataPh() : null,
      );

  @override
  String toString() {
    return '{ ph: ${ph?.toString() ?? '{}'}, heater: ${heater?.toString() ?? '{}'}'
        ', waterTemp: ${waterTemp?.toString() ?? '{}'}, dht: ${dht?.toString() ?? '{}'}'
        ', waterLevel: ${waterLevel?.toString() ?? '{}'} }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceSensorData &&
          runtimeType == other.runtimeType &&
          ph == other.ph &&
          heater == other.heater &&
          waterTemp == other.waterTemp &&
          dht == other.dht &&
          waterLevel == other.waterLevel;

  @override
  int get hashCode =>
      ph.hashCode ^
      heater.hashCode ^
      waterTemp.hashCode ^
      dht.hashCode ^
      waterLevel.hashCode;
}
