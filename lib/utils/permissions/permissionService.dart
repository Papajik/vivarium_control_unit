import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

enum PermissionStatus { denied, granted }

class PermissionService {
  static PermissionStatus? _permissionStatus;

  static PermissionStatus? get permissionStatus => _permissionStatus;

  static set permissionStatus(PermissionStatus? value) {
    _permissionStatus = value;
    _locationGrantedStreamController.add(value);
  }

  static final _locationGrantedStreamController =
      StreamController<PermissionStatus?>.broadcast();

  static Stream<PermissionStatus?> get locationGrantedStream =>
      _locationGrantedStreamController.stream;

  static Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    var statuses =
        await [Permission.location, Permission.locationAlways].request();
    return statuses[Permission.location]!.isGranted &&
        statuses[Permission.locationAlways]!.isGranted;
  }

  static Future<bool> checkAndEnablePermission() async {
    if (await isLocationPermissionGranted()) {
      permissionStatus = PermissionStatus.granted;
      return true;
    } else {
      if (await requestLocationPermission()) {
        permissionStatus = PermissionStatus.granted;
        return true;
      } else {
        permissionStatus = PermissionStatus.denied;
        return false;
      }
    }
  }
}
