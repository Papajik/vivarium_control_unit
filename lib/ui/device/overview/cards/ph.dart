import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceSensorData.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/ui/device/overview/animatedChart.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class PhCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      title: 'pH',
      additionalHeader: Text(
          'Current value: ${Provider.of<DeviceSensorData?>(context)?.ph?.currentPh ?? '--'}',
          style: Theme.of(context).textTheme.headline6),
      key: UniqueKey(),
      body: Consumer<PhHistory>(
          builder: (context, history, child) =>  (history.hasData)
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
