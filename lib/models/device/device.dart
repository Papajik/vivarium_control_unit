import 'package:vivarium_control_unit/models/device/camera/camera.dart';
import 'package:vivarium_control_unit/models/device/deviceInfo.dart';
import 'package:vivarium_control_unit/models/device/deviceSensorData.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';

class Device {
  Camera camera;
  DeviceInfo info;
  DeviceSensorData sensorData;
  DeviceSettings settings;
  DeviceState state;

  bool get isAlive =>
      info.lastAlive + Duration(minutes: 2).inMilliseconds >
      DateTime.now().millisecondsSinceEpoch / 1000;

  Device copyWith(
          {Camera? camera,
          DeviceInfo? info,
          DeviceSensorData? sensorData,
          DeviceSettings? settings,
          DeviceState? state}) =>
      Device(
          camera: camera ?? this.camera,
          info: info ?? this.info,
          settings: settings ?? this.settings,
          sensorData: sensorData ?? this.sensorData,
          state: state ?? this.state);

  Device(
      {required this.camera,
      required this.info,
      required this.sensorData,
      required this.settings,
      required this.state});

  factory Device.fromJson(Map data) {
    return Device(
        info: DeviceInfo.fromJson(data['info']),
        camera: Camera.fromJson(data['camera']),
        settings: DeviceSettings.fromJson(data['settings']),
        state: DeviceState.fromJson(data['state']),
        sensorData: (data['sensorData']) == null
            ? DeviceSensorData()
            : DeviceSensorData.fromJson(data['sensorData']));
  }

  factory Device.fromModules(
          {required List<VivariumModule> modules,
          required String name,
          required String deviceId,
          required String deviceMac,
          required String userId}) =>
      Device(
          camera: Camera(active: false, updated: DateTime.now()),
          info: DeviceInfo(
              name: name, id: deviceId, macAddress: deviceMac, owner: userId),
          settings: DeviceSettings.fromModules(modules: modules),
          state: DeviceState.fromModules(modules: modules),
          sensorData: DeviceSensorData());

  Map<String, dynamic> toJson() => {
        'info': info.toJson(),
        'state': state.toJson(),
        'settings': settings.toJson(),
        'camera': camera.toJson()
      };

  @override
  String toString() {
    return '{ camera: ${camera}, info: $info,sensorData: $sensorData, settings: $settings, state: ${state} }';
  }
}

class DeviceStreamObject {
  DeviceStreamObject({required this.device, this.hasError = false});

  Device device;
  bool hasError;
}
