import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/sensorData.dart';

class TemperatureGraph extends StatefulWidget {
  final String deviceId;
  final String userId;

  TemperatureGraph({Key key, this.deviceId, this.userId}) : super(key: key);

  @override
  _TemperatureGraphPage createState() => _TemperatureGraphPage();
}

class _TemperatureGraphPage extends State<TemperatureGraph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("users")
                .document(widget.userId)
                .collection("deviceHistories")
                .document(widget.deviceId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              List<SensorData> data = new List();
              var history = snapshot.data['sensorValuesHistory'];
              var it;
              for (it in history){
                data.add(SensorData.fromJSON(Map<String, dynamic>.from(it)));
              }

              return Container(
                child: Text("TODO"),
              );

            }));
  }
}
