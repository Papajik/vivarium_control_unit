import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class AdvancedSettingsPageArguments {
  final BluetoothConnector bluetoothConnector;
  final DeviceProvider deviceProvider;
  final Device device;

  AdvancedSettingsPageArguments(
      {required this.device, required this.bluetoothConnector, required this.deviceProvider});
}
