//import 'package:vivarium_control_unit/models/additionalInfo.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/peripheral.dart';

//TODO use https://pub.dev/packages/flamingo
//https://github.com/icemanbsi/flutter_time_picker_spinner
//https://pub.dev/packages/flutter_time_picker_spinner
class SettingsObject {
  // Peripherals peripherals;

  int waterSensorHeight;
  int maxWaterHeight;
  int minWaterHeight;

  List<LedTrigger> ledTriggers;
  List<FeedTrigger> feedTriggers;
  int currentLedColor;

  //List<Peripheral> peripherals;

  double waterTemperature;
  double maxPh;
  double minPh;

  int time;

  //AdditionalInfo additionalInfo;

  SettingsObject(
      {
      //this.peripherals,
      this.ledTriggers,
      this.time,
      this.currentLedColor,
      this.maxPh,
      this.minPh,
      this.maxWaterHeight,
      this.minWaterHeight,
      this.waterSensorHeight,
      this.waterTemperature,
      this.feedTriggers});

  SettingsObject.fromJson(Map<String, dynamic> data)
      : this(
            ledTriggers: (data['ledTriggers'] as List)
                .map((e) => LedTrigger.fromJson(e))
                .toList(),
            feedTriggers: (data['feedTriggers'] as List)
                .map((e) => FeedTrigger.fromJson(e))
                .toList(),
            maxWaterHeight: data['maxWaterHeight'] as int,
            minWaterHeight: data['minWaterHeight'] as int,
            waterSensorHeight: data['waterSensorHeight'] as int);

  //"feedTriggers": feedTriggers,
  //"ledTriggers":ledTriggers,
  Map<String, dynamic> toJson() => {
        'maxWaterHeight': maxWaterHeight,
        'minWaterHeight': minWaterHeight,
        'waterSensorHeight': waterSensorHeight
      };

  static List<Peripheral> createListOfPeripherals(List data) {
    List<Peripheral> list = new List();
    for (Map i in data) {
      list.add(Peripheral.fromJson(Map<String, dynamic>.from(i)));
    }
    print("settingsObject: createListOfPeripherals");
    return list;
  }

  SettingsObject.newEmpty()
      : this(feedTriggers: new List(), ledTriggers: new List());
}
