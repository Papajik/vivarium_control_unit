import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';
import 'package:vivarium_control_unit/utils/platform/platform.dart';

final String _title = 'Vivarium control';

/// Background service
/// Used for periodic checks against Firebase Database
class BackgroundService {
  static final DatabaseService _db = DatabaseService();

  static StreamSubscription? subscription;

  static bool isOnline = true;

  static String? _userId;

  static set userId(String? value) {
    _userId = value;
  }

  static Future<bool> get running async =>
      await FlutterBackgroundService().isServiceRunning();

  static void serviceCallback(FlutterBackgroundService service) async {
    /// Check internet connection
    if (!isOnline) {
      service.setNotificationInfo(
          title: _title,
          content: "You are offline. Can't update device status");
      return;
    }

    /// When no user sign in
    if (_userId == null) {
      service.setNotificationInfo(
          title: _title, content: 'Sign in within the app');
      return;
    }
    var offlineDeviceCount = 0;
    var devices = await _db.getDevices(_userId);

    if (devices.isEmpty) {
      /// No devices
      service.setNotificationInfo(
          title: _title, content: 'No active vivariums');
      return;
    } else {
      devices.forEach((device) {
        if (!device.isAlive) {
          offlineDeviceCount++;
        }
      });
    }
    service.setNotificationInfo(
      title: _title,
      content: offlineDeviceCount == 0
          ? 'All your devices are online!'
          : offlineDeviceCount == 1
              ? '1 of your devices is offline!'
              : '$offlineDeviceCount of your devices are offline!',
    );
  }

  static void sendUserId(String? userId) {
    if (!PlatformInfo.isAppOS()) return;
    FlutterBackgroundService().sendData({'userId': userId});
  }

  static Future<bool> start() async {
    if (!PlatformInfo.isAppOS()) return false;
    if (await FlutterBackgroundService.initialize(_onStart)) {
      var toContinue = true;

      await Future.doWhile(() async {
        await Future.delayed(Duration(seconds: 1));
        if (await FlutterBackgroundService().isServiceRunning()) {
          toContinue = false;
          sendUserId(Auth.user.userId);
        }

        return toContinue;
      }).timeout(
        Duration(seconds: 2),
        onTimeout: () => toContinue = false,
      );

      return true;
    } else {
      return false;
    }
  }

  static void stop() {
    if (PlatformInfo.isWeb()) return;
    FlutterBackgroundService().sendData(
      {'action': 'stopService'},
    );
  }
}

/// Method called within the service
void _onStart() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var service = FlutterBackgroundService();

  /// connectivity
  BackgroundService.isOnline =
      ConnectivityResult.none != await (Connectivity().checkConnectivity());
  if (BackgroundService.subscription != null) {
    await BackgroundService.subscription!.cancel();
  }
  BackgroundService.subscription =
      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    BackgroundService.isOnline = result != ConnectivityResult.none;
    BackgroundService.serviceCallback(service);
  });

  /// Message stream
  service.onDataReceived.listen((event) {
    if (event!['userId'] != null) {
      BackgroundService.userId = event['userId'];
      service.setNotificationInfo(
          title: _title, content: 'User signed in. Waiting for data...');
    }

    if (event['action'] == 'stopService') {
      service.stopBackgroundService();
    }
  });

  service.setForegroundMode(true);
  service.setAutoStartOnBootMode(true);

  /// Callback
  Timer.periodic(Duration(seconds: 10), (timer) async {
    if (!(await service.isServiceRunning())) {
      await BackgroundService.subscription!.cancel();
      timer.cancel();
    } else {
      BackgroundService.serviceCallback(service);
    }
  });
  BackgroundService.serviceCallback(service);
}
