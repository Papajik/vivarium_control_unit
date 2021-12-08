import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:vivarium_control_unit/utils/bluetooth/Services.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

CredentialService _credentialService = CredentialService();
SettingsService _settingsService = SettingsService();
StateService _stateService = StateService();

/// Returns correct characteristic for given name
QualifiedCharacteristic? getCharacteristic(
    {required String? key, required String? deviceId}) {
  switch (key) {
    case DEVICE_NAME:
      return _credentialService.getCharacteristic(
          deviceId!, _credentialService.BLE_NAME);
    case PH_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.PH_MODULE_CONNECTED);
    case PH_MAX:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.PH_MAX);
    case PH_MIN:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.PH_MIN);
    case PH_CUR:
      return _stateService.getCharacteristic(deviceId!, _stateService.PH_CUR);
    case PH_CONTINUOUS:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.PH_CONTINUOUS);
    case PH_CONTINUOUS_DELAY:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.PH_CONTINUOUS_DELAY);
    case DHT_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.DHT_CONNECTED);
    case DHT_MAX_HUM:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.DHT_MAX_H);
    case DHT_MIN_HUM:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.DHT_MIN_H);
    case DHT_MAX_TEMP:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.DHT_MAX_T);
    case DHT_MIN_TEMP:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.DHT_MIN_T);
    case WT_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.W_TEMP_CONNECTED);
    case WT_MAX_TEMP:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.W_TEMP_MAX);
    case WT_MIN_TEMP:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.W_TEMP_MIN);
    case WL_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.WL_CONNECTED);
    case WL_MAX_L:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.WL_MAX_LEVEL);
    case WL_MIN_L:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.WL_MIN_LEVEL);
    case WL_SENSOR_HEIGHT:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.WL_SENSOR_HEIGHT);
    case HEATER_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.HEATER_CONNECTED);
    case HEATER_MODE:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.HEATER_MODE);
    case HEATER_GOAL:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.HEATER_GOAL);
    case FAN_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.FAN_CONNECTED);
    case FAN_MAX_AT:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.FAN_MAX_AT);
    case FAN_START_AT:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.FAN_START_AT);
    case FEEDER_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.FEEDER_CONNECTED);
    case FEEDER_MODE:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.FEEDER_MODE);

    case LED_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.LED_CONNECTED);
    case LED_COLOR:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.LED_COLOR);

    case HUM_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.HUMIDIFIER_CONNECTED);
    case HUM_GOAL:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.HUM_GOAL);
    case WP_CONNECTED:
      return _stateService.getCharacteristic(
          deviceId!, _stateService.W_PUMP_CONNECTED);
    case WP_GOAL:
      return _settingsService.getCharacteristic(
          deviceId!, _settingsService.W_PUMP_LEVEL_GOAL);
    default:
      return null;
  }
}
