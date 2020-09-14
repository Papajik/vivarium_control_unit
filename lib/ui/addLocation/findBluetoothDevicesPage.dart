import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/addLocation/bluetoothDeviceTile.dart';
import 'package:vivarium_control_unit/ui/addLocation/setupLocationPage.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class FindBluetoothDevicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find New Location"),
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: FlutterBluetoothSerial.instance.startDiscovery(),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                   //   .where((c) => c.device.name == "Photon-UCN")
                      .map(
                        (r) => BluetoothDeviceTile(
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return SetupLocationPage(device: r.device);
                          })),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ), onRefresh: () {return null;},
      ),
      floatingActionButton: StreamBuilder<bool>(
          stream: Stream.fromFuture(FlutterBluetoothSerial.instance.isDiscovering),
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => FlutterBluetoothSerial.instance.cancelDiscovery(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBluetoothSerial.instance
                    .startDiscovery(),
              );
            }
          }),
    );
  }
}
