import 'package:flutter/foundation.dart';
import 'package:vivarium_control_unit/models/camera.dart';

import 'sensorData.dart';

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

class Device {
  final String id;
  final String name;
  final String location;
  final int condition;
  final int type;
  final SensorData sensorValues;
  final String macAddress;
  final Camera camera;

  //final List<SensorValues> sensorValuesHistory;

  Device(
      {this.id,
      this.name,
      this.location,
      this.condition,
      this.type,
      this.sensorValues,
      this.macAddress,
      this.camera});

  Device.fromJSON(Map<String, dynamic> data)
      : this(
            id: data['info']['id'],
            name: data['info']['name'],
            location: data['info']['location'],
            condition: data['info']['condition'],
            type: data['info']['type'],
            sensorValues: SensorData.fromJSON(
                new Map<String, dynamic>.from(data['sensorValues'])),
            macAddress: data['info']['macAddress'],
            camera: Camera.fromJSON(data['camera']));

  Map<String, dynamic> toJson() => {
        'info': {
          'id': id,
          'name': name,
          'location': location,
          'condition': condition,
          'type': type,
          'macAddress': macAddress
        },
        'sensorValues': sensorValues.toJson(),
        'camera': camera.toJson()
      };
}
