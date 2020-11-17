import 'package:vivarium_control_unit/models/device/deviceCamera.dart';
import 'package:vivarium_control_unit/models/device/deviceInfo.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';

import 'deviceSensorData.dart';

class Device {
  Camera camera;
  DeviceInfo info;
  SensorData sensorData;
  DeviceSettings settings;
  DeviceState state;

  Device({this.camera, this.info, this.sensorData, this.settings, this.state});

  factory Device.fromJson(Map<String, dynamic> data) {
    return Device(
        info: DeviceInfo.fromJSON(data['info']),
        settings: DeviceSettings.fromJson(data['settings']),
        state: DeviceState.fromJson(data['state']),
        sensorData: SensorData.fromJSON(
            Map<String, dynamic>.from(data['sensorData'])),
        camera: Camera.fromJSON(data['camera']));
  }

  Map<String, dynamic> toJson() =>
      {
        'info': info.toJson(),
        'state': state.toJson(),
        'settings': settings.toJson(),
       'sensorData': sensorData.toJson(),
        'camera': camera.toJson()
      };

  @override
  String toString() {
    return 'Device{camera: $camera, info: $info, sensorData: $sensorData, settings: $settings, state: $state}';
  }
}
