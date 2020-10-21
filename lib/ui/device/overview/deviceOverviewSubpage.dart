import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/device/overview/temperatureGraph.dart';

class DeviceOverviewSubpage extends StatefulWidget {
  final String deviceId;
  final String userId;

  DeviceOverviewSubpage({Key key, this.deviceId, this.userId})
      : super(key: key);

  @override
  _DeviceOverviewSubpageState createState() => _DeviceOverviewSubpageState();
}

class _DeviceOverviewSubpageState extends State<DeviceOverviewSubpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: 350,
            child: TemperatureGraph(
                deviceId: widget.deviceId, userId: widget.userId)));
  }
}
