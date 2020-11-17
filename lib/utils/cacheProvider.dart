import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vivarium_control_unit/models/device/triggers/feedTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/ledTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/outletTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/waterHeaterType.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class HiveCache extends CacheProvider {
  Box _preferences;

  @override
  Future<void> init() async {
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        print('Init Hive boxes');
        var dir = await getApplicationDocumentsDirectory();
        Hive
          ..init(dir.path)
          ..registerAdapter(FeedTypeAdapter())
          ..registerAdapter(LedTriggerAdapter())
          ..registerAdapter(FeedTriggerAdapter())
          ..registerAdapter(HeaterTypeAdapter())
          ..registerAdapter(OutletTriggerAdapter());
        _preferences = await Hive.openBox(HiveBoxes.mainBox);
      }
    }
  }

  @override
  bool containsKey(String key) {
    return _preferences?.containsKey(key);
  }

  @override
  bool getBool(String key) {
    return _preferences?.get(key);
  }

  @override
  double getDouble(String key) {
    return _preferences?.get(key);
  }

  @override
  int getInt(String key) {
    return _preferences?.get(key);
  }

  @override
  Set<E> getKeys<E>() {
    return _preferences?.keys?.cast<E>()?.toSet();
  }

  @override
  String getString(String key) {
    return _preferences?.get(key);
  }

  @override
  T getValue<T>(String key, T defaultValue) {
    var value = _preferences?.get(key);
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  @override
  Future<void> remove(String key) async {
    if (containsKey(key)) {
      await _preferences?.delete(key);
    }
  }

  @override
  Future<void> removeAll() async {
    final keys = getKeys();
    await _preferences?.deleteAll(keys);
  }

  @override
  Future<void> setBool(String key, bool value) {
    return _preferences?.put(key, value);
  }

  @override
  Future<void> setDouble(String key, double value) {
    return _preferences?.put(key, value);
  }

  @override
  Future<void> setInt(String key, int value) {
    return _preferences?.put(key, value);
  }

  @override
  Future<void> setObject<T>(String key, T value) {
    return _preferences?.put(key, value);
  }

  @override
  Future<void> setString(String key, String value) {
    return _preferences?.put(key, value);
  }
}
