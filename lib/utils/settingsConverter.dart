import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/models/device/triggers/feedTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/ledTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/outletTrigger.dart';
import 'package:vivarium_control_unit/models/device/triggers/waterHeaterType.dart';
import 'package:vivarium_control_unit/utils/byteArrayBuilder.dart';
import 'package:vivarium_control_unit/utils/firebaseProvider.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

const String WATER_LEVEL_SENSOR_HEIGHT = 'settings.waterSensorHeight';
const String WATER_LEVEL_MAX_HEIGHT = 'settings.maxWaterHeight';
const String WATER_LEVEL_MIN_HEIGHT = 'settings.minWaterHeight';
const String FEED_TRIGGERS = 'settings.feedTriggers';
const String LED_TRIGGERS = 'settings.ledTriggers';
const String LED_COLOR = 'settings.ledColor';
const String LED_ON = 'settings.ledOn';
const String WATER_OPTIMAL_TEMPERATURE = 'settings.waterOptimalTemperature';
const String WATER_HEATER_TYPE = 'settings.waterHeaterType';
const String WATER_MAX_PH = 'settings.waterMaxPh';
const String WATER_MIN_PH = 'settings.waterMinPh';
const String POWER_OUTLET_ONE_ON = 'settings.powerOutletOneIsOn';
const String POWER_OUTLET_ONE_TRIGGERS = 'settings.powerOutletOneTriggers';
const String POWER_OUTLET_TWO_TRIGGERS = 'settings.powerOutletTwoTriggers';
const String POWER_OUTLET_TWO_ON = 'settings.powerOutletTwoIsOn';


class SettingsConverter {
  final String deviceId;
  final String userId;
  Box mainBox;
  Box<FeedTrigger> feedTriggersBox;
  Box<LedTrigger> ledTriggersBox;
  Box<OutletTrigger> outletOneTriggersBox;
  Box<OutletTrigger> outletTwoTriggersBox;

  bool _initialized;

  bool get initialized => _initialized;

  set initialized(bool b) {
    _initialized = b;
    _initializedStream.add(b);
  }

  final StreamController<bool> _initializedStream =
  StreamController<bool>.broadcast();

  Stream<bool> get initializedStream => _initializedStream.stream;


  SettingsConverter({@required this.deviceId, @required this.userId}) {
    print('SettingsConverter - constructor');
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      initialized = false;
      print('Initializing settings converter');
      _initHive();
    } else{
      initialized = true;
    }
  }

  Future<void> _initHive() async {
        mainBox = Hive.box(HiveBoxes.mainBox);

        print('INIT - feedTriggersBox');
        feedTriggersBox =
        await Hive.openBox<FeedTrigger>(HiveBoxes.feedTriggerList + deviceId);
        print('INIT - ledTriggersBox');
        ledTriggersBox =
        await Hive.openBox<LedTrigger>(HiveBoxes.ledTriggerList + deviceId);
        print('INIT - outletOneTriggersBox');
        outletOneTriggersBox = await Hive.openBox<OutletTrigger>(
            HiveBoxes.outletOneTriggerList + deviceId);
        print('INIT - outletTwoTriggersBox');
        outletTwoTriggersBox = await Hive.openBox<OutletTrigger>(
            HiveBoxes.outletTwoTriggerList + deviceId);
        print('INIT - done');

        //After initializing box is done, stream is notified with new value
        initialized = true;

  }

  Future<bool> loadSettingsFromCloud() async {
    print('Loading from cloud');
    //TODO
    var data = await getDevice(deviceId);
    var settings = data.data()['settings'];


    print('object created');
//     print(settingsObject.ledTriggers);
    await updateCache(DeviceSettings.fromJson(Map<String, dynamic>.from(settings)));
    print('cache updated');
    return true;
  }

  DeviceSettings getSettingsObjectFromCache() {
    return DeviceSettings(
      ledTriggers: ledTriggersBox.values.toList(),
      feedTriggers: feedTriggersBox.values.toList(),
      ledColor: mainBox.get(deviceId + LED_COLOR),
      ledOn: mainBox.get(deviceId + LED_ON),
      maxWaterHeight: mainBox.get(deviceId + WATER_LEVEL_MAX_HEIGHT),
      minWaterHeight: mainBox.get(deviceId + WATER_LEVEL_MIN_HEIGHT),
      powerOutletOneOn: mainBox.get(deviceId + POWER_OUTLET_ONE_ON),
      powerOutletTwoOn: mainBox.get(deviceId + POWER_OUTLET_TWO_ON),
      waterHeaterType:
      getHeaterTypeByName(mainBox.get(deviceId + WATER_HEATER_TYPE)),
      waterMaxPh: mainBox.get(deviceId + WATER_MAX_PH),
      waterMinPh: mainBox.get(deviceId + WATER_MIN_PH),
      waterOptimalTemperature:
      mainBox.get(deviceId + WATER_OPTIMAL_TEMPERATURE),
      waterSensorHeight: mainBox.get(deviceId + WATER_LEVEL_SENSOR_HEIGHT),
    );
  }

  Future<void> updateCache(DeviceSettings settingsObject) async {
    print('settings converter - update cache');
    print('_updateFeedTriggers');
    await _updateFeedTriggers(settingsObject);
    print('_updateLedTriggers');
    await _updateLedTriggers(settingsObject);
    print('_updateOutletOneTriggers');
    await _updateOutletOneTriggers(settingsObject);
    print('_updateOutletTwoTriggers');
    await _updateOutletTwoTriggers(settingsObject);
    print('updateMainBox');
    await updateMainBox(settingsObject);
    print('...');
    return;
  }

  Future<void> _updateLedTriggers(DeviceSettings settingsObject) async {
    await ledTriggersBox.clear();
    await ledTriggersBox.addAll(settingsObject.ledTriggers);
  }

  Future<void> _updateOutletOneTriggers(DeviceSettings settingsObject) async {
    print('updateOutletOneTriggers');
    await outletOneTriggersBox.clear();
    await outletOneTriggersBox.addAll(settingsObject.powerOutletOneTriggers);
  }

  Future<void> _updateOutletTwoTriggers(DeviceSettings settingsObject) async {
    await outletTwoTriggersBox.clear();
    await outletTwoTriggersBox.addAll(settingsObject.powerOutletTwoTriggers);
  }

  Future<void> _updateFeedTriggers(DeviceSettings settingsObject) async {
    await feedTriggersBox.clear();
    await feedTriggersBox.addAll(settingsObject.feedTriggers);
  }

  Future<void> updateMainBox(DeviceSettings settingsObject) async {
    //print("updateMainBox");
    //print("heatertype = ${settingsObject.waterHeaterType.text}");
    await mainBox.clear();
    await mainBox.put(
        deviceId + WATER_LEVEL_SENSOR_HEIGHT, settingsObject.waterSensorHeight);
    await mainBox.put(
        deviceId + WATER_LEVEL_MIN_HEIGHT, settingsObject.minWaterHeight);
    await mainBox.put(
        deviceId + WATER_LEVEL_MAX_HEIGHT, settingsObject.maxWaterHeight);
    await mainBox.put(
        deviceId + WATER_HEATER_TYPE, settingsObject.waterHeaterType.text);
    await mainBox.put(deviceId + WATER_OPTIMAL_TEMPERATURE,
        settingsObject.waterOptimalTemperature);
    await mainBox.put(deviceId + LED_ON, settingsObject.ledOn);
    await mainBox.put(deviceId + LED_COLOR, settingsObject.ledColor);
    await mainBox.put(
        deviceId + POWER_OUTLET_ONE_ON, settingsObject.powerOutletOneOn);
    await mainBox.put(
        deviceId + POWER_OUTLET_TWO_ON, settingsObject.powerOutletTwoOn);
    await mainBox.put(deviceId + WATER_MAX_PH, settingsObject.waterMaxPh);
    await mainBox.put(deviceId + WATER_MIN_PH, settingsObject.waterMinPh);

    //  print("after:");
    //  print(mainBox.values);
  }

  List<FeedTrigger> getFeedTriggers() {
    return feedTriggersBox.values.toList();
  }

  List<LedTrigger> getLedTriggers() {
    return ledTriggersBox.values.toList();

  }
  List<OutletTrigger> getOutletOneTrigger() {
    return outletOneTriggersBox.values.toList();
  }

  List<OutletTrigger> getOutletTwoTrigger() {
    return outletTwoTriggersBox.values.toList();
  }

  Future<void> saveItem(String key, dynamic value) async {
    await saveItemToCloud(key, value);
    await saveToCache(deviceId + key, value);
  }

  Future<void> saveToCache(String key, dynamic value) async {
    print('Saving $key = $value');
    await mainBox.put(key, value);
    print(mainBox.toMap());
  }

  Future<void> saveItemToCloud(String key, dynamic value) async {
    //TODO add logic on failed update
    print('save to cloud key = $key, value = $value');


    var docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('devices')
        .doc(deviceId);

    print('Ref = $docRef');
    return docRef.update({key: value});
  }

  String getValueFromBox(String s) {
    return mainBox.get(s).toString();
  }

  Uint8List settingsToByteArray() {
    //  print(settingsObject.toJson());
    //  print(settingsObject.feedTriggers.first.dateTime.millisecondsSinceEpoch);
    var settingsObject = getSettingsObjectFromCache();
    var converter = ByteArrayBuilder();

    converter.setSizeOfObject(settingsObject.toJson());
    converter.addData(settingsObject.ledColor);
    converter.addData(settingsObject.ledOn);
    converter.addData(settingsObject.maxWaterHeight);
    converter.addData(settingsObject.minWaterHeight);
    converter.addData(settingsObject.powerOutletOneOn);
    converter.addData(settingsObject.powerOutletTwoOn);
    converter.addData(settingsObject.waterHeaterType);
    converter.addData(settingsObject.waterMaxPh);
    converter.addData(settingsObject.waterMinPh);
    converter.addData(settingsObject.waterOptimalTemperature);
    converter.addData(settingsObject.waterSensorHeight);
    converter.addData(settingsObject.feedTriggers);
    converter.addData(settingsObject.ledTriggers);
    print(settingsObject.feedTriggers);
    // converter.addData(settingsObject.ledTriggers);

    var l = converter.getDataList();
    print(l);
    return l;
  }


}
