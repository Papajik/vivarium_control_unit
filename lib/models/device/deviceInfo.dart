import 'package:flutter/foundation.dart';

/// Condition of device. Currently not in use
@deprecated
enum Condition { GREEN, YELLOW, RED, UNKNOWN }

@deprecated
extension ConditionExtension on Condition {
  String get name => describeEnum(this);
}

@deprecated
extension TypeExtension on Type {
  String get name => describeEnum(this);

  String capitalize() {
    return '${name[0].toUpperCase()}${name.substring(1).toLowerCase()}';
  }
}

@deprecated
Condition getConditionFromIndex(int index) => Condition.values[index];

/// Representation of device basic info from Firebase Database
/// Useful for getting more info of the device without pulling all unrelated data
class DeviceInfo {
  bool active;
  Condition condition;
  int lastAlive;
  String id;
  List<String> locations;
  String macAddress;
  String owner;
  String name;
  String firmware;

  DeviceInfo(
      {this.active = true,
      this.lastAlive = 0,
      this.condition = Condition.GREEN,
      required this.id,
      required this.owner,
      this.locations = const [],
      required this.macAddress,
      required this.name,
      this.firmware = '0'});

  factory DeviceInfo.fromJson(Map data) {
    var d = DeviceInfo(
        lastAlive: data['lastAlive'] as int,
        active: data['active'] as bool,
        condition: Condition.values.elementAt(data['condition'] as int),
        id: data['id'],
        macAddress: data['macAddress'],
        name: data['name'],
        firmware: data['firmware'],
        owner: data['owner']);
    return d;
  }

  Map<String, dynamic> toJson() => {
        'lastAlive': lastAlive,
        'active': active,
        'condition': condition.index,
        'id': id,
        'macAddress': macAddress,
        'name': name,
        'locations': locations,
        'owner': owner,
        'firmware': firmware
      };

  @override
  String toString() {
    return '{ active: $active,lastAlive: $lastAlive, condition: $condition, id: $id, locations: $locations, macAddress: $macAddress, name: $name, owner: $owner, firmware: $firmware}';
  }
}
