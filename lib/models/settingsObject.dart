import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsObject {
  final bool heaterAuto;
  final double tempGoal;

  // final List<LightsInstruction> lightsInstructions;

  SettingsObject({
    this.heaterAuto,
    this.tempGoal,
    //this.lightsInstructions
  });

  SettingsObject.fromJSON(Map<String, dynamic> data)
      : this(
          heaterAuto: data['heaterAuto'],
          tempGoal: data['tempGoal'].toDouble(),
          /**
        lightsInstructions: json
        .decode(data['lights'])
        .map((Map model) =>
        {print(model), LightsInstruction.fromJSON(model)})
        .toList()
     */
        );

  Map<String, dynamic> toJson()=>{

    "heaterAuto":heaterAuto,
    "tempGoal":num.parse(tempGoal.toStringAsFixed(1))
  };

  Map<String, dynamic> toMap(){
    return {"heaterAuto":heaterAuto, "tempGoal":num.parse(tempGoal.toStringAsFixed(1))};
  }
}

class LightsInstruction {
  final String instruction;
  final Timestamp time;

  const LightsInstruction({this.instruction, this.time});

  LightsInstruction.fromJSON(Map<String, dynamic> data)
      : this(instruction: data['instruction'], time: data['time']);
}
