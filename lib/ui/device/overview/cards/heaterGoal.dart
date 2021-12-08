import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceSensorData.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/ui/device/overview/animatedChart.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class HeaterGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      title: 'Heater goal',
      additionalHeader: Consumer<DeviceSensorData>(
          builder: (context, sensorData, child) => Text(
              'Temp: ${sensorData.heater?.tempGoal ?? '--'} °C',
              style: Theme.of(context).textTheme.headline6)),
      body: Consumer<HeaterGoalHistory?>(
          builder: (context, history, child) => (history == null)
              ? CircularProgressIndicator()
              :  (history.hasData)
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
