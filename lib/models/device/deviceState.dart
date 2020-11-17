import 'package:vivarium_control_unit/models/device/triggers/waterHeaterType.dart';

class DeviceState {
  int currentLedColor;
  double fanSpeed;
  bool heaterOn;
  double heaterPower;
  bool ledOn;
  bool powerOutletOneOn;
  bool powerOutletTwoOn;
  bool waterHeaterOn;
  HeaterType waterHeaterType;

  DeviceState(
      {this.currentLedColor,
      this.fanSpeed,
      this.heaterOn,
      this.heaterPower,
      this.ledOn,
      this.powerOutletOneOn,
      this.powerOutletTwoOn,
      this.waterHeaterOn,
      this.waterHeaterType});

  DeviceState.fromJson(Map<String, dynamic> data)
      : this(
    currentLedColor: data['currentLedColor'] as int,
    fanSpeed: data['fanSpeed'].toDouble(),
    heaterOn: data['heaterOn'] as bool,
    waterHeaterType: HeaterType.values[(data['waterHeaterType'] as int)],
    heaterPower: data['heaterPower'].toDouble(),
    ledOn: data['ledOn'] as bool,
    waterHeaterOn: data['waterHeaterOn'] as bool,
    powerOutletOneOn: data['powerOutletOneOn'] as bool,
    powerOutletTwoOn: data['powerOutletTwoOn'] as bool,
  );



  Map<String, dynamic> toJson() => {
        'currentLedColor': currentLedColor,
        'fanSpeed': fanSpeed,
        'heaterOn': heaterOn,
        'heaterPower': heaterPower,
        'ledOn': ledOn,
        'powerOutletOneOn': powerOutletOneOn,
        'powerOutletTwoOn': powerOutletTwoOn,
        'waterHeaterOn': waterHeaterOn,
        'waterHeaterType': waterHeaterType.index,
      };

  @override
  String toString() {
    return 'DeviceState{currentLedColor: $currentLedColor, '
        'fanSpeed: $fanSpeed, heaterOn: $heaterOn, heaterPower:'
        ' $heaterPower, ledOn: $ledOn, powerOutletOneOn: $powerOutletOneOn,'
        ' powerOutletTwoOn: $powerOutletTwoOn, waterHeaterOn: $waterHeaterOn, '
        'waterHeaterType: $waterHeaterType}';
  }
}
