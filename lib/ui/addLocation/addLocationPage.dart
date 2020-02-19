import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vivarium_control_unit/ui/addLocation/findBluetoothDevicesPage.dart';

class AddLocation extends StatefulWidget {
  final String uid;

  AddLocation({Key key, @required this.uid}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  bool _bleOn = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.fromFuture(FlutterBluetoothSerial.instance.state),
      initialData: BluetoothState.UNKNOWN,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.STATE_ON ||
            state == BluetoothState.STATE_BLE_ON ||
            _bleOn) {
          return FindBluetoothDevicesPage();
        }
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
                      .subhead
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
