import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';

class BluetoothDeviceTile extends StatelessWidget {
  const BluetoothDeviceTile({Key? key, this.device, this.onTap})
      : super(key: key);

  final BluetoothDevice? device;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black26,
      child: ListTile(
        title: Text(device?.name ?? 'Unknown device',
            style: Theme.of(context).textTheme.headline4),
        subtitle: Text(device!.macAddress.toString(),
            style: Theme.of(context).textTheme.headline6),
        onTap: onTap,
        leading: device!.rssi != null
            ? Container(
                child: DefaultTextStyle(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _calculateColor(device!.rssi!)),
                child: Column(
                  children: <Widget>[
                    Text(device!.rssi.toString()),
                    Text(
                      'dBm',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ))
            : Container(
                child: Text('NaN', style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  Color? _calculateColor(int rssi) {
    if (rssi >= -35) return Colors.greenAccent[700];
    if (rssi >= -45) return Colors.lightGreen;
    if (rssi >= -55) return Colors.lime;
    if (rssi >= -65) return Colors.amber;
    if (rssi >= -75) return Colors.deepOrangeAccent;
    return Colors.redAccent;
  }
}
