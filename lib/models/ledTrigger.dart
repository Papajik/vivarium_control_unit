import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'ledTrigger.g.dart';

@HiveType(typeId: 3)
class LedTrigger extends HiveObject {
  @HiveField(0)
  DateTime dateTime;
  @HiveField(1)
  int color;

  LedTrigger({
    this.dateTime,
    this.color,
  });

  factory LedTrigger.fromJson(Map<String, dynamic> json) =>
      LedTrigger(dateTime: json["time"].toDate(), color: json["color"]);

  Map<String, dynamic> toJson() =>
      {"time": Timestamp.fromDate(dateTime), "color": color};

  Map<String, dynamic> toMap() {
    return toJson();
  }

  String toString() {
    return '{"time": $dateTime,"color": $color }';
  }
}
