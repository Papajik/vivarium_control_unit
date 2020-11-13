import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vivarium_control_unit/ui/addLocation/bluetoothDeviceTile.dart';
class BluetoothDeviceList extends StatelessWidget {

  final List<BluetoothDiscoveryResult> bluetoothDiscoveryResults;
  final bool isDiscovering;

  const BluetoothDeviceList({Key key, this.bluetoothDiscoveryResults, this.isDiscovering}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('List = ${bluetoothDiscoveryResults.toString()}');
    return ListView.builder(
      itemCount: bluetoothDiscoveryResults.length + (isDiscovering?1:0),
      itemBuilder: (context, index) {
        if (isDiscovering && index == bluetoothDiscoveryResults.length){
          return Center(child: CircularProgressIndicator());
        }
        return BluetoothDeviceTile(
          rssi: bluetoothDiscoveryResults.elementAt(index).rssi,
          device: bluetoothDiscoveryResults.elementAt(index).device,
        );
    },);
  }
}
