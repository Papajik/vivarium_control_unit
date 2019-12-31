import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vivarium_control_unit/ui/addLocation/bluetoothOffPage.dart';
import 'package:vivarium_control_unit/ui/test/findDeviceScreen.dart';

class AddLocation extends StatefulWidget {
  final String uid;

  AddLocation({Key key, @required this.uid}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();


}

class _AddLocationState extends State<AddLocation>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot){
        final state = snapshot.data;
        if (state == BluetoothState.on){
          return FindDevicesScreen ();
        }
        return BluetoothOffPage(state: state);
      },
    );
  }
}