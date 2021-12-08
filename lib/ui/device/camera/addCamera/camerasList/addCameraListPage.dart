import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/ui/device/camera/addCamera/camerasList/resultList.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothEnabler.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothScanner.dart';
import 'package:vivarium_control_unit/utils/location/locationService.dart';
import 'package:vivarium_control_unit/utils/permissions/permissionService.dart';

class AddCameraPage extends StatefulWidget {
  final String? deviceId;

  const AddCameraPage({Key? key, required this.deviceId}) : super(key: key);

  @override
  _AddCameraPageState createState() => _AddCameraPageState();
}

class _AddCameraPageState extends State<AddCameraPage> {
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
    return SkeletonPage(
      appBarTitle: 'Add new Camera',
      body: StreamProvider<PermissionStatus?>.value(
          value: PermissionService.locationGrantedStream,
          initialData: PermissionStatus.denied,
          child: Consumer<PermissionStatus>(
            builder: (context, status, child) =>
                status == PermissionStatus.denied
                    ? _allowPermissionBody()
                    : _deviceListBody(),
          )),
      floatingActionButton: StreamBuilder(
        stream: _bluetoothService.isScanning,
        initialData: false,
        builder: (context, isScanning) => isScanning.data != null
            ? Container(
                width: 0,
                height: 0,
              )
            : FloatingActionButton(
                onPressed: tryToScan,
                child: Icon(Icons.refresh),
              ),
      ),
    );
  }

  Widget _allowPermissionBody() {
    return Center(
      child: Container(
        height: 120,
        child: Card(
          color: Colors.black38,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location permission not granted',
                    style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: AppSettings.openAppSettings,
                  child: Text('Allow location permission'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _deviceListBody() {
    return StreamProvider<BluetoothDeviceEncapsulation>.value(
      value: _bluetoothService.devices,
      initialData: BluetoothDeviceEncapsulation(devices: []),
      child: ResultList(
        firebaseId: widget.deviceId,
      ),
    );
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }
}
