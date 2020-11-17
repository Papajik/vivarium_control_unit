import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device/triggers/feedTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/ledTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/outletTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/waterHeaterType.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class DeviceSettings {
  ///water level

  int waterSensorHeight;
  int maxWaterHeight;
  int minWaterHeight;

  ///Lists

  List<LedTrigger> ledTriggers;
  List<FeedTrigger> feedTriggers;
  List<OutletTrigger> powerOutletOneTriggers;
  List<OutletTrigger> powerOutletTwoTriggers;

  /// LED COLOR

  int ledColor;
  bool ledOn;

  ///Water temperature

  double waterOptimalTemperature;
  HeaterType waterHeaterType;

  ///PH
  double waterMaxPh;
  double waterMinPh;

  ///Outlets
  bool powerOutletOneOn;
  bool powerOutletTwoOn;

  DeviceSettings(
      {this.feedTriggers,
      this.ledTriggers,
      this.powerOutletOneTriggers,
      this.powerOutletTwoTriggers,
      this.waterHeaterType,
      this.ledColor,
      this.ledOn,
      this.maxWaterHeight,
      this.minWaterHeight,
      this.waterOptimalTemperature,
      this.waterSensorHeight,
      this.powerOutletOneOn,
      this.powerOutletTwoOn,
      this.waterMaxPh,
      this.waterMinPh});

  DeviceSettings.fromJson(Map<String, dynamic> data)
      : this(
          ledTriggers: (data['ledTriggers'] as List)
              .map((e) => LedTrigger.fromJson(e))
              .toList(),
          feedTriggers: (data['feedTriggers'] as List)
              .map((e) => FeedTrigger.fromJson(e))
              .toList(),
          powerOutletOneTriggers: (data['powerOutletOneTriggers'] as List)
              .map((e) => OutletTrigger.fromJson(e))
              .toList(),
          powerOutletTwoTriggers: (data['powerOutletTwoTriggers'] as List)
              .map((e) => OutletTrigger.fromJson(e))
              .toList(),
          maxWaterHeight: data['maxWaterHeight'] as int,
          minWaterHeight: data['minWaterHeight'] as int,
          waterSensorHeight: data['waterSensorHeight'] as int,
          waterHeaterType: HeaterType.values[(data['waterHeaterType'] as int)],
          ledColor: data['ledColor'] as int,
          ledOn: data['ledOn'] as bool,
          waterOptimalTemperature: data['waterOptimalTemperature'] as double,
          powerOutletOneOn: data['powerOutletOneOn'] as bool,
          powerOutletTwoOn: data['powerOutletTwoOn'] as bool,
          waterMaxPh: data['waterMaxPh'] as double,
          waterMinPh: data['waterMinPh'] as double,
        );

  Map<String, dynamic> toJson() => {
        'ledOn': ledOn,
        'ledColor': ledColor,
        'maxWaterHeight': maxWaterHeight,
        'minWaterHeight': minWaterHeight,
        'powerOutletOneIsOn': powerOutletOneOn,
        'powerOutletTwoIsOn': powerOutletTwoOn,
        'waterHeaterType': waterHeaterType.index,
        'waterMinPh': waterMinPh,
        'waterMaxPh': waterMaxPh,
        'waterOptimalTemperature': waterOptimalTemperature,
        'waterSensorHeight': waterSensorHeight,
        'feedTriggers': feedTriggers.map((e) => e.toJson()),
        'ledTriggers': ledTriggers.map((e) => e.toJson()),
        'powerOutletTwoTriggers': powerOutletTwoTriggers.map((e) => e.toJson()),
        'powerOutletOneTriggers': powerOutletOneTriggers.map((e) => e.toJson()),
      };

  FeedTrigger get nextFeedTrigger {
    var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
    feedTriggers.sort((a, b) => a.time.compareTo(b.time));
    return feedTriggers.isEmpty
        ? null
        : feedTriggers.firstWhere((element) => element.time > now,
        orElse: () => feedTriggers.first);
  }

  FeedTrigger get lastFeedTrigger {
    var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
    feedTriggers.sort((a, b) => a.time.compareTo(b.time));
    return feedTriggers.isEmpty
        ? null
        : feedTriggers.lastWhere((element) => element.time < now,
        orElse: () => feedTriggers.last);
  }

  OutletTrigger get nextOutletOneTrigger {
    var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
    powerOutletOneTriggers.sort((a, b) => a.time.compareTo(b.time));
    return powerOutletOneTriggers.isEmpty
        ? null
        : powerOutletOneTriggers.firstWhere((element) => element.time > now,
            orElse: () => powerOutletOneTriggers.first);
  }

  OutletTrigger get nextOutletTwoTrigger {
    var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
    powerOutletTwoTriggers.sort((a, b) => a.time.compareTo(b.time));
    return powerOutletOneTriggers.isEmpty
        ? null
        : powerOutletTwoTriggers.firstWhere((element) => element.time > now,
        orElse: () => powerOutletTwoTriggers.elementAt(0));
  }

  LedTrigger get nextLedTrigger {
    var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
    ledTriggers.sort((a, b) => a.time.compareTo(b.time));
    return ledTriggers.isEmpty
        ? null
        : ledTriggers.firstWhere((element) => element.time > now,
        orElse: () => ledTriggers.first);
  }

  LedTrigger get lastLedTrigger {
    var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
    ledTriggers.sort((a, b) => a.time.compareTo(b.time));
    return ledTriggers.isEmpty
        ? null
        : ledTriggers.lastWhere((element) => element.time < now,
        orElse: () => ledTriggers.last);
  }
}
