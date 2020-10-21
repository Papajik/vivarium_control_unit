import 'package:hive/hive.dart';

part 'ledTrigger.g.dart';

const LED_TRIGGER_LIST_SIZE = 10;

@HiveType(typeId: 3)
class LedTrigger extends HiveObject {
  @HiveField(0)
  int time;
  @HiveField(1)
  int color;

  LedTrigger({
    this.time = 0,
    this.color = 4283510184,
  });

  factory LedTrigger.fromJson(Map<String, dynamic> json) =>
      LedTrigger(time: json["time"], color: json["color"]);

  Map<String, dynamic> toJson() => {"time": time, "color": color};

  Map<String, dynamic> toMap() {
    return toJson();
  }

  String toString() {
    return '{"time": $time,"color": $color }';
  }
}
