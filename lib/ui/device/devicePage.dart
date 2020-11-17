import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bs;
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/camera/deviceViewSubpage.dart';
import 'package:vivarium_control_unit/ui/device/overview/deviceOverviewSubpage.dart';
import 'package:vivarium_control_unit/ui/device/settings/deviceSettingsSubpage.dart';
import 'package:vivarium_control_unit/utils/auth.dart';
import 'package:vivarium_control_unit/utils/bluetoothProvider.dart';
import 'package:vivarium_control_unit/utils/settingsConverter.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  DevicePage({Key key, this.device}) : super(key: key);

  @override
  _DevicePage createState() => _DevicePage();
}

class _DevicePage extends State<DevicePage> {
  BluetoothProvider _bluetoothProvider;
  SettingsConverter _settingsConverter;
  StreamSubscription<bs.BluetoothState> subscription;

  @override
  void initState() {
    super.initState();
    print('devicePage initState');
    _bluetoothProvider = BluetoothProvider(
        id: widget.device.info.macAddress, name: widget.device.info.name);

    print('bluetooth done');
    _settingsConverter =
        SettingsConverter(userId: userId, deviceId: widget.device.info.id);

    print('settings converter done');

    ///Whenever is bluetooth state changed, rebuild widget
    subscription = bs.FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((bs.BluetoothState state) {
      setState(() {});
    });
    print('devicePage initState end');
  }

  @override
  void dispose() {
    _bluetoothProvider.disconnectBluetoothDevice();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('devicePage build');
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.device.info.name),
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
              DeviceOverviewSubpage(device: widget.device),
              DeviceSettingsSubpage(
                  settingsConverter: _settingsConverter,
                  device: widget.device,
                  bluetoothProvider: _bluetoothProvider),
              DeviceViewSubpage(camera: widget.device.camera),
            ],
          ),
        ));
  }

  FutureBuilder<bs.BluetoothState> _createConnectButtonFuture() {
    return FutureBuilder<bs.BluetoothState>(
        future: bs.FlutterBluetoothSerial.instance.state,
        builder: (context, snapshot) {
          if (!(snapshot.data == bs.BluetoothState.STATE_ON ||
              snapshot.data == bs.BluetoothState.STATE_BLE_ON)) {
            return IconButton(
              icon: Icon(Icons.bluetooth),
              onPressed: () =>
                  bs.FlutterBluetoothSerial.instance.requestEnable(),
            );
          }
          return buildConnectButton(context);
        });
  }

  StreamBuilder buildConnectButton(BuildContext context) {
    return StreamBuilder<BluetoothDeviceState>(
      stream: _bluetoothProvider.deviceStateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        return IconButton(
            icon: _icon(snapshot.data), onPressed: _onPressed(snapshot.data));
      },
    );
  }

  Function _onPressed(BluetoothDeviceState state) {
    if (state == BluetoothDeviceState.connected) {
      return ()=>{_bluetoothProvider.disconnectBluetoothDevice()};
    }

    if (state == BluetoothDeviceState.disconnected){
      return ()=>{_bluetoothProvider.connectBluetoothDevice()};
    }
    return null;
  }

  Widget _icon(BluetoothDeviceState state) {
    if (state == BluetoothDeviceState.connected) {
      return Icon(Icons.link_off, color: Colors.orange);
    } else {
      return Icon(Icons.insert_link, color: Colors.white);
    }
  }



}
