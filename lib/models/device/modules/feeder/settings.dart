import 'package:vivarium_control_unit/models/device/modules/feeder/trigger.dart';
import 'package:vivarium_control_unit/models/device/modules/keys.dart';
import 'package:collection/collection.dart';


const Map<int, String> modeValues = {0: 'SCREW', 1: 'BOX'};

class SettingsFeeder {
  Map<String, FeedTrigger> triggers;
  int type;

  FeedTrigger? get nextTrigger {
    var now = DateTime.now().hour * 256 + DateTime.now().minute;
    FeedTrigger? next;
    FeedTrigger? firstInDay;
    triggers.forEach((key, trigger) {
      // Find lowest of higher than now
      if (trigger.time! > now) {
        next == null
            ? next = trigger
            : trigger.time! < next!.time!
                ? next = trigger
                : null;
      } else {
        /// Find lowest of lower than now
        firstInDay == null
            ? firstInDay = trigger
            : trigger.time! < firstInDay!.time!
                ? firstInDay = trigger
                : null;
      }
    });

    if (next != null) {
      return next;
    } else {
      return firstInDay;
    }
  }

  FeedTrigger? get lastTrigger {
    var now = DateTime.now().hour * 256 + DateTime.now().minute;
    FeedTrigger? next;
    FeedTrigger? firstInDay;
    triggers.forEach((key, trigger) {
      /// Find highest of lower
      if (trigger.time! < now) {
        next == null
            ? next = trigger
            : trigger.time! > next!.time!
            ? next = trigger
            : null;
      } else {
        /// Find highest of higher
        firstInDay == null
            ? firstInDay = trigger
            : trigger.time! > firstInDay!.time!
            ? firstInDay = trigger
            : null;
      }
    });

    if (next != null) {
      return next;
    } else {
      return firstInDay;
    }
  }

  SettingsFeeder({required this.type, this.triggers = const {}});

  factory SettingsFeeder.fromJson(Map? data) {
    var trg = <String, FeedTrigger>{};
    if (data?[feederTriggersKey]!=null){
      Map.from(data?[feederTriggersKey]).forEach((key, value) {
        trg.addAll({key: FeedTrigger.fromJson(value)});
      });
    }


    return SettingsFeeder(type: data?[feederTypeKey] as int, triggers: trg);
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'triggers': triggers,
      };

  @override
  String toString() {
    return '{ type: $type, triggers: ${triggers.toString()} }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsFeeder &&
          runtimeType == other.runtimeType &&
          MapEquality().equals(triggers, other.triggers) &&
          type == other.type;

  @override
  int get hashCode => triggers.hashCode ^ type.hashCode;
}
