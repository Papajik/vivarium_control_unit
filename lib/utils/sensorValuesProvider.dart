import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

String deviceId;
String userId;

Stream<DocumentSnapshot> deviceHistoryStream() {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("deviceHistories")
      .doc(deviceId)
      .snapshots();
}

Stream<DocumentSnapshot> deviceStream() {
  return FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .collection("devices")
      .doc(deviceId)
      .snapshots();
}

getHistoryDoubleMap(List history, String sensorKey) {
  Map<DateTime, double> map = new Map();
  for (var value in history) {
    map[(value["updateTime"] as Timestamp).toDate()] =
        value[sensorKey].toDouble();
  }
  return map;
}

getLastValue(List history, String sensorKey) {
  return history.last[sensorKey];
}

getNumberOfTriggers(Map<String, dynamic> device, String key) {
  return device['settings'][key].length;
}

getSettingsValue(Map<String, dynamic> device, String key){
  return device['settings'][key];
}

getStateValue(Map<String, dynamic> device, String key){
  return device['state'][key];
}

getLastTrigger(Map<String, dynamic> device, String key) {
  int now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
  List triggers = device['settings'][key];

  ///sort by time
  triggers.sort((a, b) => (a['time'] as int).compareTo((b['time'] as int)));

  var lastTrigger = triggers.lastWhere((element) => element['time'] < now,
      orElse: () => triggers.last);
  return getTimeStringFromTime(lastTrigger['time']);
}

getNextTriggerTime(Map<String, dynamic> device, String triggerName) {
  int now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
  List triggers = device['settings'][triggerName];
  triggers.sort((a, b) => (a['time'] as int).compareTo((b['time'] as int)));
  var firstTrigger = triggers.firstWhere((element) => element['time'] > now,
      orElse: () => triggers.first);
  return getTimeStringFromTime(firstTrigger['time']);
}

getNextTriggerValue(Map<String, dynamic> device, String triggerName, String key) {
int now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
List triggers = device['settings'][triggerName];
triggers.sort((a, b) => (a['time'] as int).compareTo((b['time'] as int)));
var firstTrigger = triggers.firstWhere((element) => element['time'] > now,
orElse: () => triggers.elementAt(0));
return firstTrigger[key];
}


