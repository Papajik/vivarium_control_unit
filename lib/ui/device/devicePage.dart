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
      body: ListView(
        children: <Widget>[
          Container(
            height: 350,
            child: TemperatureGraph(deviceId: widget.device.id, userId: userId)
          ),
          Divider(
            color: Colors.blueGrey,
            height: 10,
            thickness: 5,
          ),
          Container(
            height: 200,
            child: DeviceSettingsSubpage(deviceId: widget.device.id, userId: userId)
          )
        ],
      )
    );
  }
}
