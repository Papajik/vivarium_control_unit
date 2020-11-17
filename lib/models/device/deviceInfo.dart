import 'package:flutter/foundation.dart';

enum Condition { GREEN, YELLOW, RED, UNKNOWN }
enum Type { AQUARIUM, TERRARIUM, UNKNOWN }

extension ConditionExtension on Condition {
  String get name => describeEnum(this);
}

extension TypeExtension on Type {
  String get name => describeEnum(this);
}

Condition getConditionFromIndex(int index) => Condition.values[index];

Type getTypeFromIndex(index) => Type.values[index];

class DeviceInfo {
  bool active;
  Condition condition;
  String id;
  String location;
  String macAddress;
  String name;
  Type type;

  DeviceInfo(
      {this.active,
      this.condition,
      this.id,
      this.location,
      this.macAddress,
      this.name,
      this.type});

  DeviceInfo.fromJSON(Map<String, dynamic> data)
      : this(
            active: data['active'] as bool,
            condition: Condition.values.elementAt(data['condition'] as int),
            id: data['id'],
            location: data['location'],
            macAddress: data['macAddress'],
            name: data['name'],
            type: Type.values.elementAt(data['type'] as int));

  Map<String, dynamic> toJson() => {
        'active': active,
        'condition': condition.index,
        'id': id,
        'macAddress': macAddress,
        'name': name,
        'type': type.index
      };

  @override
  String toString() {
    return 'DeviceInfo{active: $active, condition: $condition, id: $id, location: $location, macAddress: $macAddress, name: $name, type: $type}';
  }
}
