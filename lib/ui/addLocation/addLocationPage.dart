import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vivarium_control_unit/ui/addLocation/bluetoothDeviceList.dart';

class AddLocationPage extends StatefulWidget {
  final bool isBluetoothOn;
  final bool isDiscovering;

  const AddLocationPage(
      {Key key, this.isBluetoothOn = false, this.isDiscovering = false})
      : super(key: key);

  @override
  _AddLocationPageState createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  StreamSubscription<BluetoothDiscoveryResult> _streamDiscoverySubscription;
  List<BluetoothDiscoveryResult> results = <BluetoothDiscoveryResult>[];

  BluetoothState _bluetoothState;

  BluetoothState get bluetoothState => _bluetoothState;
  StreamSubscription<BluetoothState> _streamStateSubscription;

  bool isDiscovering;
  bool isBluetoothOn;

  bool _isBluetoothOn(BluetoothState bluetoothState) {
    return (bluetoothState == BluetoothState.STATE_ON ||
        bluetoothState == BluetoothState.STATE_BLE_ON);
  }

  @override
  void initState() {
    super.initState();

    isBluetoothOn = widget.isBluetoothOn;
    isDiscovering = widget.isDiscovering;

    FlutterBluetoothSerial.instance.state.then((state) => {
          if (_isBluetoothOn(state))
            {
              setState(() => {
                    isBluetoothOn = true,
                    isDiscovering = true,
                  }),
              _startDiscovery()
            }
          else
            {
              setState(() => {isBluetoothOn = false, isDiscovering = false}),
              _stopDiscovery()
            }
        });

    _streamStateSubscription = FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((bluetoothState) {
      if (_isBluetoothOn(bluetoothState)) {
        setState(() {
          isDiscovering = true;
          isBluetoothOn = _isBluetoothOn(bluetoothState);
        });
        _startDiscovery();
      } else {
        setState(() {
          isDiscovering = false;
          isBluetoothOn = _isBluetoothOn(bluetoothState);
        });
        _stopDiscovery();
      }
    });
  }

  void _startDiscovery() {
    print('_startDiscovery');

    _streamDiscoverySubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        print('Found: ' + r.toString());
        results.add(r);
      });
    });

    print(_streamDiscoverySubscription.hashCode);

    _streamDiscoverySubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  void _stopDiscovery() {
    _streamDiscoverySubscription?.cancel();
  }

  void _restartDiscovery() {
    if (isBluetoothOn) {
      setState(() {
        results.clear();
        isDiscovering = true;
      });
      _startDiscovery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select location'),
        actions: [buildToggleBluetoothButton()],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!isBluetoothOn) return Text('Bluetooth OFF');
    return RefreshIndicator(
        child: BluetoothDeviceList(
          bluetoothDiscoveryResults: results,
          isDiscovering: isDiscovering,
        ),
        onRefresh: () async => _restartDiscovery());
  }

  Widget buildToggleBluetoothButton() {
    if (isBluetoothOn) {
      return IconButton(
        icon: Icon(Icons.bluetooth),
        onPressed: () => {
          Fluttertoast.showToast(msg: 'Turning Bluetooth OFF'),
          FlutterBluetoothSerial.instance.requestDisable().then((value) => value
              ? Fluttertoast.showToast(msg: 'Bluetooth OFF')
              : Fluttertoast.showToast(msg: 'Error occurred'))
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.bluetooth_disabled),
        onPressed: () => {
          Fluttertoast.showToast(msg: 'Turning Bluetooth ON'),
          FlutterBluetoothSerial.instance.requestEnable().then((value) => value
              ? Fluttertoast.showToast(msg: 'Bluetooth On')
              : Fluttertoast.showToast(msg: 'Error occurred'))
        },
      );
    }
  }



  @override
  void dispose() {
    _streamDiscoverySubscription?.cancel();
    _streamStateSubscription?.cancel();
    super.dispose();
  }
}
