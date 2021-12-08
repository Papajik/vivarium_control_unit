import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/ui/addDevice/resultList.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothEnabler.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothScanner.dart';
import 'package:vivarium_control_unit/utils/location/locationService.dart';
import 'package:vivarium_control_unit/utils/permissions/permissionService.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final BluetoothScanner _bluetoothService = BluetoothScanner();

  void _startScan() {
    _bluetoothService.startDeviceScan(timeout: Duration(seconds: 10));
  }

  Future<void> tryToScan() async {
    if (await PermissionService.checkAndEnablePermission() &&
        await (BluetoothEnabler.enableBluetooth() as FutureOr<bool>) &&
        await LocationService.checkAndEnableLocation()) {
      _startScan();
    }
  }

  @override
  void initState() {
    super.initState();
    tryToScan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
      value: _bluetoothService.isScanning,
      initialData: false,
      child: SkeletonPage(
        appBarTitle: 'Add new Device',
        body: StreamProvider<BluetoothDeviceEncapsulation>.value(
          value: _bluetoothService.devices,
          initialData: BluetoothDeviceEncapsulation(devices: []),
          child: ResultList(
            onSelect: () async => await _bluetoothService.stopDeviceScan(),
          ),
        ),
        floatingActionButton: Consumer<bool>(
          builder: (context, isScanning, child) => isScanning
              ? Container(
                  width: 0,
                  height: 0,
                )
              : FloatingActionButton(
                  onPressed: tryToScan,
                  child: Icon(Icons.refresh),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bluetoothService.dispose();

    super.dispose();
  }
}
