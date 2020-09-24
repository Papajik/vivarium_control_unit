import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';

const String BLE_SERVICE = "FFE0";
const String BLE_CHARACTERISTIC = "FFE1";

FlutterBlue flutterBlue = FlutterBlue.instance;

class BluetoothHandler {
  StreamSubscription<BluetoothDeviceState> bluetoothStateSubscription;
  StreamSubscription<List<int>> characteristicValueStreamSubscription;

  BluetoothDevice bluetoothDevice;
  BluetoothCharacteristic _characteristic;
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

  setDevice(BluetoothDevice device) async {
    print("setting device = $device");
    bluetoothDevice = device;
    if (device != null) {
      _characteristic = await findCharacteristic();
      if (_characteristic != null) print("characteristic is set");
      characteristicValueStreamSubscription =
          _characteristic?.value?.listen((event) {
        print("code from arduino = $event");
      });
    } else {
      await characteristicValueStreamSubscription?.cancel();
    }
    _deviceController.add(bluetoothDevice);
  }

  Future<bool> saveToDeviceDirectly(Uint8List byteArray) async {


    if (bluetoothDevice == null) return false;
    await _characteristic.write([1]);
    await _characteristic.write(byteArray);
    await Future.delayed(Duration(seconds: 2));
   // await _characteristic.write(byteArray.getRange(0, 60).toList());
    //_characteristic.write(byteArray.getRange(0, 10).toList());
    //await Future.delayed(Duration(seconds: 3));
    //_characteristic.write(byteArray.getRange(10, 67).toList());
    return true;

    int length = byteArray.length;
    print("Length = $length");
    int index = 0;
    int bufferSize = 10;
    while (index < length-bufferSize){
      Iterable subset = byteArray.getRange(index, index+bufferSize);
      print("sending  =  $subset");
      _characteristic.write(byteArray);
      await Future.delayed(Duration(milliseconds: 1000));
      index+=bufferSize;
    }


    _characteristic.write(byteArray.getRange(index, length));
    return true;
  }

  disconnectDevice() async {
    if (bluetoothDevice != null) {
      await bluetoothDevice.disconnect();
      await setDevice(null);
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
        await setDevice(d);
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
                    .then((value) async => {
                          print("bluetoothHandler connected"),
                          //TODO add toast - connected
                          await setDevice(r.device),
                          _isConnecting = false,
                          _subscription.cancel(),
                          _subscription = null,
                          await setDeviceStateListener()
                        });
              }
            }
          }),
          print("stop scan"),
          flutterBlue.stopScan(),
        });
  }

  setDeviceStateListener() async {
    if (device != null && bluetoothStateSubscription == null)
      bluetoothStateSubscription = bluetoothDevice.state.listen((event) async {
        if (event == BluetoothDeviceState.disconnected) {
          await setDevice(null);
          bluetoothStateSubscription.cancel();
        }
      });
  }

  Future<void> disconnectDevices() async {
    var connectedDevices = await flutterBlue.connectedDevices;
    for (var d in connectedDevices) {
      d.disconnect();
    }
  }

  Future<BluetoothCharacteristic> findCharacteristic() async {
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toUpperCase().substring(4, 8) ==
          BLE_SERVICE) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (var c in characteristics) {
          if (c.uuid.toString().toUpperCase().substring(4, 8) ==
              BLE_CHARACTERISTIC) {
            return c;
          }
        }
      }
    }
    return null;
  }
}
