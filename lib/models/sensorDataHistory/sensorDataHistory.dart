import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:vivarium_control_unit/models/device/modules/dht/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/ph/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/waterLevel/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/waterTemp/sensorData.dart';

class SensorDataHistory {
  final SplayTreeMap<DateTime, SensorDataPh> phMap;
  final SplayTreeMap<DateTime, SensorDataWaterTemp> waterTempMap;
  final SplayTreeMap<DateTime, SensorDataHeater> heaterMap;
  final SplayTreeMap<DateTime, SensorDataDht> dhtMap;
  final SplayTreeMap<DateTime, SensorDataWaterLevel> waterLevelMap;

  HeaterGoalHistory get heaterGoalHistory => HeaterGoalHistory(
      history: SplayTreeMap.from(
          heaterMap.map((key, value) => MapEntry(key, value.tempGoal))));

  HeaterPowerHistory get heaterPowerHistory => HeaterPowerHistory(
      history: SplayTreeMap.from(
          heaterMap.map((key, value) => MapEntry(key, value.power))));

  WaterTempHistory get waterTempHistory {
    var m = waterTempMap.map((key, value) => MapEntry(key, value.currentTemp));
    m.removeWhere((key, value) => value == null);
    return WaterTempHistory(history: SplayTreeMap.from(m));
  }

  DhtTempHistory get dhtTempHistory {
    var m = dhtMap.map((key, value) => MapEntry(key, value.temperature));
    m.removeWhere((key, value) => value == -100);
    return DhtTempHistory(history: SplayTreeMap.from(m));
  }

  DhtHumHistory get dhtHumHistory {
    var m = dhtMap.map((key, value) => MapEntry(key, value.humidity));
    m.removeWhere((key, value) => value == -100);
    return DhtHumHistory(history: SplayTreeMap.from(m));
  }

  WaterLevelHistory get waterLevelHistory {
    return WaterLevelHistory(
        history: SplayTreeMap.from(
            waterLevelMap.map((key, value) => MapEntry(key, value.level))));
  }

  PhHistory get phHistory => PhHistory(
      history: SplayTreeMap.from(
          phMap.map((key, value) => MapEntry(key, value.currentPh))));

  SensorDataHistory(
      {SplayTreeMap<DateTime, SensorDataPh>? phMap,
      SplayTreeMap<DateTime, SensorDataWaterTemp>? waterTempMap,
      SplayTreeMap<DateTime, SensorDataHeater>? heaterMap,
      SplayTreeMap<DateTime, SensorDataDht>? dhtMap,
      SplayTreeMap<DateTime, SensorDataWaterLevel>? waterLevelMap})
      : phMap = phMap ?? SplayTreeMap(),
        waterTempMap = waterTempMap ?? SplayTreeMap(),
        heaterMap = heaterMap ?? SplayTreeMap(),
        dhtMap = dhtMap ?? SplayTreeMap(),
        waterLevelMap = waterLevelMap ?? SplayTreeMap();

  factory SensorDataHistory.fromJson(Map? data) {
    var phHistory = SplayTreeMap<DateTime, SensorDataPh>();
    var waterTempHistory = SplayTreeMap<DateTime, SensorDataWaterTemp>();
    var heaterHistory = SplayTreeMap<DateTime, SensorDataHeater>();
    var dhtHistory = SplayTreeMap<DateTime, SensorDataDht>();
    var wlHistory = SplayTreeMap<DateTime, SensorDataWaterLevel>();

    if (data != null) {
      Map<String, dynamic>.from(data).forEach((key, value) {
        var date = DateTime.fromMillisecondsSinceEpoch(int.parse(key) * 1000);

        if (value['ph'] != null) {
          phHistory.addAll({date: SensorDataPh.fromJson(value['ph'])});
        }

        if (value['waterTemp'] != null) {
          waterTempHistory
              .addAll({date: SensorDataWaterTemp.fromJson(value['waterTemp'])});
        }

        if (value['heater'] != null) {
          heaterHistory
              .addAll({date: SensorDataHeater.fromJson(value['heater'])});
        }

        if (value['dht'] != null) {
          dhtHistory.addAll({date: SensorDataDht.fromJson(value['dht'])});
        }

        if (value['wl'] != null) {
          wlHistory.addAll({date: SensorDataWaterLevel.fromJson(value['wl'])});
        }
      });
    }
    print(heaterHistory.entries.last);
    return SensorDataHistory(
        phMap: phHistory,
        heaterMap: heaterHistory,
        waterTempMap: waterTempHistory,
        dhtMap: dhtHistory,
        waterLevelMap: wlHistory);
  }
}


/// Encapsulation of history in SplayTreeMap to be passed in Provider
/// Provider can't pass two or more same objects with different data
class HistoryEncapsulation {
  final SplayTreeMap<DateTime, double> history;

  bool get hasData => history.length > 2;

  HistoryEncapsulation({required this.history});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEncapsulation &&
          runtimeType == other.runtimeType &&
          MapEquality().equals(history, other.history);

  @override
  int get hashCode => history.hashCode;
}

class DhtTempHistory extends HistoryEncapsulation {
  DhtTempHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}

class HeaterGoalHistory extends HistoryEncapsulation {
  HeaterGoalHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}

class HeaterPowerHistory extends HistoryEncapsulation {
  HeaterPowerHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}

class WaterTempHistory extends HistoryEncapsulation {
  WaterTempHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}

class DhtHumHistory extends HistoryEncapsulation {
  DhtHumHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}



class PhHistory extends HistoryEncapsulation {
  PhHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}

class WaterLevelHistory extends HistoryEncapsulation {
  WaterLevelHistory({required SplayTreeMap<DateTime, double> history})
      : super(history: history);
}
