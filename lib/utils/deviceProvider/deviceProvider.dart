import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';

class DeviceProvider {
  /// Support
  Device device;

  set deviceSink(Device device) {
    device = device;
    _deviceController.add(DeviceStreamObject(device: device));
  }

  final BluetoothConnector? bluetoothConnector;

  final DatabaseService _databaseService = DatabaseService();

  /// Constructor
  DeviceProvider({this.bluetoothConnector, required this.device});

  final StreamController<DeviceStreamObject> _deviceController =
      StreamController<DeviceStreamObject>.broadcast();

  final StreamController<SensorDataHistory> _deviceSensorDataHistoryController =
      StreamController<SensorDataHistory>.broadcast();

  StreamSubscription? _firestoreDeviceHistoryStreamSubscription;
  StreamSubscription? _firestoreDeviceStreamSubscription;
  StreamSubscription? _bluetoothConnectionSubscription;
  StreamSubscription? _bluetoothSensorDataSubscription;
  late StreamSubscription _bluetoothStateSubscription;

  bool streamInitialized = false;

  Stream<DeviceStreamObject> deviceStream({required String deviceId}) {
    /// Cancel previous subscriptions
    _firestoreDeviceStreamSubscription?.cancel();
    _bluetoothConnectionSubscription?.cancel();

    /// If Connector exist (must be AppsOS)
    if (bluetoothConnector != null) {
      /// Check current status and behave accordingly

      if (bluetoothConnector!.isConnected) {
        _onBleConnected();
      } else {
        _onBleDisconnected(deviceId);
      }

      /// Start switching between firebase and bluetooth
      _bluetoothConnectionSubscription = bluetoothConnector!
          .connectionStateStream
          .listen((DeviceConnectionState update) {
        /// Stop Firebase and Enable BLE stream on connected
        if (update == DeviceConnectionState.connected) {
          _onBleConnected();
        }

        /// Stop BLE stream and enable Firebase stream on disconnected
        if (update == DeviceConnectionState.disconnected) {
          _onBleDisconnected(deviceId);
        }
      });
    } else {
      startFirebaseDeviceStreamSubscription(deviceId);
    }

    /// Bluetooth connection

    return _deviceController.stream;
  }

  Stream<SensorDataHistory> deviceSensorDataHistoryStream(
      {required String deviceId, String? deviceMac, String? userId}) {
    /// Firebase
    _firestoreDeviceHistoryStreamSubscription?.cancel();
    _firestoreDeviceHistoryStreamSubscription =
        _databaseService.deviceHistory(deviceId).listen((history) {
      _deviceSensorDataHistoryController.add(history);
    });

    return _deviceSensorDataHistoryController.stream;
  }

  void dispose() {
    _firestoreDeviceStreamSubscription?.cancel();
    _bluetoothConnectionSubscription?.cancel();
    _firestoreDeviceHistoryStreamSubscription?.cancel();
    _bluetoothSensorDataSubscription?.cancel();
  }

  /// Saving values

  /// Saves value. Values are always saved to firebase
  /// Saves to device on BLE connection active
  Future<bool> saveValue({required String key, required dynamic value}) async {
    if (bluetoothConnector != null) {
      if (bluetoothConnector!.isConnected) {
        await bluetoothConnector!.saveValue(key: key, value: value);
      }
    }
    return await _databaseService.saveItem(
        value: value, deviceId: device.info.id, key: key);
  }

  /// Used to push triggers to database
  /// Bluetooth is not supported yet  //TODO bluetooth
  Future<String?> pushValue(
      {required String deviceId,
      String? deviceMac,
      required String key,
      dynamic value}) async {
    return await _databaseService.pushItem(
        key: key, value: value, deviceId: deviceId);
  }

  /// Can be called only when _onBleConnected is not NULL
  void _onBleConnected() async {
    /// Firestore
    await _firestoreDeviceStreamSubscription?.cancel();

    /// BLE - State
    _bluetoothStateSubscription =
        bluetoothConnector!.stateStream.listen((state) {
      deviceSink = device.copyWith(state: state);
    });

    _bluetoothStateSubscription.onDone(() {
      bluetoothConnector!.cancelStateSubscriptions();
    });

    /// BLE - Sensor Data
    _bluetoothSensorDataSubscription =
        bluetoothConnector!.sensorDataStream.listen((sensorData) {
      deviceSink = device.copyWith(sensorData: sensorData);
    });

    _bluetoothSensorDataSubscription!.onDone(() {
      bluetoothConnector!.cancelCharacteristicSubscriptions();
    });
  }

  Future<void> deleteDevice(String deviceId) async {
    await _databaseService.saveItem(
        value: false, key: DEVICE_ACTIVE, deviceId: deviceId);
  }

  void startFirebaseDeviceStreamSubscription(String deviceId) {
    _firestoreDeviceStreamSubscription =
        _databaseService.device(deviceId).listen((d) {
      deviceSink = d;
    });
  }

  void _onBleDisconnected(String deviceId) {
    _bluetoothSensorDataSubscription?.cancel();
    startFirebaseDeviceStreamSubscription(deviceId);
  }
}
