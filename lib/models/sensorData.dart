import 'package:cloud_firestore/cloud_firestore.dart';

class SensorData {
  final double temp1;
  final double temp2;
  final Timestamp updateTime;

  const SensorData({this.temp1, this.temp2, this.updateTime});

  SensorData.fromJSON(Map<String, dynamic> data)
      : this(
      temp1: data['temp_1'].toDouble(),
      temp2: data['temp_2'].toDouble(),
      updateTime: data['updateTime']);
}