import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class FeedTrigger {
  int? time;

  FeedTrigger({this.time});

  factory FeedTrigger.fromJson(Map json) =>
      FeedTrigger(time: json[feederTriggerTimeKey] as int?);

  Map<String, dynamic> toJson() => {'$feederTriggerTimeKey': time};

  @override
  String toString() {
    return '{$feederTriggerTimeKey : $time }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedTrigger &&
          runtimeType == other.runtimeType &&
          time == other.time;

  @override
  int get hashCode => time.hashCode;
}
