import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class StateHeater {
  bool connected;
  bool tuning;
  double goal;

  double kp;
  double ki;
  double kd;
  double pOn;

  StateHeater(
      {this.kp = 10,
      this.pOn = 1,
      this.ki = 0,
      this.kd = 0,
      this.tuning = false,
      this.connected = false,
      this.goal = 15});

  factory StateHeater.fromJson(Map data) => StateHeater(
      connected: data[connectedKey] as bool,
      tuning: data[tuningKey] as bool,
      kp: data[kpKey].toDouble(),
      pOn: data[pOnKey].toDouble(),
      ki: data[kiKey].toDouble(),
      kd: data[kdKey].toDouble(),
      goal: data[heaterGoalKey].toDouble());

  Map<String, dynamic> toJson() => {
        '$connectedKey': connected,
        '$heaterGoalKey': goal,
        '$tuningKey': tuning,
        '$kpKey': kp,
        '$kiKey': ki,
        '$pOnKey': pOn,
        '$kdKey': kd,
      };

  @override
  String toString() {
    return '{connected: $connected, $heaterGoalKey: $goal, $tuningKey: $tuning, $kpKey: $kp, $kiKey: $ki, $kdKey: $kd, $pOnKey: $pOn }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateHeater &&
          runtimeType == other.runtimeType &&
          goal == other.goal &&
          tuning == other.tuning &&
          kp == other.kp &&
          pOn == other.pOn &&
          kd == other.kd &&
          ki == other.ki &&
          connected == other.connected;

  @override
  int get hashCode =>
      connected.hashCode ^
      goal.hashCode ^
      tuning.hashCode ^
      kp.hashCode ^
      kd.hashCode ^
      pOn.hashCode ^
      ki.hashCode ^
      connected.hashCode;
}
