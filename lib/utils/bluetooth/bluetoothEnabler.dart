import 'dart:async';

import 'package:flutter_blue_elves/flutter_blue_elves.dart';

class BluetoothEnabler {
  static Future<bool?> enableBluetooth() async {
    bool? ok;
    FlutterBlueElves.instance.androidOpenBluetoothService((isOk) {
      ok = isOk;
    });
    await Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 500));
      return ok == null;
    });
    return ok;
  }
}
