import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SetupLocationPage extends StatefulWidget {
  final BluetoothDevice device;

  SetupLocationPage({Key key, this.device}) : super(key: key);

  @override
  _SetupLocationPage createState() => _SetupLocationPage();
}

class _SetupLocationPage extends State<SetupLocationPage> {
  TextEditingController nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Location"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Set new name"),
          ),
          TextField(

            controller: nameController,

          ),
          RaisedButton(
            child: Text("Create location"),
            onPressed: _createLocation(widget.device),
          )
        ],
      )
    );
  }

  _createLocation(BluetoothDevice device){

   // device.connect(timeout: Duration(seconds: 4), autoConnect: false);
   // print("connected");
   // device.disconnect();
  }
}
