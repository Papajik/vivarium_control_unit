import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

class LocationService {
  static Future<bool> checkAndEnableLocation() async {
    var location = Location();
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    return _serviceEnabled;
  }
}
