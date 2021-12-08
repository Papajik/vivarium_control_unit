import 'package:vivarium_control_unit/models/device/modules/dht/state.dart';
import 'package:vivarium_control_unit/models/device/modules/fan/state.dart';
import 'package:vivarium_control_unit/models/device/modules/feeder/state.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/state.dart';
import 'package:vivarium_control_unit/models/device/modules/hum/state.dart';
import 'package:vivarium_control_unit/models/device/modules/keys.dart';
import 'package:vivarium_control_unit/models/device/modules/led/state.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';
import 'package:vivarium_control_unit/models/device/modules/outlets/state.dart';
import 'package:vivarium_control_unit/models/device/modules/ph/state.dart';
import 'package:vivarium_control_unit/models/device/modules/waterLevel/state.dart';
import 'package:vivarium_control_unit/models/device/modules/waterPump/state.dart';
import 'package:vivarium_control_unit/models/device/modules/waterTemp/state.dart';

/// Represents device and state of its modules
/// Each state of device is nullable
/// State is null if given module is not supported
class DeviceState {
  final StatePh? ph;
  final StateDht? dht;
  final StateHum? hum;
  final StateHeater? heater;
  final StateWaterTemp? waterTemp;
  final StateWaterLevel? waterLevel;
  final StateFeeder? feeder;
  final StateLed? led;
  final StatePump? pump;
  final StateFan? fan;
  final StateOutlet? outlet;

  DeviceState copyWith({
    StatePh? ph,
    StateDht? dht,
    StateHum? hum,
    StateHeater? heater,
    StateWaterTemp? waterTemp,
    StateWaterLevel? waterLevel,
    StateFeeder? feeder,
    StateLed? led,
    StatePump? pump,
    StateFan? fan,
    StateOutlet? outlet,
  }) =>
      DeviceState(
          ph: ph ?? this.ph,
          dht: dht ?? this.dht,
          hum: hum ?? this.hum,
          heater: heater ?? this.heater,
          waterTemp: waterTemp ?? this.waterTemp,
          waterLevel: waterLevel ?? this.waterLevel,
          feeder: feeder ?? this.feeder,
          led: led ?? this.led,
          pump: pump ?? this.pump,
          fan: fan ?? this.fan,
          outlet: outlet ?? this.outlet);

  DeviceState(
      {this.led,
      this.dht,
      this.waterLevel,
      this.hum,
      this.heater,
      this.waterTemp,
      this.ph,
      this.outlet,
      this.fan,
      this.feeder,
      this.pump});

  factory DeviceState.emptyFromModules(List<VivariumModule> modules) =>
      DeviceState(
          waterLevel:
              modules.contains(VivariumModule.WL) ? StateWaterLevel() : null,
          dht: modules.contains(VivariumModule.DHT) ? StateDht() : null,
          fan: modules.contains(VivariumModule.FAN) ? StateFan() : null,
          heater: modules.contains(VivariumModule.HEATER)
              ? StateHeater(goal: 15)
              : null,
          waterTemp:
              modules.contains(VivariumModule.WT) ? StateWaterTemp() : null,
          ph: modules.contains(VivariumModule.PH) ? StatePh() : null,
          pump: modules.contains(VivariumModule.PUMP) ? StatePump() : null,
          led: modules.contains(VivariumModule.LED) ? StateLed() : null,
          feeder:
              modules.contains(VivariumModule.FEEDER) ? StateFeeder() : null,
          hum: modules.contains(VivariumModule.HUMIDIFIER) ? StateHum() : null,
          outlet: [
            VivariumModule.O0,
            VivariumModule.O1,
            VivariumModule.O2,
            VivariumModule.O3
          ].any((element) => modules.contains(element))
              ? StateOutlet(outlets: [
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O0),
                      isOn: false),
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O0),
                      isOn: false),
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O0),
                      isOn: false),
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O0),
                      isOn: false),
                ])
              : null);

  factory DeviceState.fromJson(Map data) {
    var d = DeviceState(
        ph: (data[pHKey] != null) ? StatePh.fromJson(data[pHKey]) : null,
        dht: (data[dhtKey] != null) ? StateDht.fromJson(data[dhtKey]) : null,
        hum: (data[humidifierKey] != null)
            ? StateHum.fromJson(data[humidifierKey])
            : null,
        fan: (data[fanKey] != null) ? StateFan.fromJson(data[fanKey]) : null,
        heater: (data[heaterKey] != null)
            ? StateHeater.fromJson(data[heaterKey])
            : null,
        waterTemp: (data[waterTempKey] != null)
            ? StateWaterTemp.fromJson(data[waterTempKey])
            : null,
        feeder: (data[feederKey] != null)
            ? StateFeeder.fromJson(data[feederKey])
            : null,
        led: (data[ledKey] != null) ? StateLed.fromJson(data[ledKey]) : null,
        waterLevel: (data[waterLevelKey] != null)
            ? StateWaterLevel.fromJson(data[waterLevelKey])
            : null,
        pump:
            (data[pumpKey] != null) ? StatePump.fromJson(data[pumpKey]) : null,
        outlet: (data[outletKey] != null)
            ? StateOutlet.fromJson(data[outletKey])
            : null);
    return d;
  }

  Map<String, dynamic> toJson() => {
        if (led != null) ledKey: led!.toJson(),
        if (dht != null) dhtKey: dht!.toJson(),
        if (waterLevel != null) waterLevelKey: waterLevel!.toJson(),
        if (hum != null) humidifierKey: hum!.toJson(),
        if (heater != null) heaterKey: heater!.toJson(),
        if (waterTemp != null) waterTempKey: waterTemp!.toJson(),
        if (ph != null) pHKey: ph!.toJson(),
        if (fan != null) fanKey: fan!.toJson(),
        if (feeder != null) feederKey: feeder!.toJson(),
        if (pump != null) pumpKey: pump!.toJson(),
        if (outlet != null) outletKey: outlet!.toJson()
      };

  factory DeviceState.fromModules({required List<VivariumModule> modules}) =>
      DeviceState(
          ph: modules.contains(VivariumModule.PH) ? StatePh() : null,
          feeder:
              modules.contains(VivariumModule.FEEDER) ? StateFeeder() : null,
          waterTemp:
              modules.contains(VivariumModule.WT) ? StateWaterTemp() : null,
          heater:
              modules.contains(VivariumModule.HEATER) ? StateHeater() : null,
          fan: modules.contains(VivariumModule.FAN) ? StateFan() : null,
          dht: modules.contains(VivariumModule.DHT) ? StateDht() : null,
          waterLevel:
              modules.contains(VivariumModule.WL) ? StateWaterLevel() : null,
          hum: modules.contains(VivariumModule.HUMIDIFIER) ? StateHum() : null,
          led: modules.contains(VivariumModule.LED) ? StateLed() : null,
          pump: modules.contains(VivariumModule.PUMP) ? StatePump() : null,
          outlet: [
            VivariumModule.O0,
            VivariumModule.O1,
            VivariumModule.O2,
            VivariumModule.O3
          ].any((element) => modules.contains(element))
              ? StateOutlet(outlets: [
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O0),
                      isOn: false),
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O1),
                      isOn: false),
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O2),
                      isOn: false),
                  Outlet(
                      isAvailable: modules.contains(VivariumModule.O3),
                      isOn: false),
                ])
              : null);

  @override
  String toString() {
    return '{ $pHKey: ${ph?.toString() ?? '{}'}, $heaterKey: ${heater?.toString() ?? '{}'}'
        ', $waterTempKey: ${waterTemp?.toString() ?? '{}'}, $dhtKey: ${dht?.toString() ?? '{}'}'
        ', $fanKey: ${fan?.toString() ?? '{}'}, $waterLevelKey: ${waterLevel?.toString() ?? '{}'} }, '
        '$ledKey: ${led?.toString() ?? '{}'} },'
        ' $humidifierKey: ${hum?.toString() ?? '{}'} },'
        ' $feederKey: ${feeder?.toString() ?? '{}'} },'
        ' $pumpKey: ${pump?.toString() ?? '{}'} }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceState &&
          runtimeType == other.runtimeType &&
          ph == other.ph &&
          dht == other.dht &&
          hum == other.hum &&
          heater == other.heater &&
          waterTemp == other.waterTemp &&
          waterLevel == other.waterLevel &&
          feeder == other.feeder &&
          led == other.led &&
          pump == other.pump &&
          fan == other.fan &&
          outlet == other.outlet;

  @override
  int get hashCode =>
      ph.hashCode ^
      dht.hashCode ^
      hum.hashCode ^
      heater.hashCode ^
      waterTemp.hashCode ^
      waterLevel.hashCode ^
      feeder.hashCode ^
      led.hashCode ^
      pump.hashCode ^
      fan.hashCode ^
      outlet.hashCode;
}
