import 'package:flutter/material.dart';

class DeviceSettingsSubpage extends StatefulWidget {
  final String deviceId;

  DeviceSettingsSubpage({Key key, this.deviceId}) : super(key: key);

  @override
  _DeviceSettingsSubpageState createState() => _DeviceSettingsSubpageState();
}

class _DeviceSettingsSubpageState extends State<DeviceSettingsSubpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("settings body"),
      )
    );
  }

}