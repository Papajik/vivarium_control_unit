import 'package:vivarium_control_unit/models/camera.dart';

import 'sensorData.dart';

enum Condition { GREEN, YELLOW, RED, UNKNOWN }
enum Type { AQUARIUM, TERRARIUM, UNKNOWN }

class Device {
  final String id;
  final String name;
  final String location;
  final Condition condition;
  final Type type;
  final SensorData sensorValues;
  final String macAddress;
  final Camera camera;

  //final List<SensorValues> sensorValuesHistory;

  Device({
    this.id,
    this.name,
    this.location,
    this.condition,
    this.type,
    this.sensorValues,
    this.macAddress,
    this.camera
  });

  Device.fromJSON(Map<String, dynamic> data)
      : this(
            id: data['info']['id'],
            name: data['info']['name'],
            location: data['info']['location'],
            condition: (data.containsKey('info') &&
                    data['info'].containsKey('condition'))
                ? Condition.values[data['info']['condition']]
                : Condition.UNKNOWN,
            type: (data.containsKey('info') && data['info'].containsKey('type'))
                ? Type.values.firstWhere((e) => e.toString()==data['info']['type'])
                : Type.UNKNOWN,
            sensorValues: SensorData.fromJSON(
                new Map<String, dynamic>.from(data['sensorValues'])),
            macAddress: data['info']['macAddress'],
            camera: Camera.fromJSON(data['camera'])
  );
}


