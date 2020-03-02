import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/ui/device/temperatureGraph.dart';
import 'package:vivarium_control_unit/ui/device/deviceSettingsSubpage.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  DevicePage({Key key, this.device}) : super(key: key);

  @override
  _DevicePage createState() => _DevicePage();
}

class _DevicePage extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name + " - overview"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TemperatureGraph(deviceId: widget.device.id, userId: userId)
          ),
          Expanded(
            child: DeviceSettingsSubpage(deviceId: widget.device.id)
          )
        ],
      )
    );
  }
}
