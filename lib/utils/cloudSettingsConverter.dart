import 'dart:async';
import 'dart:typed_data';

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
const String LED_TRIGGERS = "settings.ledTriggers";
const String LED_COLOR = "settings.ledColor";
const String LED_ON = "settings.ledOn";
const String WATER_OPTIMAL_TEMPERATURE = "settings.waterOptimalTemperature";
const String WATER_HEATER_TYPE = "settings.waterHeaterType";
const String WATER_MAX_PH = "settings.waterMaxPh";
const String WATER_MIN_PH = "settings.waterMinPh";
const String POWER_OUTLET_ONE_ON = "settings.powerOutletOneIsOn";
const String POWER_OUTLET_TWO_ON = "settings.powerOutletTwoIsOn";


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
    print(settingsObject.waterHeaterType);
    await mainBox.clear();
    await mainBox.put(deviceId + WATER_LEVEL_SENSOR_HEIGHT, settingsObject.waterSensorHeight);
    await mainBox.put(deviceId + WATER_LEVEL_MIN_HEIGHT, settingsObject.minWaterHeight);
    await mainBox.put(deviceId + WATER_LEVEL_MAX_HEIGHT, settingsObject.maxWaterHeight);
    await mainBox.put(deviceId + WATER_HEATER_TYPE, settingsObject.waterHeaterType);
    await mainBox.put(deviceId + WATER_OPTIMAL_TEMPERATURE, settingsObject.waterOptimalTemperature);
    await mainBox.put(deviceId + LED_ON, settingsObject.ledOn);
    await mainBox.put(deviceId + LED_COLOR, settingsObject.ledColor);
    await mainBox.put(deviceId + POWER_OUTLET_ONE_ON, settingsObject.powerOutletOneIsOn);
    await mainBox.put(deviceId + POWER_OUTLET_TWO_ON, settingsObject.powerOutletTwoIsOn);
    await mainBox.put(deviceId + WATER_MAX_PH, settingsObject.waterMaxPh);
    await mainBox.put(deviceId + WATER_MIN_PH, settingsObject.waterMinPh);

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
  }

  List<FeedTrigger> getFeedTriggers(){
    Box<FeedTrigger> feedTriggers =
    Hive.box(HiveBoxes.feedTriggerList + deviceId);
    return feedTriggers.values.toList();
  }

  saveItemToCloud(String key, dynamic value) async{//TODO add logic on failed update
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
    return mainBox.get(s).toString();
  }

  Uint8List settingsToByteArray() {
    return Uint8List.fromList([1,2]);
  }


}
