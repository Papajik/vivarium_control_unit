import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/settingsObject.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

const String WATER_LEVEL_SENSOR_HEIGHT = "settings.waterSensorHeight";
const String WATER_LEVEL_MAX_HEIGHT = "settings.maxWaterHeight";
const String WATER_LEVEL_MIN_HEIGHT = "settings.minWaterHeight";
const String FEED_TRIGGERS = "settings.feedTriggers";
const String LED_CURRENT_COLOR = "-led-current-color";
const String LED_IS_ON = "-led-is-on";

class SettingsConverter {
  final String deviceId;
  final String userId;

  SettingsConverter({this.deviceId, this.userId});

  Future<bool> loadSettingsFromCloud() async {
    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("devices")
        .doc(deviceId);
    var data = await docRef.get();
    var settings = data.data()["settings"];
    print(settings);
    SettingsObject settingsObject =
        SettingsObject.fromJson(Map<String, dynamic>.from(settings));
    print("object created");
    print(settingsObject.feedTriggers);
    print(settingsObject.ledTriggers);
    await updateCache(settingsObject);
    return true;
  }

  updateCache(SettingsObject settingsObject) async {
    print("settings converter - update cache");
    await updateFeedTriggers(settingsObject);
    await updateLedTriggers(settingsObject);
    await updateMainBox(settingsObject);
    return;
  }

  updateLedTriggers(SettingsObject settingsObject) async{
    Box<LedTrigger> ledTriggersBox =
    Hive.box<LedTrigger>(HiveBoxes.ledTriggerList + deviceId);
    await ledTriggersBox.clear();
    await ledTriggersBox.addAll(settingsObject.ledTriggers);
    return true;
  }

  updateFeedTriggers(SettingsObject settingsObject) async{
    Box<FeedTrigger> feedTriggersBox =
    Hive.box<FeedTrigger>(HiveBoxes.feedTriggerList + deviceId);

    await feedTriggersBox.clear();
    await feedTriggersBox.addAll(settingsObject.feedTriggers);
    return true;
  }

  updateMainBox(SettingsObject settingsObject) async{
    Box mainBox = Hive.box(HiveBoxes.mainBox);
    print("previous");
    print(mainBox.values);
    print(settingsObject.waterSensorHeight);
    await mainBox.clear();
    await mainBox.put(deviceId + WATER_LEVEL_SENSOR_HEIGHT, settingsObject.waterSensorHeight);
    await mainBox.put(deviceId + WATER_LEVEL_MIN_HEIGHT, settingsObject.minWaterHeight);
    await mainBox.put(deviceId + WATER_LEVEL_MAX_HEIGHT, settingsObject.maxWaterHeight);
    print("after:");
    print(mainBox.values);

    return true;
  }


  saveSettingsToCloud() async {
    print("upload");
    print(Hive.toString());
    Box<LedTrigger> ledTriggers = Hive.box(HiveBoxes.ledTriggerList + deviceId);
    Box<FeedTrigger> feedTriggers =
        Hive.box(HiveBoxes.feedTriggerList + deviceId);
    Box mainBox = Hive.box(HiveBoxes.mainBox);

    SettingsObject object = SettingsObject.newEmpty();
    object.ledTriggers = ledTriggers.values.toList();
    object.feedTriggers = feedTriggers.values.toList();
    object.maxWaterHeight =
        int.parse(mainBox.get(deviceId + WATER_LEVEL_MAX_HEIGHT));
    object.minWaterHeight =
        int.parse(mainBox.get(deviceId + WATER_LEVEL_MIN_HEIGHT));
    object.waterSensorHeight =
        int.parse(mainBox.get(deviceId + WATER_LEVEL_SENSOR_HEIGHT));

    print("upload");
    print(object.toJson());

    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("devices")
        .doc(deviceId);
    List<FeedTrigger> tt = new List<FeedTrigger>();
    tt.add(FeedTrigger(
        type: FeedType.BOX,
        dateTime:
        DateTime(2000, 1, 1, 22, 11)));
    tt.add(FeedTrigger(
        type: FeedType.SCREW,
        dateTime:
        DateTime(2000, 1, 1, 23, 00)));

    return docRef.update(
      {"settings.feedTriggers": tt.map((e) => e.toJson()).toList()}
    );

    return docRef.update({
      "settings": object.toJson()
    });
  }

  List<FeedTrigger> getFeedTriggers(){
    Box<FeedTrigger> feedTriggers =
    Hive.box(HiveBoxes.feedTriggerList + deviceId);
    return feedTriggers.values.toList();
  }

  saveItemToCloud(String key, dynamic value) async{
    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("devices")
        .doc(deviceId);
    return docRef.update({
      key: value
    });
  }

  String getValueFromBox(String s) {
    Box mainBox = Hive.box(HiveBoxes.mainBox);
    print("get value from box:");
    print(s);
    return mainBox.get(s).toString();
  }


}
