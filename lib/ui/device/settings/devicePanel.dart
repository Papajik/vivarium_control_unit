import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/device/settings/device/bluetoothSettings.dart';
import 'package:vivarium_control_unit/ui/device/settings/device/deviceName.dart';
import 'package:vivarium_control_unit/ui/device/settings/device/trackAlive.dart';

class DevicePanel extends StatelessWidget {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [DeviceName(), BluetoothSettings(), TrackAlive()],
    );
  }
}
