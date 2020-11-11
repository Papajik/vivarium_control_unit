import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/outletTrigger.dart';
import 'package:vivarium_control_unit/models/settingsObject.dart';
import 'package:vivarium_control_unit/models/waterHeaterType.dart';
import 'package:vivarium_control_unit/utils/byteArrayBuilder.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

const String WATER_LEVEL_SENSOR_HEIGHT = "settings.waterSensorHeight";
const String WATER_LEVEL_MAX_HEIGHT = "settings.maxWaterHeight";
const String WATER_LEVEL_MIN_HEIGHT = "settings.minWaterHeight";
const String FEED_TRIGGERS = "settings.feedTriggers";
const String LED_TRIGGERS = "settings.ledTriggers";
const String LED_COLOR = "settings.ledColor";
const String LED_ON = "settings.ledOn";
const String WATER_OPTIMAL_TEMPERATURE = "settings.waterOptimalTemperature";
const String WATER_HEATER_TYPE = "settings.waterHeaterType";
const String WATER_MAX_PH = "settings.waterMaxPh";
const String WATER_MIN_PH = "settings.waterMinPh";
const String POWER_OUTLET_ONE_ON = "settings.powerOutletOneIsOn";
const String POWER_OUTLET_ONE_TRIGGERS = "settings.powerOutletOneTriggers";
const String POWER_OUTLET_TWO_TRIGGERS = "settings.powerOutletTwoTriggers";
const String POWER_OUTLET_TWO_ON = "settings.powerOutletTwoIsOn";

class SettingsConverter {
  final String deviceId;
  final String userId;
  SettingsObject settingsObject;
  Box mainBox = Hive.box(HiveBoxes.mainBox);
  Box<FeedTrigger> feedTriggersBox;
  Box<LedTrigger> ledTriggersBox;
  Box<OutletTrigger> outletOneTriggersBox;
  Box<OutletTrigger> outletTwoTriggersBox;

  SettingsConverter({this.deviceId, this.userId}) {
    print("SettingsConverter - constructor");
    feedTriggersBox =
        Hive.box<FeedTrigger>(HiveBoxes.feedTriggerList + deviceId);
    ledTriggersBox = Hive.box<LedTrigger>(HiveBoxes.ledTriggerList + deviceId);
    outletOneTriggersBox =
        Hive.box<OutletTrigger>(HiveBoxes.outletOneTriggerList + deviceId);
    outletTwoTriggersBox =
        Hive.box<OutletTrigger>(HiveBoxes.outletTwoTriggerList + deviceId);
  }

  Future<bool> loadSettingsFromCloud() async {
    print("Loading from cloud");
    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("devices")
        .doc(deviceId);
    var data = await docRef.get();
    var settings = data.data()["settings"];
//      print(settings);
    settingsObject =
        SettingsObject.fromJson(Map<String, dynamic>.from(settings));
     print("object created");
//     print(settingsObject.ledTriggers);
    await updateCache();
     print("cache updated");
    return true;
  }

  SettingsObject getSettingsObjectFromCache() {
    return SettingsObject(
      ledTriggers: ledTriggersBox.values.toList(),
      feedTriggers: feedTriggersBox.values.toList(),
      ledColor: mainBox.get(deviceId + LED_COLOR),
      ledOn: mainBox.get(deviceId + LED_ON),
      maxWaterHeight: mainBox.get(deviceId + WATER_LEVEL_MAX_HEIGHT),
      minWaterHeight: mainBox.get(deviceId + WATER_LEVEL_MIN_HEIGHT),
      powerOutletOneIsOn: mainBox.get(deviceId + POWER_OUTLET_ONE_ON),
      powerOutletTwoIsOn: mainBox.get(deviceId + POWER_OUTLET_TWO_ON),
      waterHeaterType:
          getHeaterTypeByName(mainBox.get(deviceId + WATER_HEATER_TYPE)),
      waterMaxPh: mainBox.get(deviceId + WATER_MAX_PH),
      waterMinPh: mainBox.get(deviceId + WATER_MIN_PH),
      waterOptimalTemperature:
          mainBox.get(deviceId + WATER_OPTIMAL_TEMPERATURE),
      waterSensorHeight: mainBox.get(deviceId + WATER_LEVEL_SENSOR_HEIGHT),
    );
  }

  updateCache() async {
    // print("settings converter - update cache");
//    print("update cache");
    await updateFeedTriggers();
//    print("updateFeedTriggers updated");
    await updateLedTriggers();
//    print("updateLedTriggers updated");
    await updateOutletOneTriggers();
    await updateOutletTwoTriggers();
    await updateMainBox();
//    print("updateMainBox updated");
    return;
  }

  updateLedTriggers() async {
    await ledTriggersBox.clear();
    await ledTriggersBox.addAll(settingsObject.ledTriggers);
    return true;
  }
  updateOutletOneTriggers() async {
    print("updateOutletOneTriggers");
    await outletOneTriggersBox.clear();
    await outletOneTriggersBox.addAll(settingsObject.powerOutletOneTriggers);
    return true;
  }
  updateOutletTwoTriggers() async {
    await outletTwoTriggersBox.clear();
    await outletTwoTriggersBox.addAll(settingsObject.powerOutletTwoTriggers);
    return true;
  }

  updateFeedTriggers() async {
//    print("Update feed triggers inside");
//    print(feedTriggersBox.values);
    await feedTriggersBox.clear();
    await feedTriggersBox.addAll(settingsObject.feedTriggers);
    return true;
  }

  updateMainBox() async {
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
        deviceId + POWER_OUTLET_ONE_ON, settingsObject.powerOutletOneIsOn);
    await mainBox.put(
        deviceId + POWER_OUTLET_TWO_ON, settingsObject.powerOutletTwoIsOn);
    await mainBox.put(deviceId + WATER_MAX_PH, settingsObject.waterMaxPh);
    await mainBox.put(deviceId + WATER_MIN_PH, settingsObject.waterMinPh);

    //  print("after:");
    //  print(mainBox.values);

    return true;
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

  saveItem(String key, dynamic value) async {
    await saveItemToCloud(key, value);
    await saveToCache(deviceId + key, value);
  }

  saveToCache(String key, dynamic value) async {
    print("Saving $key = $value");
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
    return docRef.update({key: value});
  }

  String getValueFromBox(String s) {
    return mainBox.get(s).toString();
  }

  Uint8List settingsToByteArray() {
    //  print(settingsObject.toJson());
    //  print(settingsObject.feedTriggers.first.dateTime.millisecondsSinceEpoch);
    SettingsObject settingsObject = getSettingsObjectFromCache();
    ByteArrayBuilder converter = ByteArrayBuilder();

    converter.setSizeOfObject(settingsObject.toJson());
    converter.addData(settingsObject.ledColor);
    converter.addData(settingsObject.ledOn);
    converter.addData(settingsObject.maxWaterHeight);
    converter.addData(settingsObject.minWaterHeight);
    converter.addData(settingsObject.powerOutletOneIsOn);
    converter.addData(settingsObject.powerOutletTwoIsOn);
    converter.addData(settingsObject.waterHeaterType);
    converter.addData(settingsObject.waterMaxPh);
    converter.addData(settingsObject.waterMinPh);
    converter.addData(settingsObject.waterOptimalTemperature);
    converter.addData(settingsObject.waterSensorHeight);
    converter.addData(settingsObject.feedTriggers);
    converter.addData(settingsObject.ledTriggers);
    print(settingsObject.feedTriggers);
    // converter.addData(settingsObject.ledTriggers);

    Uint8List l = converter.getDataList();
    print(l);
    return l;
  }
}
