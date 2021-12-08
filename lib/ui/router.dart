import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/addDevice/addDevicePage.dart';
import 'package:vivarium_control_unit/ui/addDeviceDialog/addDeviceDialog.dart';
import 'package:vivarium_control_unit/ui/device/camera/addCamera/addCameraDialog.dart';
import 'package:vivarium_control_unit/ui/device/camera/addCamera/camerasList/addCameraListPage.dart';
import 'package:vivarium_control_unit/ui/device/settings/advanced/advanced.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/heater/pidTunings.dart';
import 'package:vivarium_control_unit/ui/devices/devicesPage.dart';
import 'package:vivarium_control_unit/ui/homepage/homePage.dart';
import 'package:vivarium_control_unit/ui/login/loginPage.dart';
import 'package:vivarium_control_unit/ui/register/registerPage.dart';
import 'package:vivarium_control_unit/ui/userSettings/SettingsPage.dart';

import 'device/devicePageRoot.dart';
import 'package:vivarium_control_unit/models/advancedSettings/advancedArguments.dart';

class Routes {
  /// Home screen
  static const String home = '/';

  /// Login page
  static const String login = '/login';

  /// Register page
  static const String register = '/register';

  /// List of devices under user
  static const String userDevices = '/userDevices';

  /// User settings
  static const String settings = '/settings';

  /// List of device groups under locations
  static const String locations = '/locations';

  /// List of bluetooth devices - select new device
  static const String addDeviceList = '/addDeviceList';

  /// List of bluetooth devices - select new camera
  static const String addCameraList = '/addCameraList';

  /// Dialog when adding device - input new name, wifi credentials et cetera
  static const String addDeviceDialog = '/d+';

  /// Dialog when adding camera - input new name, wifi credentials et cetera
  static const String addCameraDialog = '/c+';

  /// Device page - browsing current values, history, camera
  static const String device = '/device';

  /// Device advanced settings
  static const String deviceSettings = '/deviceSettings';

  /// PID settings
  static const String pidTuning = '/pidTuning';


}

Map<String, WidgetBuilder> defaultRoutes() => {
      /// Navigation drawer
      Routes.home: (context) => HomePage(),
      Routes.register: (context) => RegisterPage(),
      Routes.login: (context) => LoginPage(),
      Routes.settings: (context) => SettingsPage(),
      Routes.userDevices: (context) => DevicesPage(),
    };

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == null){
      return MaterialPageRoute(
          settings: RouteSettings(name: 'unknown'),
          builder: (_) => defaultPage('unknown'));
    }
    switch (settings.name) {
      case Routes.addDeviceList:
        return MaterialPageRoute(
            settings: RouteSettings(
              name: Routes.addDeviceList,
            ),
            builder: (_) => AddDevicePage());

      case Routes.addCameraList:
        return MaterialPageRoute(
          settings: RouteSettings(name: Routes.addCameraList),
          builder: (_) => (settings.arguments == null)
              ? defaultPage(settings.name)
              : AddCameraPage(deviceId: settings.arguments as String?),
        );


      case Routes.addDeviceDialog:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.addDeviceDialog),
            builder: (_) => (settings.arguments == null)
                ? defaultPage(settings.name)
                : AddDeviceDialog(device: settings.arguments as BluetoothDevice));

      case Routes.addCameraDialog:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.addCameraDialog),
            builder: (_) => (settings.arguments == null)
                ? defaultPage(settings.name)
                : AddCameraDialog(device: settings.arguments as BluetoothDevice));

      case Routes.device:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.device),
            builder: (_) => (settings.arguments == null)
                ? defaultPage(settings.name)
                : DevicePageRoot(device: settings.arguments as Device));

      case Routes.deviceSettings:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.deviceSettings),
            builder: (_) => (settings.arguments == null)
                ? defaultPage(settings.name)
                : AdvancedSettingsPage(arguments: settings.arguments as AdvancedSettingsPageArguments));

      case Routes.pidTuning:
        return MaterialPageRoute(
            settings: RouteSettings(name: Routes.deviceSettings),
            builder: (_) => (settings.arguments == null)
                ? defaultPage(settings.name)
                : PidTunings(arguments: settings.arguments as AdvancedSettingsPageArguments));

      default:
        return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (_) => defaultPage(settings.name));
    }
  }

  static Widget defaultPage(String? name) {
    return Scaffold(
      body: Center(
        child: Text('No route defined for $name'),
      ),
    );
  }
}
