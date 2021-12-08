import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/ui/addDevice/bluetoothDeviceTile.dart';
import 'package:vivarium_control_unit/ui/router.dart';

class ResultList extends StatelessWidget {
  final String? firebaseId;

  const ResultList({Key? key, required this.firebaseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothDeviceEncapsulation>(
        builder: (context, deviceEncapsulation, child) => ListView.builder(
          itemCount: deviceEncapsulation.devices.length,
          itemBuilder: (context, index) => BluetoothDeviceTile(
              device: deviceEncapsulation.devices.elementAt(index),
              onTap: () => Navigator.pushNamed(context, Routes.addCameraDialog,
                  arguments: deviceEncapsulation.devices
                      .elementAt(index).copyWith(firebaseId: firebaseId))),
        ));
  }
}
