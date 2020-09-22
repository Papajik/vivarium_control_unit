import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';

const String BLE_SERVICE = "FFE0";
const String BLE_CHARACTERISTIC = "FFE1";

FlutterBlue flutterBlue = FlutterBlue.instance;

class BluetoothHandler {
  StreamSubscription<BluetoothDeviceState> bluetoothStateSubscription;

  BluetoothDevice bluetoothDevice;
  String macAddress;
  String name;

  StreamController<BluetoothDevice> _deviceController =
      StreamController<BluetoothDevice>.broadcast();

  Stream<BluetoothDevice> device() => _deviceController.stream;

  bool _isConnecting = false;

  BluetoothHandler(String macAddress, String name) {
    this.name = name;
    this.macAddress = macAddress;
  }

  setDevice(BluetoothDevice device) {
    print("setting device = $device");
    bluetoothDevice = device;
    _deviceController.add(bluetoothDevice);
  }

  Future<bool> saveToDeviceDirectly(Uint8List byteArray) async {
    if (bluetoothDevice == null) return false;
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toUpperCase().substring(4, 8) ==
          BLE_SERVICE) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase().substring(4, 8) ==
              BLE_CHARACTERISTIC) {
              sendData();
          }
        });
      }
    }
    return true;
  }

  disconnectDevice() async {
    if (bluetoothDevice != null) {
      await bluetoothDevice.disconnect();
      setDevice(null);
    }
    disconnectDevices();
    _isConnecting = false;
  }

  connectDevice() async {
    print("BluetoothHandler Connect device");
    _isConnecting = true;
    DeviceIdentifier identifier = DeviceIdentifier(macAddress);
    bool connected = await checkConnectedDevices(identifier);
    if (!connected) await connectToNewDevice(identifier);
  }

  closeBroadcast() {
    _deviceController.close();
  }

  isConnecting() {
    return _isConnecting;
  }

  Future<bool> checkConnectedDevices(DeviceIdentifier identifier) async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    print("Connected devices = $devices");
    for (var d in devices) {
      if (d.id == identifier) {
        setDevice(d);
        _isConnecting = false;
        setDeviceStateListener();
        return true;
      }
    }
    return false;
  }

  Future<void> connectToNewDevice(DeviceIdentifier identifier) async {
    //TODO add toast - scanning
    StreamSubscription<List<ScanResult>> _subscription;
    await flutterBlue.startScan(timeout: Duration(seconds: 4)).then((value) => {
          //TODO add toast - connecting
          print("BluetoothHandler scanFinished, value = $value"),
          _subscription = flutterBlue.scanResults.listen((results) {
            for (ScanResult r in results) {
              print("BluetoothHandler deviceId = ${r.device.id}");
              if (r.device.id == identifier) {
                r.device
                    .connect(autoConnect: false, timeout: Duration(seconds: 4))
                    .then((value) => {
                          print("bluetoothHandler connected"),
                          //TODO add toast - connected
                          setDevice(r.device),
                          _isConnecting = false,
                          _subscription.cancel(),
                          _subscription = null,
                          setDeviceStateListener()
                        });
              }
            }
          }),
          print("stop scan"),
          flutterBlue.stopScan(),
        });
  }

  setDeviceStateListener() {
    if (device != null && bluetoothStateSubscription == null)
      bluetoothStateSubscription = bluetoothDevice.state.listen((event) {
        if (event == BluetoothDeviceState.disconnected) {
          setDevice(null);
          bluetoothStateSubscription.cancel();
        }
      });
  }

  void sendData() {}

  Future<void> disconnectDevices() async {
    var connectedDevices = await flutterBlue.connectedDevices;
    for (var d in connectedDevices){
      d.disconnect();
    }
  }
}
