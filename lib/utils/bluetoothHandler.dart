import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

const String BLE_SERVICE = "FFE0";
const String BLE_CHARACTERISTIC = "FFE1";

FlutterBlue flutterBlue = FlutterBlue.instance;

enum HandlerState{CONNECTED, DISCONNECTED}

class BluetoothHandler {
  StreamController<HandlerState> stateController = StreamController<HandlerState>();
  BluetoothDevice _device;
  String macAddress;
  String name;


  bool _isConnecting = false;

  BluetoothHandler(String macAddress, String name){
    this.name = name;
    this.macAddress = macAddress;
    stateController.sink.add(HandlerState.DISCONNECTED);
  }



  Stream<HandlerState> state(){
   return stateController.stream;
  }

  Future<bool> _saveToDevice() async {
    if (_device == null) return false;
    List<BluetoothService> services = await _device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase().substring(4, 8) ==
          BLE_SERVICE) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase().substring(4, 8) ==
              BLE_CHARACTERISTIC) {
            //TODO add Flutter - Arduino communication
          }
        });
      }
    });
    return true;
  }

  bool isDeviceConnected() {
    return _device != null;
  }

  _getDeviceCharacteristic() {
    print("settings subpage: set characteristic");
    _device.discoverServices().then((services) => {
          services.forEach((service) {
            print(service.uuid);
            if (service.uuid.toString().toUpperCase().substring(4, 8) ==
                BLE_SERVICE) {
              print("settings subpage: characteristics:");
              service.characteristics.forEach((characteristic) {
                if (characteristic.uuid
                        .toString()
                        .toUpperCase()
                        .substring(4, 8) ==
                    BLE_CHARACTERISTIC) {
                  print(characteristic);
                }
              });
            }
          })
        });
  }

  disconnectDevice() async {
    if (_device != null) {
      await _device.disconnect();
      _device = null;
    }
    stateController.sink.add(HandlerState.DISCONNECTED);
    _isConnecting = false;
  }

  connectDevice() async {
    _isConnecting = true;
    DeviceIdentifier identifier = DeviceIdentifier(macAddress);
    //TODO add toast - scanning
    StreamSubscription<List<ScanResult>> _subscription;
    await flutterBlue.startScan(timeout: Duration(seconds: 4)).then((value) => {
          //TODO add toast - connecting
          _subscription = flutterBlue.scanResults.listen((results) {
            for (ScanResult r in results) {
              print(r.device.id);
              if (r.device.id == identifier) {
                r.device
                    .connect(autoConnect: false, timeout: Duration(seconds: 4))
                    .then((value) => {
                          //TODO add toast - connected
                          _device = r.device,
                          _isConnecting = false,
                          _subscription.cancel(),
                          _subscription = null,
                          stateController.sink.add(HandlerState.CONNECTED)
                        });
              }
            }
          }),
          print("stop scan"),
          flutterBlue.stopScan(),
        });
  }

  closeStateStream(){
    stateController.close();
  }

  isConnecting() {
    return _isConnecting;
  }
}
