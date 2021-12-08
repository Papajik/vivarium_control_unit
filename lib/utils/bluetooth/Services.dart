
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:vivarium_control_unit/models/device/modules/modules.dart';


class CredentialService {
  final Uuid SERVICE_UUID = Uuid.parse('E553C32A-64A0-11EB-AE93-0242AC130002');

  final Uuid BLE_NAME = Uuid.parse('56600001-BE5D-4370-877B-C4A2ACE639E8');

  final Uuid WIFI_PASS = Uuid.parse('56600002-BE5D-4370-877B-C4A2ACE639E8');
  final Uuid WIFI_SSID = Uuid.parse('56600003-BE5D-4370-877B-C4A2ACE639E8');

  final Uuid USER_ID = Uuid.parse('56600004-BE5D-4370-877B-C4A2ACE639E8');
  final Uuid DEVICE_ID = Uuid.parse('56600005-BE5D-4370-877B-C4A2ACE639E8');
  final Uuid IS_CLAIMED = Uuid.parse('56600006-BE5D-4370-877B-C4A2ACE639E8');


  QualifiedCharacteristic getCharacteristic(String deviceId, Uuid uuid) =>
      QualifiedCharacteristic(
          characteristicId: uuid, serviceId: SERVICE_UUID, deviceId: deviceId);
}

class SettingsService {
  final Uuid SERVICE_UUID = Uuid.parse('2B1CBE3F-1A9F-460C-8040-8240590EDB4A');

  /// Dht

  final Uuid DHT_MAX_T = Uuid.parse('B2E00903-DEF9-49B8-AEF3-F24CF0147960');
  final Uuid DHT_MIN_T = Uuid.parse('B2E00904-DEF9-49B8-AEF3-F24CF0147960');
  final Uuid DHT_MAX_H = Uuid.parse('B2E00905-DEF9-49B8-AEF3-F24CF0147960');
  final Uuid DHT_MIN_H = Uuid.parse('B2E00906-DEF9-49B8-AEF3-F24CF0147960');

  /// Fan

  final Uuid FAN_START_AT = Uuid.parse('1F100801-EF20-47D2-8A82-26B96D35E25D');
  final Uuid FAN_MAX_AT = Uuid.parse('1F100802-EF20-47D2-8A82-26B96D35E25D');

  /// Feeder

  final Uuid FEEDER_MODE = Uuid.parse('88A00701-EEDD-4C73-B88F-1E2538B73E95');
  final Uuid FEEDER_ID = Uuid.parse('88A00702-EEDD-4C73-B88F-1E2538B73E95');
  final Uuid FEEDER_TIME = Uuid.parse('88A00703-EEDD-4C73-B88F-1E2538B73E95');
  final Uuid FEEDER_COMMAND = Uuid.parse('88A00704-EEDD-4C73-B88F-1E2538B73E95');

  /// Heater
  final Uuid HEATER_GOAL = Uuid.parse('4BF00501-64C2-4D4F-BF83-5BE82815957F');
  final Uuid HEATER_MODE = Uuid.parse('4BF00502-64C2-4D4F-BF83-5BE82815957F');
  /// Humidifier
  final Uuid HUM_GOAL = Uuid.parse('F1600601-627D-4199-B407-662D33FD77F7');
  /// Led
  final Uuid LED_ID = Uuid.parse('1F100401-EF20-47D2-8A82-26B96D35E25D');
  final Uuid LED_TIME = Uuid.parse('1F100402-EF20-47D2-8A82-26B96D35E25D');
  final Uuid LED_COLOR = Uuid.parse('1F100404-EF20-47D2-8A82-26B96D35E25D');
  final Uuid LED_COMMAND = Uuid.parse('1F100405-EF20-47D2-8A82-26B96D35E25D');
  /// pH Module

  final Uuid PH_MAX = Uuid.parse('50A00101-4E12-11EB-AE93-0242AC130002');
  final Uuid PH_MIN = Uuid.parse('50A00102-4E12-11EB-AE93-0242AC130002');
  final Uuid PH_CONTINUOUS = Uuid.parse('50A00104-4E12-11EB-AE93-0242AC130002');
  final Uuid PH_CONTINUOUS_DELAY = Uuid.parse('50A00105-4E12-11EB-AE93-0242AC130002');

  /// Water Level
  final Uuid WL_MAX_LEVEL = Uuid.parse('1F100301-EF20-47D2-8A82-26B96D35E25D');
  final Uuid WL_MIN_LEVEL = Uuid.parse('1F100302-EF20-47D2-8A82-26B96D35E25D');
  final Uuid WL_SENSOR_HEIGHT = Uuid.parse('1F100303-EF20-47D2-8A82-26B96D35E25D');
  /// Water Pump
  final Uuid W_PUMP_LEVEL_GOAL = Uuid.parse('15201001-1AA7-4676-81D1-63F66F402A9C');
  /// Water Temp

  final Uuid W_TEMP_MAX = Uuid.parse('76B00201-715E-11EB-9439-0242AC130002');
  final Uuid W_TEMP_MIN = Uuid.parse('76B00202-715E-11EB-9439-0242AC130002');

  QualifiedCharacteristic getCharacteristic(String deviceId, Uuid uuid) =>
      QualifiedCharacteristic(
          characteristicId: uuid, serviceId: SERVICE_UUID, deviceId: deviceId);



}

class StateService {
  final Uuid SERVICE_UUID = Uuid.parse('24A54BE9-44C0-43AB-BF07-5F4D7AF751D0');

  /// Outlets

  final Uuid OUTLET_0_ON = Uuid.parse('E7D01100-5513-48D9-8558-8B657B49B801');
  final Uuid OUTLET_1_ON = Uuid.parse('E7D01101-5513-48D9-8558-8B657B49B801');
  final Uuid OUTLET_2_ON = Uuid.parse('E7D01102-5513-48D9-8558-8B657B49B801');
  final Uuid OUTLET_3_ON = Uuid.parse('E7D01103-5513-48D9-8558-8B657B49B801');


  /// Dht
  final Uuid DHT_CONNECTED = Uuid.parse('B2E00900-DEF9-49B8-AEF3-F24CF0147960');
  final Uuid DHT_CURR_HUMIDITY = Uuid.parse('B2E00901-DEF9-49B8-AEF3-F24CF0147960');
  final Uuid DHT_CURR_TEMP = Uuid.parse('B2E00902-DEF9-49B8-AEF3-F24CF0147960');
  /// Fan

  final Uuid FAN_CONNECTED = Uuid.parse('1F100800-EF20-47D2-8A82-26B96D35E25D');
  final Uuid FAN_CURR_SPEED = Uuid.parse('1F100803-EF20-47D2-8A82-26B96D35E25D');


  /// Feeder
  final Uuid FEEDER_CONNECTED = Uuid.parse('88A00700-EEDD-4C73-B88F-1E2538B73E95');


  /// Heater
  final Uuid HEATER_CONNECTED = Uuid.parse('4BF00500-64C2-4D4F-BF83-5BE82815957F');
  final Uuid HEATER_CURR_POWER = Uuid.parse('4BF00503-64C2-4D4F-BF83-5BE82815957F');
  /// Humidifier
  final Uuid HUMIDIFIER_IS_ON = Uuid.parse('F1600602-627D-4199-B407-662D33FD77F7');
  final Uuid HUMIDIFIER_CONNECTED = Uuid.parse('F1600600-627D-4199-B407-662D33FD77F7');

  /// Led
  final Uuid LED_CONNECTED = Uuid.parse('1F100400-EF20-47D2-8A82-26B96D35E25D');
  final Uuid LED_CURRENT_COLOR = Uuid.parse('1F100403-EF20-47D2-8A82-26B96D35E25D');
  /// pH Module

  final Uuid PH_MODULE_CONNECTED =
      Uuid.parse('50A00100-4E12-11EB-AE93-0242AC130002');
  final Uuid PH_CUR = Uuid.parse('50A00103-4E12-11EB-AE93-0242AC130002');

  QualifiedCharacteristic getCharacteristic(String deviceId, Uuid uuid) =>
      QualifiedCharacteristic(
          characteristicId: uuid, serviceId: SERVICE_UUID, deviceId: deviceId);

  /// Water Level
  final Uuid WL_CONNECTED = Uuid.parse('1F100300-EF20-47D2-8A82-26B96D35E25D');
  final Uuid WL_CURRENT_LEVEL = Uuid.parse('1F100304-EF20-47D2-8A82-26B96D35E25D');
  /// Water Pum
  final Uuid W_PUMP_IS_ON = Uuid.parse('15201002-1AA7-4676-81D1-63F66F402A9C');
  final Uuid W_PUMP_CONNECTED = Uuid.parse('15201000-1AA7-4676-81D1-63F66F402A9C');
  /// Water Temp
  final Uuid W_TEMP_CONNECTED = Uuid.parse('76B00200-715E-11EB-9439-0242AC130002');
  final Uuid W_TEMP_CURR_TEMP = Uuid.parse('76B00205-715E-11EB-9439-0242AC130002');


  List<VivariumModule> getModules(List<Uuid> characteristics) {
    var modules = <VivariumModule>[];
    for (var c in characteristics) {
      if (c == PH_MODULE_CONNECTED) modules.add(VivariumModule.PH);
      if (c == DHT_CONNECTED) modules.add(VivariumModule.DHT);
      if (c == FAN_CONNECTED) modules.add(VivariumModule.FAN);
      if (c == FEEDER_CONNECTED) modules.add(VivariumModule.FEEDER);
      if (c == HEATER_CONNECTED) modules.add(VivariumModule.HEATER);
      if (c == HUMIDIFIER_CONNECTED) modules.add(VivariumModule.HUMIDIFIER);
      if (c == LED_CONNECTED) modules.add(VivariumModule.LED);
      if (c == WL_CONNECTED) modules.add(VivariumModule.WL);
      if (c == W_PUMP_CONNECTED) modules.add(VivariumModule.PUMP);
      if (c == W_TEMP_CONNECTED) modules.add(VivariumModule.WT);
      if (c == OUTLET_0_ON) modules.add(VivariumModule.O0);
      if (c == OUTLET_1_ON) modules.add(VivariumModule.O1);
      if (c == OUTLET_2_ON) modules.add(VivariumModule.O2);
      if (c == OUTLET_3_ON) modules.add(VivariumModule.O3);
    }
    return modules;
  }

}
