import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vivarium_control_unit/ui/addLocation/addBluetoothDeviceDialog.dart';
import 'package:vivarium_control_unit/utils/bluetoothProvider.dart';

class BluetoothDeviceTile extends StatelessWidget {
  const BluetoothDeviceTile({Key key, this.device, this.onLongPress, this.rssi})
      : super(key: key);

  final BluetoothDevice device;
  final GestureLongPressCallback onLongPress;
  final int rssi;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name ?? 'Unknown device'),
      subtitle: Text(device.address.toString()),
      onTap: () => {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AddBluetoothDeviceDialog(
            provider: BluetoothProvider(name: device.name, id: device.address),
          ),
        )
      },
      leading: rssi != null
          ? Container(
              child: DefaultTextStyle(
              style: () {
                if (rssi >= -35) {
                  return TextStyle(color: Colors.greenAccent[700]);
                } else if (rssi >= -45) {
                  return TextStyle(
                      color: Color.lerp(Colors.greenAccent[700],
                          Colors.lightGreen, -(rssi + 35) / 10));
                } else if (rssi >= -55) {
                  return TextStyle(
                      color: Color.lerp(Colors.lightGreen, Colors.lime[600],
                          -(rssi + 45) / 10));
                } else if (rssi >= -65) {
                  return TextStyle(
                      color: Color.lerp(
                          Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
                } else if (rssi >= -75) {
                  return TextStyle(
                      color: Color.lerp(Colors.amber, Colors.deepOrangeAccent,
                          -(rssi + 65) / 10));
                } else if (rssi >= -85) {
                  return TextStyle(
                      color: Color.lerp(Colors.deepOrangeAccent,
                          Colors.redAccent, -(rssi + 75) / 10));
                } else {
                  return TextStyle(color: Colors.redAccent);
                }
              }(),
              child: Column(
                children: <Widget>[Text(rssi.toString()), Text('dBm')],
              ),
            ))
          : Container(
              child: Text('NaN'),
            ),
    );
  }
}
