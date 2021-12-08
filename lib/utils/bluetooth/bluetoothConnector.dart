import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:vivarium_control_unit/models/device/deviceSensorData.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/models/device/modules/dht/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/dht/state.dart';
import 'package:vivarium_control_unit/models/device/modules/fan/state.dart';
import 'package:vivarium_control_unit/models/device/modules/feeder/state.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/state.dart';
import 'package:vivarium_control_unit/models/device/modules/hum/state.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';
import 'package:vivarium_control_unit/models/device/modules/ph/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/ph/state.dart';
import 'package:vivarium_control_unit/models/device/modules/waterLevel/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/waterLevel/state.dart';
import 'package:vivarium_control_unit/models/device/modules/waterPump/state.dart';
import 'package:vivarium_control_unit/models/device/modules/waterTemp/sensorData.dart';
import 'package:vivarium_control_unit/models/device/modules/waterTemp/state.dart';
import 'package:vivarium_control_unit/utils/bluetooth/Services.dart';
import 'package:vivarium_control_unit/utils/bluetooth/keyCharacteristicConverter.dart';

enum ClaimStatus { CLAIMED, NOT_CLAIMED, UNKNOWN_DEVICE }

/// Handles Bluetooth connection to Device
/// Can upload new data to device, stream data from device
/// Can get list of supported modules of the device
class BluetoothConnector {
  bool _connecting = false;
  final String deviceId;
  List<VivariumModule>? modules;

  BluetoothConnector({required this.deviceId});

  final StateService _stateService = StateService();
  final SettingsService _settingsService = SettingsService();
  final CredentialService _credentialService = CredentialService();

  final FlutterReactiveBle _flutterReactiveBle = FlutterReactiveBle();

  /// ******
  /// Streams
  /// ******

  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;

  /// Connection State

  final _connectionStateStreamController =
      StreamController<DeviceConnectionState>.broadcast();

  DeviceConnectionState? connectionState;

  bool get isConnected => connectionState == DeviceConnectionState.connected;

  Stream<DeviceConnectionState> get connectionStateStream =>
      _connectionStateStreamController.stream;

  set connectionStateUpdate(ConnectionStateUpdate stateUpdate) {
    if (stateUpdate.deviceId == deviceId) {
      connectionState = stateUpdate.connectionState;
      if (!_connectionStateStreamController.isClosed) {
        _connectionStateStreamController.add(stateUpdate.connectionState);
      }
    }
  }

  /// BLE Status

  BleStatus get bluetoothStatus => _flutterReactiveBle.status;

  Stream<BleStatus> get bluetoothStatusStream =>
      _flutterReactiveBle.statusStream;

  /// ******
  /// Functions
  /// *****

  Future<void> connect({VoidCallback? onConnectionCallback}) async {
    if (_connecting) return;
    _connecting = true;
    await _connectionSubscription?.cancel();

    _connectionSubscription = _flutterReactiveBle
        .connectToDevice(id: deviceId, connectionTimeout: Duration(seconds: 5))
        .timeout(
      Duration(seconds: 5),
      onTimeout: (sink) {
        if (!isConnected) {
          connectionStateUpdate = ConnectionStateUpdate(
              deviceId: deviceId,
              connectionState: DeviceConnectionState.disconnected,
              failure: GenericFailure(
                  code: ConnectionError.failedToConnect, message: 'Timeout'));
        }
      },
    ).listen((event) async {
      connectionStateUpdate = event;
      if (event.connectionState == DeviceConnectionState.connected &&
          onConnectionCallback != null) {
        onConnectionCallback();
      }
    }, onError: (e) => debugPrint('Error = $e'), onDone: () {});
    _connecting = false;
  }

  Future<void> disconnect() async {
    if (_connectionSubscription != null) {
      try {
        await cancelStateSubscriptions();
        await cancelCharacteristicSubscriptions();
        await _connectionSubscription!.cancel();
      } on Exception catch (e, _) {
        debugPrint('Error while disconnecting from the device');
      } finally {
        connectionStateUpdate = ConnectionStateUpdate(
          deviceId: deviceId,
          connectionState: DeviceConnectionState.disconnected,
          failure: null,
        );
      }
    }
  }

  Future<void> cancelCharacteristicSubscriptions() async {
    await _heaterGoalSubscription?.cancel();
    await _heaterPowerSubscription?.cancel();

    await _waterLevelSubscription?.cancel();
    await _waterTempSubscription?.cancel();
    await _dhtHumSubscription?.cancel();
    await _dhtTempSubscription?.cancel();
    await _fanSpeedSubscription?.cancel();
    await _phSubscription?.cancel();
  }

  Future<void> dispose() async {
    await cancelCharacteristicSubscriptions();
    await cancelStateSubscriptions();
    await _connectionStateStreamController.close();
  }

  Future<ClaimStatus> getClaimedStatus() async {
    try {
      final response = await _flutterReactiveBle.readCharacteristic(
          _credentialService.getCharacteristic(
              deviceId, _credentialService.IS_CLAIMED));
      return String.fromCharCodes(response).contains('true')
          ? ClaimStatus.CLAIMED
          : ClaimStatus.NOT_CLAIMED;
    } catch (e) {
      return ClaimStatus.UNKNOWN_DEVICE;
    }
  }

  Stream<bool> isDeviceClaimedStream() {
    return _flutterReactiveBle
        .subscribeToCharacteristic(_credentialService.getCharacteristic(
            deviceId, _credentialService.IS_CLAIMED))
        .map((event) {
      return String.fromCharCodes(event).contains('true');
    });
  }

  Future<String?> claimDevice(
      {required String userId,
      required String deviceId,
      required String ssid,
      required String password,
      required String name}) async {
    try {
      await _flutterReactiveBle.writeCharacteristicWithResponse(
          _credentialService.getCharacteristic(
              deviceId, _credentialService.USER_ID),
          value: (userId + '*').codeUnits);

      await setCredentials(ssid: ssid, pass: password);

      await _flutterReactiveBle.writeCharacteristicWithResponse(
          _credentialService.getCharacteristic(
              deviceId, _credentialService.BLE_NAME),
          value: name.codeUnits);

      return trimStringFromCharacteristic(
          await _flutterReactiveBle.readCharacteristic(_credentialService
              .getCharacteristic(deviceId, _credentialService.DEVICE_ID)));
    } catch (e) {
      debugPrint('claimDevice' + e.toString());
      return null;
    }
  }

  Future<bool> claimCamera(
      {required String userId,
      required String deviceFirebaseId,
      required String ssid,
      required String password,
      required String name}) async {
    try {
      await _flutterReactiveBle.writeCharacteristicWithResponse(
          _credentialService.getCharacteristic(
              deviceId, _credentialService.DEVICE_ID),
          value: (deviceFirebaseId + '*').codeUnits);

      await _flutterReactiveBle.writeCharacteristicWithResponse(
          _credentialService.getCharacteristic(
              deviceId, _credentialService.USER_ID),
          value: (userId + '*').codeUnits);

      await setCredentials(ssid: ssid, pass: password);

      await _flutterReactiveBle.writeCharacteristicWithResponse(
          _credentialService.getCharacteristic(
              deviceId, _credentialService.BLE_NAME),
          value: name.codeUnits);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> unclaimCamera({required String deviceId}) async {
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.USER_ID),
        value: '*'.codeUnits);

    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.DEVICE_ID),
        value: '*'.codeUnits);

    await clearCredentials();

    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.BLE_NAME),
        value: ''.codeUnits);
  }

  String trimStringFromCharacteristic(List<int> raw) {
    if (raw.last == 0) {
      return String.fromCharCodes(raw.sublist(0, raw.length - 1));
    } else {
      return String.fromCharCodes(raw);
    }
  }

  Future<void> unclaimDevice({required String deviceId}) async {
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.USER_ID),
        value: '*'.codeUnits);

    await clearCredentials();
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.BLE_NAME),
        value: ''.codeUnits);
  }

  Future<void> setCredentials(
      {required String ssid, required String pass}) async {
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.WIFI_PASS),
        value: pass.codeUnits);
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.WIFI_SSID),
        value: ssid.codeUnits);
  }

  Future<void> clearCredentials() async {
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.WIFI_PASS),
        value: ''.codeUnits);
    await _flutterReactiveBle.writeCharacteristicWithResponse(
        _credentialService.getCharacteristic(
            deviceId, _credentialService.WIFI_SSID),
        value: ''.codeUnits);
  }

  Future<void> writeCharacteristic(
      QualifiedCharacteristic characteristic, String value) {
    return _flutterReactiveBle.writeCharacteristicWithResponse(characteristic,
        value: value.codeUnits);
  }

  Future<List<VivariumModule>> getModules() async {
    var services = await _flutterReactiveBle.discoverServices(deviceId);

    var discoveredService = services.firstWhereOrNull(
        (service) => service.serviceId == (_stateService.SERVICE_UUID));
    return (discoveredService == null)
        ? []
        : _stateService.getModules(discoveredService.characteristicIds);
  }

  Future<void> printCharacteristics() async {
    var services = await _flutterReactiveBle.discoverServices(deviceId);
    for (var service in services) {
      for (var ch in service.characteristicIds) {}
    }
  }

  Stream<double> doubleStream(QualifiedCharacteristic characteristic) {
    return _flutterReactiveBle
        .subscribeToCharacteristic(characteristic)
        .map((event) => double.parse(String.fromCharCodes(event)));
  }

  Future<void> saveValue({String? key, dynamic value}) async {
    var characteristic = getCharacteristic(key: key, deviceId: deviceId);
    if (characteristic != null) {
      var values = value.toString().codeUnits;

      if (values.isNotEmpty) {
        await _flutterReactiveBle
            .writeCharacteristicWithResponse(characteristic, value: values);
      }
    }
  }

  /// State values

  final _stateStreamController = StreamController<DeviceState?>.broadcast();

  Stream<DeviceState?> get stateStream => _stateStreamController.stream;

  DeviceState? _state;

  DeviceState? get state => _state;

  set state(DeviceState? state) {
    _state = state;
    _stateStreamController.add(state);
  }

  Future<void> initStateStream() async {
    modules ??= await getModules();

    var tempState = DeviceState.emptyFromModules(modules!);

    /// Hum

    if (tempState.hum != null) {
      tempState.hum!.connected = boolFromResponse(await _flutterReactiveBle
          .readCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.HUMIDIFIER_CONNECTED)));

      tempState.hum!.running = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.HUMIDIFIER_IS_ON)));
    }

    /// Heater

    if (tempState.heater != null) {
      tempState.heater!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.HEATER_CONNECTED)));
    }

    /// Water Level
    if (tempState.waterLevel != null) {
      tempState.waterLevel!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.WL_CONNECTED)));
    }

    /// Water Temp

    if (tempState.waterTemp != null) {
      tempState.waterTemp!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.W_TEMP_CONNECTED)));
    }

    /// DHT

    if (tempState.dht != null) {
      tempState.dht!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.DHT_CONNECTED)));
    }

    /// Fan

    if (tempState.fan != null) {
      tempState.fan!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.FAN_CONNECTED)));

      tempState.fan!.speed = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.FAN_CURR_SPEED)));
    }

    /// pH

    if (tempState.ph != null) {
      tempState.ph!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.PH_MODULE_CONNECTED)));
    }

    /// Feeder

    if (tempState.feeder != null) {
      tempState.feeder!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.FEEDER_CONNECTED)));
    }

    /// Water Pump

    if (tempState.pump != null) {
      tempState.pump!.connected = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.W_PUMP_CONNECTED)));

      tempState.pump!.running = boolFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.W_PUMP_IS_ON)));
    }

    ///Outlets
    if (tempState.outlet != null) {
      if (tempState.outlet!.outlets[0].isAvailable!) {
        tempState.outlet!.outlets[0].isOn = boolFromResponse(
            await _flutterReactiveBle.readCharacteristic(_stateService
                .getCharacteristic(deviceId, _stateService.OUTLET_0_ON)));
      }
      if (tempState.outlet!.outlets[1].isAvailable!) {
        tempState.outlet!.outlets[1].isOn = boolFromResponse(
            await _flutterReactiveBle.readCharacteristic(_stateService
                .getCharacteristic(deviceId, _stateService.OUTLET_1_ON)));
      }
      if (tempState.outlet!.outlets[2].isAvailable!) {
        tempState.outlet!.outlets[2].isOn = boolFromResponse(
            await _flutterReactiveBle.readCharacteristic(_stateService
                .getCharacteristic(deviceId, _stateService.OUTLET_2_ON)));
      }
      if (tempState.outlet!.outlets[3].isAvailable!) {
        tempState.outlet!.outlets[3].isOn = boolFromResponse(
            await _flutterReactiveBle.readCharacteristic(_stateService
                .getCharacteristic(deviceId, _stateService.OUTLET_3_ON)));
      }
    }
    state = tempState;
    await startStateStream();
  }

  StreamSubscription? _phConnectedSubscription;
  StreamSubscription? _humConnectedSubscription;
  StreamSubscription? _humRunningSubscription;
  StreamSubscription? _dhtConnectedSubscription;
  StreamSubscription? _waterTempConnectedSubscription;
  StreamSubscription? _waterLevelConnectedSubscription;
  StreamSubscription? _heaterConnectedSubscription;
  StreamSubscription? _fanConnectedSubscription;
  StreamSubscription? _feederConnectedSubscription;
  StreamSubscription? _ledConnectedSubscription;
  StreamSubscription? _waterPumpConnectedSubscription;
  StreamSubscription? _waterPumpRunningSubscription;

  Future<void> cancelStateSubscriptions() async {
    await _phConnectedSubscription?.cancel();
    await _humConnectedSubscription?.cancel();
    await _humRunningSubscription?.cancel();
    await _dhtConnectedSubscription?.cancel();
    await _waterTempConnectedSubscription?.cancel();
    await _waterLevelConnectedSubscription?.cancel();
    await _heaterConnectedSubscription?.cancel();
    await _fanConnectedSubscription?.cancel();
    await _feederConnectedSubscription?.cancel();
    await _ledConnectedSubscription?.cancel();
    await _waterPumpConnectedSubscription?.cancel();
    await _waterPumpRunningSubscription?.cancel();
  }

  Future<void> startStateStream() async {
    modules ??= await getModules();

    await cancelStateSubscriptions();

    /// Hum

    if (state!.hum != null) {
      _humConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.HUMIDIFIER_CONNECTED))
          .listen((event) {
        state = state!.copyWith(
            hum: StateHum(
                connected: boolFromResponse(event),
                running: state!.hum!.running));
      });

      _humRunningSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.HUMIDIFIER_IS_ON))
          .listen((event) {
        state = state!.copyWith(
            hum: StateHum(
                connected: state!.hum!.running,
                running: boolFromResponse(event)));
      });
    }

    /// Heater

    if (state!.heater != null) {
      _heaterConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.HEATER_CONNECTED))
          .listen((event) {
        state = state!.copyWith(
            heater: StateHeater(connected: boolFromResponse(event), goal: 20));
      });
    }

    /// Water Level
    if (state!.waterLevel != null) {
      _waterLevelConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.WL_CONNECTED))
          .listen((event) {
        state = state!.copyWith(
            waterLevel: StateWaterLevel(connected: boolFromResponse(event)));
      });
    }

    /// Water Temp

    if (state!.waterTemp != null) {
      _waterTempConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.W_TEMP_CONNECTED))
          .listen((event) {
        state = state!.copyWith(
            waterTemp: StateWaterTemp(connected: boolFromResponse(event)));
      });
    }

    /// DHT

    if (state!.dht != null) {
      _dhtConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.DHT_CONNECTED))
          .listen((event) {
        state =
            state!.copyWith(dht: StateDht(connected: boolFromResponse(event)));
      });
    }

    /// Fan
    if (state!.fan != null) {
      _fanConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.FAN_CONNECTED))
          .listen((event) {
        state = state!.copyWith(
            fan: StateFan(
                connected: boolFromResponse(event), speed: state!.fan!.speed));
      });

      _fanSpeedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.FAN_CURR_SPEED))
          .listen((event) {
        state = state!.copyWith(
            fan: StateFan(
          connected: state!.fan!.connected,
          speed: doubleFromResponse(event),
        ));
      });
    }

    /// pH

    if (state!.ph != null) {
      _phConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.PH_MODULE_CONNECTED))
          .listen((event) {
        state =
            state!.copyWith(ph: StatePh(connected: boolFromResponse(event)));
      });
    }

    /// Feeder

    if (state!.feeder != null) {
      _feederConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.FEEDER_CONNECTED))
          .listen((event) {
        state = state!
            .copyWith(feeder: StateFeeder(connected: boolFromResponse(event)));
      });
    }

    if (state!.pump != null) {
      _waterPumpConnectedSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.W_PUMP_CONNECTED))
          .listen((event) {
        state = state!.copyWith(
            pump: StatePump(
                connected: boolFromResponse(event),
                running: state!.pump!.running));
      });

      _waterPumpRunningSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.W_PUMP_IS_ON))
          .listen((event) {
        state = state!.copyWith(
            pump: StatePump(
                connected: state!.pump!.connected,
                running: boolFromResponse(event)));
      });
    }
  }

  /// Sensor values

  final _sensorDataStreamController =
      StreamController<DeviceSensorData?>.broadcast();

  Stream<DeviceSensorData?> get sensorDataStream =>
      _sensorDataStreamController.stream;

  StreamSubscription? _heaterGoalSubscription;
  StreamSubscription? _heaterPowerSubscription;
  StreamSubscription? _waterLevelSubscription;
  StreamSubscription? _waterTempSubscription;
  StreamSubscription? _dhtHumSubscription;
  StreamSubscription? _dhtTempSubscription;
  StreamSubscription? _fanSpeedSubscription;
  StreamSubscription? _phSubscription;

  DeviceSensorData? _data;

  DeviceSensorData? get data => _data;

  set data(DeviceSensorData? data) {
    _data = data;
    _sensorDataStreamController.add(data);
  }

  Future<void> initSensorStreamData() async {
    modules ??= await getModules();

    /// Create empty sensor data from available modules
    var tempData = DeviceSensorData.emptyFromModules(modules!);

    if (tempData.heater != null) {
      /// Heater Goal
      tempData.heater!.tempGoal = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_settingsService
              .getCharacteristic(deviceId, _settingsService.HEATER_GOAL)));

      tempData.heater!.power = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.HEATER_CURR_POWER)));
    }

    /// Water Level
    if (tempData.waterLevel != null) {
      tempData.waterLevel!.level = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.WL_CURRENT_LEVEL)));
    }

    /// Water Temp

    if (tempData.waterTemp != null) {
      tempData.waterTemp!.currentTemp = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.W_TEMP_CURR_TEMP)));
    }

    /// DHT

    if (tempData.dht != null) {
      tempData.dht!.humidity = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.DHT_CURR_HUMIDITY)));

      tempData.dht!.temperature = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(_stateService
              .getCharacteristic(deviceId, _stateService.DHT_CURR_TEMP)));
    }

    /// pH

    if (tempData.ph != null) {
      tempData.ph!.currentPh = doubleFromResponse(
          await _flutterReactiveBle.readCharacteristic(
              _stateService.getCharacteristic(deviceId, _stateService.PH_CUR)));
    }

    data = tempData;
    await startSensorDataStream();
  }

  /// Start characteristic subscriptions

  Future<void> startSensorDataStream() async {
    await cancelCharacteristicSubscriptions();

    /// Heater
    if (data!.heater != null) {
      _heaterGoalSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_settingsService.getCharacteristic(
              deviceId, _settingsService.HEATER_GOAL))
          .listen((event) {
        data = data!.copyWith(
            heater: SensorDataHeater(
                power: data!.heater!.power,
                tempGoal: doubleFromResponse(event)));
      });

      _heaterPowerSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.HEATER_CURR_POWER))
          .listen((event) {
        data = data!.copyWith(
            heater: SensorDataHeater(
                power: doubleFromResponse(event),
                tempGoal: data!.heater!.tempGoal));
      });
    }

    /// Water Level
    if (data!.waterLevel != null) {
      _waterLevelSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.WL_CURRENT_LEVEL))
          .listen((event) {
        data = data!.copyWith(
            waterLevel: SensorDataWaterLevel(level: doubleFromResponse(event)));
      });
    }

    if (data!.waterTemp != null) {
      _waterTempSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.W_TEMP_CURR_TEMP))
          .listen((event) {
        data = data!.copyWith(
            waterTemp:
                SensorDataWaterTemp(currentTemp: doubleFromResponse(event)));
      });
    }

    /// DHT
    if (data!.dht != null) {
      _dhtHumSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.DHT_CURR_HUMIDITY))
          .listen((event) {
        data = data!.copyWith(
            dht: SensorDataDht(
                humidity: doubleFromResponse(event),
                temperature: data!.dht!.temperature));
      });

      _dhtTempSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(_stateService.getCharacteristic(
              deviceId, _stateService.DHT_CURR_TEMP))
          .listen((event) {
        data = data!.copyWith(
            dht: SensorDataDht(
                humidity: data!.dht!.humidity,
                temperature: doubleFromResponse(event)));
      });
    }

    /// pH

    if (data!.ph != null) {
      _phSubscription = _flutterReactiveBle
          .subscribeToCharacteristic(
              _stateService.getCharacteristic(deviceId, _stateService.PH_CUR))
          .listen((event) {
        data = data!.copyWith(
            ph: SensorDataPh(
          currentPh: doubleFromResponse(event),
        ));
      });
    }
  }

  double doubleFromResponse(List<int> response) {
    var list = Uint8List.fromList(response);
    var bd = list.buffer.asByteData();
    var d = bd.getFloat32(0, Endian.little);
    return double.parse(d.toStringAsFixed(2));
  }

  bool boolFromResponse(List<int> response) {
    return String.fromCharCodes(response).startsWith('true');
  }
}
