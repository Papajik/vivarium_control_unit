import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/ui/device/camera/addCamera/AddCameraForm.dart';
import 'package:vivarium_control_unit/ui/widgets/ConnectionHandler.dart';
import 'package:vivarium_control_unit/ui/widgets/card/fullscreenCard.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';

class AddCameraDialog extends StatelessWidget {
  final BluetoothDevice device;

  const AddCameraDialog({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
        appBarTitle: 'Add new Device',
        body: LayoutBuilder(
          builder: (context, constraints) {
            return FullscreenCard(
                color: Colors.blueGrey.shade700.withAlpha(220),
                child: Provider<BluetoothConnector>.value(
                    value: BluetoothConnector(deviceId:  device.macAddress),
                    child: ConnectionHandler(
                        child: AddCameraForm(
                            device: device,
                            headlineStyle:
                                Theme.of(context).textTheme.headline5))));
          },
        ));
  }
}
