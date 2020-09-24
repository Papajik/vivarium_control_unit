import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/waterHeaterType.dart';

//TODO use https://pub.dev/packages/flamingo

enum SettingsObjectKey {
  ledOn,
  ledColor,
  maxWaterHeight,
  minWaterHeight,
  powerOutletOneIsOn,
  powerOutletTwoIsOn,
  waterHeaterType,
  waterMinPh,
  waterMaxPh,
  waterOptimalTemperature,
  waterSensorHeight,
  feedTriggers,
  ledTriggers,
}




class SettingsObject  {
  ///water level

  int waterSensorHeight;
  int maxWaterHeight;
  int minWaterHeight;

  ///Lists

  List<LedTrigger> ledTriggers;
  List<FeedTrigger> feedTriggers;

  /// LED COLOR

  int ledColor;
  bool ledOn;

  ///Water temperature

  double waterOptimalTemperature;
  int waterHeaterType;

  ///PH
  double waterMaxPh;
  double waterMinPh;

  ///Outlets
  bool powerOutletOneIsOn;
  bool powerOutletTwoIsOn;



  SettingsObject(
      {this.feedTriggers,
      this.ledTriggers,
      this.waterHeaterType,
      this.ledColor,
      this.ledOn,
      this.maxWaterHeight,
      this.minWaterHeight,
      this.waterOptimalTemperature,
      this.waterSensorHeight,
      this.powerOutletOneIsOn,
      this.powerOutletTwoIsOn,
      this.waterMaxPh,
      this.waterMinPh});

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
          waterSensorHeight: data['waterSensorHeight'] as int,
          //waterHeaterType: HeaterType.values.firstWhere((e) => e.toString() == data['waterHeaterType']),
          waterHeaterType: data['waterHeaterType'] as int,
          ledColor: data['ledColor'] as int,
          ledOn: data['ledOn'] as bool,
          waterOptimalTemperature: data['waterOptimalTemperature'] as double,
          powerOutletOneIsOn: data['powerOutletOneIsOn'] as bool,
          powerOutletTwoIsOn: data['powerOutletTwoIsOn'] as bool,
          waterMaxPh: data['waterMaxPh'] as double,
          waterMinPh: data['waterMinPh'] as double,
        );

  Map<String, dynamic> toJson() => {
    'ledOn':ledOn,
    'ledColor':ledColor,
    'maxWaterHeight':maxWaterHeight,
    'minWaterHeight':minWaterHeight,
    'powerOutletOneIsOn':powerOutletOneIsOn,
    'powerOutletTwoIsOn':powerOutletTwoIsOn,
    'waterHeaterType':waterHeaterType,
    'waterMinPh':waterMinPh,
    'waterMaxPh':waterMaxPh,
    'waterOptimalTemperature':waterOptimalTemperature,
    'waterSensorHeight':waterSensorHeight,
    'feedTriggers':feedTriggers.map((e) => e.toJson()),
    'ledTriggers':ledTriggers.map((e) => e.toJson()),
      };

  SettingsObject.newEmpty()
      : this(feedTriggers: new List(), ledTriggers: new List());
}
