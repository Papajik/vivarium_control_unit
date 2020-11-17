import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceHistory {
  List<DeviceHistoryEntry> entries;

  DeviceHistory({this.entries});

  factory DeviceHistory.fromJson(Map<String, dynamic> data) {
    List<DeviceHistoryEntry> entries = data['sensorValuesHistory']
        .map<DeviceHistoryEntry>((e) => DeviceHistoryEntry.fromJson(e))
        .toList();

    return DeviceHistory(entries: entries);
  }

  @override
  String toString() {
    return 'DeviceHistory{entries: $entries}';
  }

  double get lastWaterTemperature1 => entries.last.waterTemperature1;

  double get lastWaterTemperature2 => entries.last.waterTemperature2;

  double get lastWaterLevel => entries.last.waterLevel;

  double get lastWaterPh => entries.last.waterPh;

  Map<DateTime, double> get waterLevelHistory {
    var result = <DateTime, double>{};
    entries.forEach((element) {
      result.addAll({element.updateTime: element.waterLevel});
    });
    return result;
  }

  Map<DateTime, double> get waterTemperature1History {
    var result = <DateTime, double>{};
    entries.forEach((element) {
      result.addAll({element.updateTime: element.waterTemperature1});
    });
    return result;
  }

  Map<DateTime, double> get waterTemperature2History {
    var result = <DateTime, double>{};
    entries.forEach((element) {
      result.addAll({element.updateTime: element.waterTemperature2});
    });
    return result;
  }

  Map<DateTime, double> get waterPhHistory {
    var result = <DateTime, double>{};
    entries.forEach((element) {
      result.addAll({element.updateTime: element.waterPh});
    });
    return result;
  }
}

class DeviceHistoryEntry {
  DateTime updateTime;
  double waterLevel;
  double waterPh;
  double waterTemperature1;
  double waterTemperature2;

  DeviceHistoryEntry(
      {this.updateTime,
      this.waterLevel,
      this.waterPh,
      this.waterTemperature1,
      this.waterTemperature2});

  factory DeviceHistoryEntry.fromJson(Map<String, dynamic> data) {
    DateTime updateTime;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      updateTime = (data['updateTime'] as Timestamp).toDate();
    } else {
      updateTime = DateTime.fromMillisecondsSinceEpoch(data['updateTime']['seconds'] * 1000);
    }

    return DeviceHistoryEntry(
        updateTime: updateTime,
        waterLevel: data['waterLevel'].toDouble(),
        waterPh: data['waterPh'].toDouble(),
        waterTemperature1: data['waterTemperature1'].toDouble(),
        waterTemperature2: data['waterTemperature2'].toDouble());
  }

  @override
  String toString() {
    return 'DeviceHistoryEntry{updateTime: $updateTime, waterLevel: $waterLevel, waterPh: $waterPh, waterTemperature1: $waterTemperature1, waterTemperature2: $waterTemperature2}';
  }
}
