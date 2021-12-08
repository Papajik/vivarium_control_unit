import 'package:collection/collection.dart';
import 'package:vivarium_control_unit/models/device/modules/keys.dart';
import 'package:vivarium_control_unit/models/device/modules/led/trigger.dart';

class SettingsLed {
  Map<String, LedTrigger> triggers;

  LedTrigger? get nextTrigger {
    var now = DateTime.now().hour * 256 + DateTime.now().minute;
    LedTrigger? next;
    LedTrigger? firstInDay;
    triggers.forEach((key, trigger) {
      /// Find lowest of higher than now
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

  LedTrigger? get lastTrigger {
    var now = DateTime.now().hour * 256 + DateTime.now().minute;
    LedTrigger? next;
    LedTrigger? firstInDay;
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

  SettingsLed({this.triggers = const {}});

  factory SettingsLed.fromJson(Map? data) {
    if (data == null) return SettingsLed(triggers: {});
    var trg = <String, LedTrigger>{};
    if (data[feederTriggersKey] != null) {
      Map.from(data[feederTriggersKey]).forEach((key, value) {
        trg.addAll({key: LedTrigger.fromJson(value)});
      });
    }

    return SettingsLed(triggers: trg);
  }

  Map<String, dynamic> toJson() => {
        '$ledTriggersKey': triggers,
      };

  @override
  String toString() {
    return '{ $ledTriggersKey: ${triggers.toString()} }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsLed &&
          runtimeType == other.runtimeType &&
          MapEquality().equals(triggers, other.triggers);

  @override
  int get hashCode => triggers.hashCode;
}
