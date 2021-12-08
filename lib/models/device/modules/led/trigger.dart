import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class LedTrigger {
  int? time;
  int? color;

  LedTrigger({this.time, this.color});

  factory LedTrigger.fromJson(Map json) => LedTrigger(
      time: json[ledTriggerTimeKey] as int?,
      color: json[ledTriggerColorKey] as int?);

  Map<String, dynamic> toJson() =>
      {'$ledTriggerTimeKey': time, '$ledTriggerColorKey': color};

  @override
  String toString() {
    return '{$ledTriggerTimeKey : $time, $ledTriggerColorKey: $color }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedTrigger &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          color == other.color;

  @override
  int get hashCode => time.hashCode ^ color.hashCode;
}
