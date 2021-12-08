import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceSensorData.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/ui/device/overview/animatedChart.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class HeaterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      title: 'Heater',
      additionalHeader: Consumer<DeviceSensorData>(
          builder: (context, sensorData, child) => Text(
              'Power: ${sensorData.heater?.power ?? '--'} %',
              style: Theme.of(context).textTheme.headline6)),
      body: Consumer<HeaterPowerHistory>(
          builder: (context, history, child) => (history.hasData)
              ? AnimatedChart(
                  backgroundColor: Colors.white70,
                  lines: [history.history],
                  colors: [Colors.blue],
                  units: [''])
              : Center(
                  child: (Text('Not enough data for graph',
                      style: Theme.of(context).textTheme.headline4)))),
    );
  }
}
