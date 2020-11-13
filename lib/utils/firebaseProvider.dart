import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/auth.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

Stream<DocumentSnapshot> deviceHistoryStream(String deviceId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('deviceHistories')
      .doc(deviceId)
      .snapshots();
}

Stream<DocumentSnapshot> deviceStream(String deviceId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('devices')
      .doc(deviceId)
      .snapshots();
}

Map<DateTime, double> getHistoryDoubleMap(List history, String sensorKey) {
  var map = <DateTime, double>{};
  for (var value in history) {
    map[(value['updateTime'] as Timestamp).toDate()] =
        value[sensorKey].toDouble();
  }
  return map;
}

dynamic getLastValue(List history, String sensorKey) {
  return history.last[sensorKey];
}

dynamic getNumberOfTriggers(Map<String, dynamic> device, String key) {
  return device['settings'][key].length;
}

dynamic getSettingsValue(Map<String, dynamic> device, String key) {
  return device['settings'][key];
}

dynamic getStateValue(Map<String, dynamic> device, String key) {
  return device['state'][key];
}

String getLastTrigger(Map<String, dynamic> device, String key) {
  var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
  List triggers = device['settings'][key];

  ///sort by time
  triggers.sort((a, b) => (a['time'] as int).compareTo((b['time'] as int)));

  var lastTrigger = triggers.lastWhere((element) => element['time'] < now,
      orElse: () => triggers.last);
  return getTimeStringFromTime(lastTrigger['time']);
}

String getNextTriggerTime(Map<String, dynamic> device, String triggerName) {
  var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
  List triggers = device['settings'][triggerName];
  triggers.sort((a, b) => (a['time'] as int).compareTo((b['time'] as int)));
  var firstTrigger = triggers.firstWhere((element) => element['time'] > now,
      orElse: () => triggers.first);
  return getTimeStringFromTime(firstTrigger['time']);
}

dynamic getNextTriggerValue(
    Map<String, dynamic> device, String triggerName, String key) {
  var now = getTime(TimeOfDay.now().hour, TimeOfDay.now().minute);
  List triggers = device['settings'][triggerName];
  triggers.sort((a, b) => (a['time'] as int).compareTo((b['time'] as int)));
  var firstTrigger = triggers.firstWhere((element) => element['time'] > now,
      orElse: () => triggers.elementAt(0));
  return firstTrigger[key];
}

void sendClaimLocationQuery({String locationId, String macAddress, String name}) {
  locationId = locationId.replaceAll('\n', '');
  locationId = locationId.replaceAll('\r', '');

  FirebaseFirestore.instance
      .collection('locations')
      .doc(locationId)
      .set({'user': userId});

  FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('locations')
      .doc(locationId)
      .set(_generateLocation(name: name, macAddress: macAddress));
}

Map<String, dynamic> _generateLocation({String name, String macAddress}) => {
      'active': true,
      'condition': 0,
      'deviceCount': 0,
      'lastUpdate': Timestamp.now(),
      'macAddress': macAddress,
      'name': name
    };
