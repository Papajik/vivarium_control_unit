import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';

class BluetoothScanner {
  final _flutterReactiveBle = FlutterReactiveBle();

  final List<BluetoothDevice> _devices = [];

  final StreamController<BluetoothDeviceEncapsulation> _devicesController =
      StreamController<BluetoothDeviceEncapsulation>.broadcast();

  Stream<BluetoothDeviceEncapsulation> get devices => _devicesController.stream;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  final StreamController<bool> _isScanningController =
      StreamController<bool>.broadcast();

  Stream<bool> get isScanning => _isScanningController.stream;

  Future<void> startDeviceScan({Duration? timeout}) async {
    await _scanSubscription?.cancel();
    _isScanningController.add(true);
    _devicesController.add(BluetoothDeviceEncapsulation());
    _scanSubscription = _flutterReactiveBle
        .scanForDevices(withServices: [], scanMode: ScanMode.lowLatency)
        .listen((device) {
      var bDevice = BluetoothDevice(
          name: device.name, macAddress: device.id, rssi: device.rssi);


      final knownDeviceIndex =
          _devices.indexWhere((d) => d.macAddress == device.id);
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = bDevice;
      } else {
        _devices.add(bDevice);
      }
      _devicesController.add(BluetoothDeviceEncapsulation(devices: _devices));
    });

    if (timeout != null) {
      Future.delayed(timeout, () => stopDeviceScan());
    }
  }

  Future<void> stopDeviceScan() async {
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    if (!_isScanningController.isClosed) _isScanningController.add(false);
  }

  void dispose() {
    stopDeviceScan();
    _isScanningController.close();
    _devicesController.close();
  }
}
