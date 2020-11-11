import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bs;
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/outletTrigger.dart';
import 'package:vivarium_control_unit/ui/device/camera/deviceViewSubpage.dart';
import 'package:vivarium_control_unit/ui/device/overview/deviceOverviewSubpage.dart';
import 'package:vivarium_control_unit/ui/device/settings/deviceSettingsSubpage.dart';
import 'package:vivarium_control_unit/utils/auth.dart';
import 'package:vivarium_control_unit/utils/bluetoothProvider.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class DevicePage extends StatefulWidget {
  final Device device;

  DevicePage({Key key, this.device}) : super(key: key);

  @override
  _DevicePage createState() => _DevicePage();
}

class _DevicePage extends State<DevicePage> {
  BluetoothHandler _bluetoothHandler;
  StreamSubscription<bs.BluetoothState> subscription;

  @override
  void initState() {
    super.initState();
    _bluetoothHandler =
        BluetoothHandler(widget.device.macAddress, widget.device.name);

    ///Whenever is bluetooth state changed, rebuild widget
    subscription = bs.FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((bs.BluetoothState state) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _bluetoothHandler.disconnectDevice();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
              FutureBuilder(
                future: _initializeHive(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Text(''),
                    );
                  }
                  return DeviceSettingsSubpage(
                      useCloud: true,
                      userId: userId,
                      deviceId: widget.device.id,
                      bluetoothHandler: _bluetoothHandler);
                },
              ),
              DeviceViewSubpage(userId: userId, device: widget.device),
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
              onPressed: () => bs.FlutterBluetoothSerial.instance.requestEnable(),
            );
          }
          return buildConnectButton(context);
        });
  }

  buildConnectButton(BuildContext context) {
    return StreamBuilder(
      stream: _bluetoothHandler.device(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return IconButton(
            icon: Icon(Icons.insert_link, color: Colors.white),
            onPressed: _bluetoothHandler.isConnecting()
                ? null
                : () async {
                    await _bluetoothHandler.connectDevice();
                  },
          );
        }
        return IconButton(
          icon: Icon(Icons.link_off, color: Colors.orange),
          onPressed: () async {
            await _bluetoothHandler.disconnectDevice();
            setState(() {});
          },
        );
      },
    );
  }

  Future<bool> _initializeHive() async {
    await Hive.openBox<FeedTrigger>(
        HiveBoxes.feedTriggerList + widget.device.id);
    await Hive.openBox<LedTrigger>(HiveBoxes.ledTriggerList + widget.device.id);
    await Hive.openBox<OutletTrigger>(
        HiveBoxes.outletOneTriggerList + widget.device.id);
    await Hive.openBox<OutletTrigger>(
        HiveBoxes.outletTwoTriggerList + widget.device.id);
    return true;
  }
}
