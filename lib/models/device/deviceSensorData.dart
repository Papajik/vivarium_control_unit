import 'package:cloud_firestore/cloud_firestore.dart';

class SensorData {
  double waterTemperature1;
  double waterTemperature2;
  DateTime updateTime;
  double waterLevel;
  double waterPh;

  SensorData(
      {this.waterTemperature1,
      this.waterTemperature2,
      this.updateTime,
      this.waterLevel,
      this.waterPh});

  SensorData.fromJSON(Map<String, dynamic> data)
      : this(
            waterTemperature1: data['waterTemperature1'].toDouble(),
            waterTemperature2: data['waterTemperature2'].toDouble(),
            updateTime: data['updateTime'].toDate(),
            waterLevel: data['waterLevel'].toDouble(),
            waterPh: data['waterPh'].toDouble());

  Map<String, dynamic> toJson() => {
        'waterTemperature1': waterTemperature1,
        'waterTemperature2': waterTemperature2,
        'updateTime': Timestamp.fromDate(updateTime),
        'waterPh': waterPh,
        'waterLevel': waterLevel
      };
}
