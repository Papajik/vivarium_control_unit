import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceTile extends StatelessWidget {
  const BluetoothDeviceTile({Key key, this.device, this.onTap, this.onLongPress, this.enabled, this.rssi}) : super(key: key);

  final BluetoothDevice  device;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool enabled;
  final int rssi;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name ?? "Unknown device"),
      subtitle: Text(device.address.toString()),
      onTap: onTap,
      onLongPress: onLongPress,
      trailing: Row(
        children: <Widget>[
          device.isConnected? Icon(Icons.import_export): Container(width: 0, height: 0),
          device.isBonded? Icon(Icons.link) : Container(width: 0, height: 0),
        ],
      ),
      leading: rssi !=null? Container(
        child: DefaultTextStyle(
          style:(){
            if (rssi >= -35) return TextStyle(color: Colors.greenAccent[700]);
            else if (rssi >= -45) return TextStyle(color: Color.lerp(Colors.greenAccent[700], Colors.lightGreen,        -(rssi + 35) / 10));
            else if (rssi >= -55) return TextStyle(color: Color.lerp(Colors.lightGreen,       Colors.lime[600],         -(rssi + 45) / 10));
            else if (rssi >= -65) return TextStyle(color: Color.lerp(Colors.lime[600],        Colors.amber,             -(rssi + 55) / 10));
            else if (rssi >= -75) return TextStyle(color: Color.lerp(Colors.amber,            Colors.deepOrangeAccent,  -(rssi + 65) / 10));
            else if (rssi >= -85) return TextStyle(color: Color.lerp(Colors.deepOrangeAccent, Colors.redAccent,         -(rssi + 75) / 10));
            else return TextStyle(color: Colors.redAccent);
          }(),
          child: Column(
            children: <Widget>[
              Text(rssi.toString()),
              Text("dBm")
            ],
          ),
        )
      ):Container(
        child: Text("NaN"),
      ),
    );
  }
}
