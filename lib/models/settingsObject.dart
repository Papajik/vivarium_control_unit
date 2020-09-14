//import 'package:vivarium_control_unit/models/additionalInfo.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/peripheral.dart';

class SettingsObject {
  // Peripherals peripherals;

  double waterLevelSensorPosition;
  double waterLevelMax;
  double waterLevelMin;

  List<LedTrigger> ledTriggers;
  int currentLedColor;

  List<Peripheral> peripherals;

  double waterTemperature;
  double maxPh;
  double minPh;

  int time;

  //AdditionalInfo additionalInfo;

  SettingsObject(
      {this.peripherals,
      this.ledTriggers,
      this.time,
      this.currentLedColor,
      this.maxPh,
      this.minPh,
      this.waterLevelMax,
      this.waterLevelMin,
      this.waterLevelSensorPosition,
      this.waterTemperature});

  SettingsObject.fromJson(Map<String, dynamic> data)
      : this(
          peripherals: createListOfPeripherals(data['peripherals']),
          ledTriggers: createListOfTriggers(data['ledTriggers']),
          //additionalInfo: AdditionalInfo.fromJson(data['additionalInfo']);
        );

  Map<String, dynamic> toJson() => {
        // "peripherals": peripheralsToJson(),
      };

  static List<LedTrigger> createListOfTriggers(List data) {
    List<LedTrigger> list = new List();
    for (Map i in data) {
      list.add(LedTrigger.fromJson(Map<String, dynamic>.from(i)));
    }
    print("settingsObject: createListOfTriggers");
    list.forEach((item) {
      print(item.toString());
    });
    return list;
  }

  static List<Peripheral> createListOfPeripherals(List data) {
    List<Peripheral> list = new List();
    for (Map i in data) {
      list.add(Peripheral.fromJson(Map<String, dynamic>.from(i)));
    }
    print("settingsObject: createListOfPeripherals");
    return list;
  }

  SettingsObject.newEmpty()
      : this(peripherals: new List(), ledTriggers: new List());
}
