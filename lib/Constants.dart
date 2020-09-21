import 'package:flutter/material.dart';

class Constants extends InheritedWidget {
  static Constants of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType();

  const Constants({Widget child, Key key}) : super(key: key, child: child);

  final String logoutText = "Log out";
  final String notSignedText = "Sign In";
  final String signInWarningText = "You need to sign in first";
  final String bluetoothOffWarningText = "You need to turn bluetooth ON first";
  final String bluetoothNoDevice = "Couldn't find device";
  final String deviceOverview = "Overview";
  final String deviceSettings = "Settings";
  final String deviceSaveSettings = "Save settings";
  final String deviceView = "Camera";
  final String settingsWaterLevelTitle = "Water Level";
  final String settingsWaterLevelSensorHeight= "Sensor height";
  final String settingsWaterLevelMaxHeight= "Max water height";
  final String settingsWaterLevelMinHeight= "Min water height";

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}


