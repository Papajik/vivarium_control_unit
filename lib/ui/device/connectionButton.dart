import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothEnabler.dart';
import 'package:vivarium_control_unit/utils/permissions/permissionService.dart';

class BluetoothConnectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothConnector>(
        builder: (context, connector, child) => StreamBuilder<BleStatus>(
            initialData: connector.bluetoothStatus,
            stream: connector.bluetoothStatusStream,
            builder: (context, snapshot) => snapshot.data == BleStatus.ready
                ? Consumer<DeviceConnectionState>(
                    builder: (context, connectionState, child) {
                      if (connectionState == DeviceConnectionState.connected) {
                        return IconButton(
                          icon: Icon(Icons.bluetooth_connected,
                              color: Colors.green),
                          onPressed: () => connector.disconnect(),
                        );
                      }

                      if (connectionState ==
                          DeviceConnectionState.disconnected) {
                        return IconButton(
                            icon: Icon(Icons.bluetooth,
                                color: Colors.yellowAccent.shade700),
                            onPressed: () => connector.connect(
                                    onConnectionCallback: () async {
                                  await connector.initStateStream();
                                  await connector.initSensorStreamData();
                                }));
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  )
                : IconButton(
                    onPressed: () async {
                      if (!await PermissionService
                          .isLocationPermissionGranted()) {
                        await PermissionService.requestLocationPermission();
                      }
                      await BluetoothEnabler.enableBluetooth().then((value) {});
                    },
                    icon: Icon(Icons.bluetooth_disabled,
                        color: Colors.grey, size: 30),
                  )));
  }
}
