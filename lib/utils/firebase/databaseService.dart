import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device/camera/camera.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/models/userSettings/userSettings.dart';
import 'package:vivarium_control_unit/utils/platform/platform.dart';

final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
final _databaseReference = _firebaseDatabase.reference();

class DatabaseService {
  static Future<bool> setPersistence() async {
    if (!PlatformInfo.isWeb()) {
      return await _firebaseDatabase.setPersistenceEnabled(true);
    } else {
      return false;
    }
  }

  void onNewUser(String userId) {
    _databaseReference.child('users').child(userId).set({
      'tokens': [],
      'settings': UserSettings(
              notificationDelay: 5000,
              distinctNotification: true,
              notifyOnConnectionUpdate: true,
              notifyOnCrossLimit: true,
              trackDevicesAlive: true)
          .toJson()
    });
  }

  Future<Device?> addDevice(
      {required String deviceId,
      required List<VivariumModule> modules,
      required String deviceMac,
      required String name,
      required String userId}) async {
    var device = Device.fromModules(
        modules: modules,
        deviceId: deviceId,
        deviceMac: deviceMac,
        name: name,
        userId: userId);
    try {
      await _databaseReference
          .child('devices')
          .child(deviceId)
          .set(device.toJson());
      return device;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Stream<UserSettings> userSettings(String userId) => _databaseReference
      .child('users')
      .child(userId)
      .child('settings')
      .onValue
      .map((event) => UserSettings.fromJson(event.snapshot.value));

  Stream<List<String>> firmware() {
    return _databaseReference.child('firmware').onValue.map((event) =>
        (event.snapshot.value as Map).keys.map((e) => e.toString()).toList());
  }

  Stream<Device> device(String deviceId) =>
      _databaseReference.child('devices').child(deviceId).onValue.map((event) {
        return Device.fromJson(event.snapshot.value);
      });

  Stream<SensorDataHistory> deviceHistory(String deviceId) => _databaseReference
          .child('sensorData')
          .child(deviceId)
          .limitToLast(400)
          .onValue
          .map((event) {
        return SensorDataHistory.fromJson(event.snapshot.value);
      });

  Stream<List<Device>> devices(String userId) => _databaseReference
          .child('devices')
          .orderByChild('info/owner')
          .equalTo(userId)
          .onValue
          .map((event) {
        if (event.snapshot.value == null) return [];
        return (event.snapshot.value as Map)
            .values
            .map((value) => Device.fromJson(value))
            .toList()
            .where((device) => device.info.active)
            .toList();
      });

  Future<List<Device>> getDevices(String? userId,
      {bool checkActive = true, bool checkALiveTracking = true}) async {
    return _databaseReference
        .child('devices')
        .orderByChild('info/owner')
        .equalTo(userId)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) return [];
      return (snapshot.value as Map)
          .values
          .map((value) => Device.fromJson(value))
          .toList()
          .where((device) =>
              (!checkActive || device.info.active) &&
              (!checkALiveTracking || device.settings.general.trackAlive))
          .toList();
    });
  }

  Future<bool> saveItem(
      {required String deviceId, value, required String key}) async {
    try {
      print('Save item. Key= $key, value=$value');
      await _databaseReference
          .child('devices')
          .child(deviceId)
          .child(key)
          .set(value);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> saveSettings(
      {required String userId, value, required String key}) async {
    try {
      await _databaseReference
          .child('users')
          .child(userId)
          .child('settings')
          .child(key)
          .set(value);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<String?> pushItem(
      {required String deviceId, value, required String key}) async {
    try {
      var d =
          _databaseReference.child('devices').child(deviceId).child(key).push();
      await d.set(value);
      return d.key;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<bool> deleteItem(
      {required String deviceId, required String key}) async {
    try {
      await _databaseReference
          .child('devices')
          .child(deviceId)
          .child(key)
          .remove();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> setFCMToken(
      {required String userId, required String token}) async {
    try {
      await _databaseReference
          .child('users')
          .child(userId)
          .child('tokens')
          .child(token)
          .set(true);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteFCMToken(
      {required String userId, required String token}) async {
    try {
      await _databaseReference
          .child('users')
          .child(userId)
          .child('tokens')
          .child(token)
          .remove();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<Camera> cameraStream({required String deviceId}) => _databaseReference
          .child('devices')
          .child(deviceId)
          .child('camera')
          .onValue
          .map((event) {
        return Camera.fromJson(event.snapshot.value);
      });
}
