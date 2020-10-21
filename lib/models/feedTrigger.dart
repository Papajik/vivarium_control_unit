import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'feedTrigger.g.dart';

const FEED_TRIGGER_LIST_SIZE = 10;

@HiveType(typeId: 1)
enum FeedType {
  @HiveField(0)
  BOX,
  @HiveField(1)
  SCREW
}

extension FeedTypeExtension on FeedType {
  String get text => describeEnum(this);
}

String getFeedTypeString(index) => FeedType.values[index].text;

FeedType getFeedTypeFromString(name) =>
    FeedType.values.firstWhere((element) => element.text == name);

int getIndexOfFeedType(name) =>
    FeedType.values.firstWhere((element) => element.text == name).index;

@HiveType(typeId: 2)
class FeedTrigger extends HiveObject {
  @HiveField(0)
  int type;

  @HiveField(1)
  int time;

  FeedTrigger({this.time, this.type});

  factory FeedTrigger.fromJson(Map<String, dynamic> json) =>
      FeedTrigger(time: json['time'] as int, type: json['type'] as int);

  Map<String, dynamic> toJson() => {"time": time, "type": type};

  @override
  String toString() {
    return '{"type" : ${this.type},"time" : ${this.time} }';
  }
}
