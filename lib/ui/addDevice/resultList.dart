import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/ui/addDevice/bluetoothDeviceTile.dart';
import 'package:vivarium_control_unit/ui/router.dart';

class ResultList extends StatelessWidget {
  final AsyncCallback? onSelect;

  final String? deviceId;

  const ResultList(
      {Key? key,
      this.deviceId,
      this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothDeviceEncapsulation>(
        builder: (context, deviceEncapsulation, child) => ListView.builder(
              itemCount: deviceEncapsulation.devices.length,
              itemBuilder: (context, index) => BluetoothDeviceTile(
                  device: deviceEncapsulation.devices.elementAt(index),
                  onTap: () async {
                    if (onSelect != null) {
                      await onSelect!();
                    }

                    await Navigator.pushNamed(context, Routes.addDeviceDialog,
                        arguments: deviceId == null
                            ? deviceEncapsulation.devices.elementAt(index)
                            : deviceEncapsulation.devices
                                .elementAt(index)
                                .copyWith(firebaseId: deviceId));
                  }),
            ));
  }
}
