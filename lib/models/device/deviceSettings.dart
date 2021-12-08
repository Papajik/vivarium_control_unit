import 'package:vivarium_control_unit/models/device/generalSettings.dart';
import 'package:vivarium_control_unit/models/device/modulePanelSettings.dart';
import 'package:vivarium_control_unit/models/device/modules/dht/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/fan/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/feeder/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/hum/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/keys.dart';
import 'package:vivarium_control_unit/models/device/modules/led/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';
import 'package:vivarium_control_unit/models/device/modules/ph/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/waterLevel/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/waterPump/settings.dart';

import 'modules/waterTemp/settings.dart';

class DeviceSettings {
  final SettingsPh? ph;
  final SettingsFeeder? feeder;
  final SettingsFan? fan;
  final SettingsLed? led;
  final SettingsDht? dht;
  final SettingsHeater? heater;
  final SettingsHumidifier? humidifier;
  final SettingsWaterLevel? waterLevel;
  final SettingsWaterPump? pump;
  final SettingsWaterTemp? waterTemp;
  final GeneralSettings general;
  final ModulePanelSettings? panel;

  DeviceSettings(
      {this.ph,
      this.feeder,
      this.fan,
      this.led,
      this.dht,
      this.heater,
      this.waterLevel,
      this.waterTemp,
      this.pump,
      this.humidifier,
      this.panel,
      required this.general});

  factory DeviceSettings.fromJson(Map data) {
    return DeviceSettings(
        general: GeneralSettings.fromJson(data[generalKey]),
        ph: data[pHKey] == null ? null : SettingsPh.fromJson(data[pHKey]),
        fan: data[fanKey] == null ? null : SettingsFan.fromJson(data[fanKey]),
        dht: data[dhtKey] == null ? null : SettingsDht.fromJson(data[dhtKey]),
        heater: data[heaterKey] == null
            ? null
            : SettingsHeater.fromJson(data[heaterKey]),
        waterLevel: data[waterLevelKey] == null
            ? null
            : SettingsWaterLevel.fromJson(data[waterLevelKey]),
        feeder: data[feederKey] == null
            ? null
            : SettingsFeeder.fromJson(data[feederKey]),
        waterTemp: data[waterTempKey] == null
            ? null
            : SettingsWaterTemp.fromJson(data[waterTempKey]),
        led: data[ledKey] == null ? null : SettingsLed.fromJson(data[ledKey]),
        pump: data[pumpKey] == null
            ? null
            : SettingsWaterPump.fromJson(data[pumpKey]),
        humidifier: data[humidifierKey] == null
            ? null
            : SettingsHumidifier.fromJson(data[humidifierKey]),
        panel: data[panelKey] == null
            ? null
            : ModulePanelSettings.fromJson(data[panelKey]));
  }

  Map<String, dynamic> toJson() => {
        if (ph != null) '$generalKey': general.toJson(),
        if (ph != null) '$pHKey': ph!.toJson(),
        if (feeder != null) '$feederKey': feeder!.toJson(),
        if (fan != null) '$fanKey': fan!.toJson(),
        if (led != null) '$ledKey': led!.toJson(),
        if (dht != null) '$dhtKey': dht!.toJson(),
        if (heater != null) '$heaterKey': heater!.toJson(),
        if (waterLevel != null) '$waterLevelKey': waterLevel!.toJson(),
        if (waterTemp != null) '$waterTempKey': waterTemp!.toJson(),
        if (pump != null) '$pumpKey': pump!.toJson(),
        if (humidifier != null) '$humidifierKey': humidifier!.toJson(),
        if (panel != null) '$panelKey': panel!.toJson()
      };

  factory DeviceSettings.fromModules({required List<VivariumModule> modules}) =>
      DeviceSettings(
          general: GeneralSettings(trackAlive: true),
          ph: modules.contains(VivariumModule.PH)
              ? SettingsPh(
                  minPh: 3, maxPh: 4, continuous: false, continuousDelay: 15)
              : null,
          feeder: modules.contains(VivariumModule.FEEDER)
              ? SettingsFeeder(type: 0, triggers: {})
              : null,
          waterTemp: modules.contains(VivariumModule.WT)
              ? SettingsWaterTemp(maxTemp: 20, minTemp: 10)
              : null,
          heater: modules.contains(VivariumModule.HEATER)
              ? SettingsHeater(mode: 0, tuneMode: 0, directPower: 0)
              : null,
          fan: modules.contains(VivariumModule.FAN)
              ? SettingsFan(maxAt: 25, startAt: 20)
              : null,
          dht: modules.contains(VivariumModule.DHT)
              ? SettingsDht(maxTemp: 20, maxHum: 80, minHum: 60, minTemp: 15)
              : null,
          waterLevel: modules.contains(VivariumModule.WL)
              ? SettingsWaterLevel(maxLevel: 40, minLevel: 35, sensorHeight: 60)
              : null,
          humidifier: modules.contains(VivariumModule.HUMIDIFIER)
              ? SettingsHumidifier(goalHum: 70)
              : null,
          led: modules.contains(VivariumModule.LED)
              ? SettingsLed(triggers: {})
              : null,
          pump: modules.contains(VivariumModule.PUMP)
              ? SettingsWaterPump(goalLevel: 38)
              : null,
//          outlets: SettingsOutlet(outlet_1: false),
          panel: ModulePanelSettings(brightness: 255));

  @override
  String toString() {
    return '{ general: $general, ph: $ph, feeder: $feeder, fan: $fan, led: $led, dht: $dht, heater: $heater,'
        ' humidifier: $humidifier, waterLevel: $waterLevel, pump: $pump, waterTemp: $waterTemp, panel: $panel }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceSettings &&
          runtimeType == other.runtimeType &&
          ph == other.ph &&
          feeder == other.feeder &&
          fan == other.fan &&
          led == other.led &&
          dht == other.dht &&
          heater == other.heater &&
          humidifier == other.humidifier &&
          waterLevel == other.waterLevel &&
          pump == other.pump &&
          waterTemp == other.waterTemp &&
          panel == other.panel &&
          general == other.general;

  @override
  int get hashCode =>
      ph.hashCode ^
      feeder.hashCode ^
      fan.hashCode ^
      led.hashCode ^
      dht.hashCode ^
      heater.hashCode ^
      humidifier.hashCode ^
      waterLevel.hashCode ^
      pump.hashCode ^
      waterTemp.hashCode ^
      panel.hashCode ^
      general.hashCode;
}
