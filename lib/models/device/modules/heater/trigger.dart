import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class HeaterTrigger {
  int time;
  double goal;

  HeaterTrigger({required this.time, required this.goal});

  factory HeaterTrigger.fromJson(Map json) => HeaterTrigger(
      time: json[heaterTriggerTimeKey] as int,
      goal: json[heaterTriggerGoalKey].toDouble());

  Map<String, dynamic> toJson() =>
      {'$heaterTriggerTimeKey': time, '$heaterTriggerGoalKey': goal};

  @override
  String toString() {
    return '{$heaterTriggerTimeKey : $time, $heaterTriggerGoalKey: $goal }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HeaterTrigger &&
              runtimeType == other.runtimeType &&
              time == other.time &&
              goal == other.goal;

  @override
  int get hashCode => time.hashCode ^ goal.hashCode;
}
