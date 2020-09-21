import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'feedTrigger.g.dart';


@HiveType(typeId: 1)
enum FeedType{
 BOX, SCREW
}




@HiveType(typeId: 2)
class FeedTrigger  extends HiveObject{
  @HiveField(0)
  FeedType type;

  @HiveField(1)
  DateTime dateTime;

  FeedTrigger({this.dateTime, this.type});

  factory FeedTrigger.fromJson(Map<String, dynamic> json) => FeedTrigger(
    dateTime: json['time'].toDate(),
    type: FeedType.values.firstWhere((e) => e.toString() == json['type'])
  );

  Map<String, dynamic> toJson() =>
      {"time": Timestamp.fromDate(dateTime), "type": type.toString()};

  @override
  String toString() {
    return '{"type" : ${this.type},"time" : ${this.dateTime} }';
  }
}