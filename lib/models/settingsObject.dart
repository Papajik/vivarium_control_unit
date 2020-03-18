import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/models/peripherals.dart';

class SettingsObject {
  bool heaterAuto;
  double tempGoal;
  Peripherals peripherals;
  List<LedTrigger> ledTriggers;

  SettingsObject(
      {this.peripherals, this.heaterAuto, this.tempGoal, this.ledTriggers});

  SettingsObject.fromJson(Map<String, dynamic> data)
      : this(
            heaterAuto: data['heaterAuto'],
            tempGoal: data['tempGoal'].toDouble(),
            peripherals: Peripherals.fromJson(
                Map<String, dynamic>.from(data['peripherals'])),
            ledTriggers: createListOfTriggers(data['ledTriggers'])
            // ledTriggers: json.decode(data['ledTriggers']).map((Map model) => LedTrigger.fromJson(data)),
            /**
        lightsInstructions: json
        .decode(data['lights'])
        .map((Map model) =>
        {print(model), LightsInstruction.fromJSON(model)})
        .toList()
     */
            );

  Map<String, dynamic> toJson() => {
        "heaterAuto": heaterAuto,
        "tempGoal": num.parse(tempGoal.toStringAsFixed(1)),
        "peripherals": peripherals.toJson()
      };

  Map<String, dynamic> toMap() {
    return {
      "heaterAuto": heaterAuto,
      "tempGoal": num.parse(tempGoal.toStringAsFixed(1)),
      "peripherals": peripherals.toJson(),
    };
  }

  static List<LedTrigger> createListOfTriggers(List data) {
    List<LedTrigger> list = new List();
    for (Map i in data) {
      list.add(LedTrigger.fromJson(Map<String, dynamic>.from(i)));
    }
    return list;
  }
}
