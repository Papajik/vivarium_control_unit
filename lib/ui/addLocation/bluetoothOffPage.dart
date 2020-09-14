import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothOffPage extends StatelessWidget{
  const BluetoothOffPage({Key key, this.state}) : super(key: key);

  final BluetoothState state;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

}