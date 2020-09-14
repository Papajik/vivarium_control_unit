import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart'
    as FlutterB;
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/ui/device/deviceOverviewSubpage.dart';
import 'package:vivarium_control_unit/ui/device/deviceSettingsSubpage.dart';
import 'package:vivarium_control_unit/ui/device/deviceViewSubpage.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class DevicePage extends StatefulWidget {
  final Device device;

  DevicePage({Key key, this.device}) : super(key: key);

  @override
  _DevicePage createState() => _DevicePage();
}

class _DevicePage extends State<DevicePage> {
  BluetoothDevice _bluetoothDevice;
  var _subscription;
  FlutterB.BluetoothState _bluetoothState = FlutterB.BluetoothState.UNKNOWN;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    FlutterB.FlutterBluetoothSerial.instance.state
        .then((value) => {_bluetoothState = value, print(_bluetoothState)});
    FlutterB.FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((FlutterB.BluetoothState state) {
      setState(() {
        print("state changed");
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak and disconnect
    if (_bluetoothDevice != null) {
      _bluetoothDevice.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: AppBar(
            title: Text(widget.device.name),
            centerTitle: true,
            actions: <Widget>[_createConnectButtonFuture()],
            bottom: TabBar(
              tabs: [
                Tab(
                    text: Constants.of(context).deviceOverview,
                    icon: Icon(Icons.perm_device_information)),
                Tab(
                    text: Constants.of(context).deviceSettings,
                    icon: Icon(Icons.settings)),
                Tab(
                    text: Constants.of(context).deviceView,
                    icon: Icon(Icons.videocam))
              ],
            ),
          ),
          body: TabBarView(
            children: [
              DeviceOverviewSubpage(userId: userId, deviceId: widget.device.id),
              DeviceSettingsSubpage(
                  userId: userId,
                  deviceId: widget.device.id,
                  device: _bluetoothDevice),
              DeviceViewSubpage(userId: userId, device: widget.device),
            ],
          ),
        ));
  }

  Future<void> enableBluetooth() async {
    print("enable bluetooth");
    print(_bluetoothState);
    if (!(_bluetoothState == FlutterB.BluetoothState.STATE_ON ||
        _bluetoothState == FlutterB.BluetoothState.STATE_BLE_ON)) {
      print("request enable");
      await FlutterB.FlutterBluetoothSerial.instance.requestEnable();
      return true;
    }
    return false;
  }

  IconButton _createConnectButtonState() {
    if (!(_bluetoothState == FlutterB.BluetoothState.STATE_ON ||
        _bluetoothState == FlutterB.BluetoothState.STATE_BLE_ON)) {
      return IconButton(
        icon: Icon(Icons.bluetooth),
        onPressed: enableBluetooth,
      );
    }
    if (_bluetoothDevice == null) {
      return IconButton(
        icon: Icon(Icons.insert_link, color: Colors.white),
        onPressed: _scanning ? null : _connectFlutterBlue,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.link_off, color: Colors.orange),
        onPressed: _disconnect,
      );
    }
  }

  _connectFlutterBlue() async {
    print("connect");
    print(widget.device.macAddress);
    print(widget.device.name);

    DeviceIdentifier identifier = DeviceIdentifier(widget.device.macAddress);

    //TODO add toast - scanning

    await flutterBlue.startScan(timeout: Duration(seconds: 4)).then((value) => {
          //TODO add toast - connecting
          _subscription = flutterBlue.scanResults.listen((results) {
            for (ScanResult r in results) {
              print("looking at");
              print(r.device.id);
              if (r.device.id == identifier) {
                print("found device");
                r.device
                    .connect(autoConnect: false, timeout: Duration(seconds: 4))
                    .then((value) => {
                          //TODO add toast - connected
                          setState(() {
                            _bluetoothDevice = r.device;
                            _scanning = false;
                            _subscription.cancel();
                            _subscription = null;
                          })
                        });
              }
            }
          }),
          print("stop scan"),
          flutterBlue.stopScan(),
        });
  }

  _disconnect() async {
    print("disconnect");
    if (_bluetoothDevice != null) {
      _bluetoothDevice.disconnect();
    }

    setState(() {
      _bluetoothDevice = null;
      _scanning = false;
    });
  }

  FutureBuilder<FlutterB.BluetoothState> _createConnectButtonFuture() {
    return FutureBuilder<FlutterB.BluetoothState>(
        future: FlutterB.FlutterBluetoothSerial.instance.state,
        builder: (context, snapshot) {
          if (snapshot.data == FlutterB.BluetoothState.UNKNOWN) {
            return IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: null,
            );
          }
          if (!(snapshot.data == FlutterB.BluetoothState.STATE_ON ||
              snapshot.data == FlutterB.BluetoothState.STATE_BLE_ON)) {
            return IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: enableBluetooth,
            );
          }
          if (_bluetoothDevice == null) {
            return IconButton(
              icon: Icon(Icons.insert_link, color: Colors.white),
              onPressed: _scanning ? null : _connectFlutterBlue,
            );
          } else {
            return IconButton(
              icon: Icon(Icons.link_off, color: Colors.orange),
              onPressed: _disconnect,
            );
          }
        });
  }

  StreamBuilder<FlutterB.BluetoothState> _createConnectButtonStream() {
    return StreamBuilder<FlutterB.BluetoothState>(
        stream: FlutterB.FlutterBluetoothSerial.instance.onStateChanged(),
        builder: (context, snapshot) {
          if (!(snapshot.data == FlutterB.BluetoothState.STATE_ON ||
              snapshot.data == FlutterB.BluetoothState.STATE_BLE_ON)) {
            return IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: enableBluetooth,
            );
          }
          if (_bluetoothDevice == null) {
            return IconButton(
              icon: Icon(Icons.insert_link, color: Colors.white),
              onPressed: _scanning ? null : _connectFlutterBlue,
            );
          } else {
            return IconButton(
              icon: Icon(Icons.link_off, color: Colors.orange),
              onPressed: _disconnect,
            );
          }
        });
  }
}
