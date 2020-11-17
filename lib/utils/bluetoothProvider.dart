import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';

///Library for device constructor - support connect to bluetooth device without scanning
import 'package:flutter_blue/gen/flutterblue.pb.dart' as proto;
import 'package:vivarium_control_unit/utils/auth.dart';

const String BLE_SERVICE = 'FFE0';
const String BLE_CHARACTERISTIC = 'FFE1';
const String locationVerificationString = '.verification';
const String locationVerificationResponsePrefix = 'deviceId';
const String locationVerificationResponseSuffix = '>';

const String claimString = '.claim:';
const String locationUnknown = 'UNKNOWN';

const String claimResponse = 'claimed';
const String disconnectMsg = 'disconnect';
const String claimFailed = 'failed';

FlutterBlue flutterBlue = FlutterBlue.instance;

enum ClaimStep {
  START,
  CONNECTING,
  CONNECTED,
  HANDSHAKE,
  DEVICE_UNKNOWN,
  DEVICE_VERIFIED,
  CLAIMING,
  CLAIMED,
  CLAIM_FAILED
}

class BluetoothProvider {
  String deviceIdBuffer = '';
  ClaimStep _claimStep;

  /// Claim device or location

  ClaimStep get claimingStep => _claimStep;

  set claimingStep(ClaimStep step) {
    print('Claim step = $step');
    _claimingStepController.add(step);
    _claimStep = step;
  }

  final StreamController<ClaimStep> _claimingStepController =
      StreamController<ClaimStep>.broadcast()..add(ClaimStep.START);

  Stream<ClaimStep> get claimingStepStream => _claimingStepController.stream;

  BluetoothDevice _device;

  String get deviceName => _device.name;

  String get deviceMac => _device.id.toString();

  Stream<BluetoothDeviceState> get deviceStateStream => _device?.state;

  BluetoothCharacteristic _characteristic;

  Stream<List<int>> get characteristicStream => _characteristic?.value;

  StreamSubscription<List<int>> _characteristicValueSubscription;

  BluetoothProvider({String name, String id}) {
    _device = setBluetoothDevice(name: name, id: id);
    claimingStep = ClaimStep.START;
  }

  ///[Name] = name of bluetooth device
  ///[id] = mac address of bluetooth device
  BluetoothDevice setBluetoothDevice({String name, String id}) {
    var p = proto.BluetoothDevice.create();
    p.name = name;
    p.type = proto.BluetoothDevice_Type.LE;
    p.remoteId = id;
    return BluetoothDevice.fromProto(p);
  }

  /// Connect to bluetooth [_device]
  ///
  /// Returns 'true' on successful connect and 'false' otherwise.
  Future<bool> connectBluetoothDevice() async {
    claimingStep = ClaimStep.CONNECTING;
    print('BluetoothHandler Connect device');
    deviceIdBuffer = '';
    return _device.connect(timeout: Duration(seconds: 8)).then((_) {
      claimingStep = ClaimStep.CONNECTED;
      return true;
    }).catchError((error, stacktrace) => false);
  }

  Future<bool> disconnectBluetoothDevice() async {
    await _characteristicValueSubscription?.cancel();
    await _device?.disconnect();
    claimingStep = ClaimStep.START;
    return true;
  }

  Future<bool> findBluetoothCharacteristic() async {
    print('find bluetoothCharacteristic');
    for (var service in await _device.discoverServices()) {
      if (service.uuid.toString().toUpperCase().substring(4, 8) ==
          BLE_SERVICE) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toUpperCase().substring(4, 8) ==
              BLE_CHARACTERISTIC) {
            await characteristic.setNotifyValue(true);
            _characteristic = characteristic;
            _subscribeCharacteristic();
            return true;
          }
        }
        return false;
      }
    }
    return false;
  }

  Future<bool> writeToBluetoothCharacteristic(Uint8List byteArray) async {
    try {
      await _characteristic.write(byteArray);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> writeStringToBluetoothCharacteristic(String s) async {
    try {
      await _characteristic.write(s.codeUnits);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> writeByteArrayToBluetoothCharacteristic(Uint8List s) async {
    try {
      await _characteristic.write(s);
      return true;
    } catch (error) {
      return false;
    }
  }

  /// Starts verification handshake with [device]
  ///
  /// Steps:
  /// 1.  Sends new name and userId
  /// 2.  Receives confirmation String
  /// 3.  Sends 'disconnect' request and disconnect from [device]
  /// 4.  Update Firebase Firestore
  ///
  void startVerifyLocationJob() async {
    print('verifyLocation');
    claimingStep = ClaimStep.HANDSHAKE;

    /// Send verification string to bluetooth. Connected device should
    /// read this string and make a proper response.
    await writeStringToBluetoothCharacteristic(locationVerificationString);

    /// If verification process takes too long, it is more likely
    /// that selected device is not the one user is looking for.
    Future.delayed(
        Duration(seconds: 5),
        () => {
              if (claimingStep.index < ClaimStep.DEVICE_UNKNOWN.index)
                {
                  deviceIdBuffer = locationUnknown,
                  claimingStep = ClaimStep.DEVICE_UNKNOWN,
                }
            });
  }

  void _parseUserId(String data) {
    if (data.contains(locationVerificationResponsePrefix)) {
      data = data.split(':').last;
    }
    data.runes.forEach((rune) {
      var char = String.fromCharCode(rune);
      if (char == locationVerificationResponseSuffix) {
        claimingStep = ClaimStep.DEVICE_VERIFIED;
      } else {
        deviceIdBuffer += char;
      }
    });
  }

  ///Reads bluetooth characteristic from [device]
  void _subscribeCharacteristic() {
    _characteristicValueSubscription = _characteristic.value.listen((event) {
      var response = String.fromCharCodes(event);
      switch (claimingStep) {
        case ClaimStep.CLAIMING:
          _readClaimingResponse(response);
          break;
        case ClaimStep.HANDSHAKE:
          _parseUserId(response);
          break;
        default:
      }
    });
  }

  void _readClaimingResponse(String response) {
    print('claimDevice, gotResponse = $response');
    if (response.startsWith(claimResponse)) {
      claimingStep = ClaimStep.CLAIMED;
    }

    if (response.startsWith(claimFailed)) {
      claimingStep = ClaimStep.CLAIM_FAILED;
    }
  }

  void sendDisconnectedMsg() {
    writeStringToBluetoothCharacteristic(disconnectMsg);
  }

  void claimDevice(String name) {
    claimingStep = ClaimStep.CLAIMING;
    writeStringToBluetoothCharacteristic(
        claimString + '' + name + '~' + userId);
  }

  /// Discovery of devices




}
