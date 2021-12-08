import 'package:collection/collection.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/trigger.dart';
import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsHeater {
  Map<String, HeaterTrigger> triggers;

  HeaterTrigger? get nextTrigger {
    var now = DateTime.now().hour * 256 + DateTime.now().minute;
    HeaterTrigger? next;
    HeaterTrigger? firstInDay;
    triggers.forEach((key, trigger) {
      /// Find lowest of higher than now
      if (trigger.time > now) {
        next == null
            ? next = trigger
            : trigger.time < next!.time
                ? next = trigger
                : null;
      } else {
        /// Find lowest of lower than now
        firstInDay == null
            ? firstInDay = trigger
            : trigger.time < firstInDay!.time
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

  HeaterTrigger? get lastTrigger {
    var now = DateTime.now().hour * 256 + DateTime.now().minute;
    HeaterTrigger? next;
    HeaterTrigger? firstInDay;
    triggers.forEach((key, trigger) {
      /// Find highest of lower
      if (trigger.time < now) {
        next == null
            ? next = trigger
            : trigger.time > next!.time
                ? next = trigger
                : null;
      } else {
        /// Find highest of higher
        firstInDay == null
            ? firstInDay = trigger
            : trigger.time > firstInDay!.time
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

  static Map<int, String> modeValues = {
    0: 'Automatic',
    1: 'External',
    2: 'Thermostat',
    3: 'Direct'
  };

  static bool isModeInternal(int m) => m != 1;

  static bool isModeAutomatic(int m) => m == 0;

  static bool isModeDirect(int m) => m == 3;

  int mode;

  bool get isInternal => isModeInternal(mode);

  bool get isPID => isModeAutomatic(mode);

  bool get isDirect => isModeDirect(mode);

  int tuneMode;
  static Map<int, String> tuneModeValues = {
    /// ZIEGLER_NICHOLS_PI
    0: 'ZG_PI',

    /// ZIEGLER_NICHOLS_PID
    1: 'ZG_PID',

    /// TYREUS_LUYBEN_PI
    2: 'TL_PI',

    /// TYREUS_LUYBEN_PID
    3: 'TL_PID',

    /// CIANCONE_MARLIN_PI
    4: 'CM_PI',

    /// CIANCONE_MARLIN_PID
    5: 'CM_PID',

    /// AMIGOF_PID
    6: 'AM_PID',

    /// PESSEN_INTEGRAL_PID
    7: 'PI_PID',

    /// SOME_OVERSHOOT_PID
    8: 'SO_PID',

    /// NO_OVERSHOOT_PID
    9: 'NO_PID',
  };

  double directPower;

  SettingsHeater(
      {required this.directPower,
      required this.tuneMode,
      required this.mode,
      this.triggers = const {}});

  factory SettingsHeater.fromJson(Map data) {
    var trg = <String, HeaterTrigger>{};
    if (data[heaterTriggersKey] != null) {
      Map.from(data[heaterTriggersKey]).forEach((key, value) {
        trg.addAll({key: HeaterTrigger.fromJson(value)});
      });
    }
    return SettingsHeater(
        triggers: trg,
        mode: data[heaterModeKey] as int,
        tuneMode: data[heaterTuneModeKey] as int,
        directPower: data[heaterDirectPowerKey].toDouble());
  }

  Map<String, dynamic> toJson() => {
        '$heaterModeKey': mode,
        '$heaterTriggersKey': triggers,
        '$heaterTuneModeKey': tuneMode,
        '$heaterDirectPowerKey': directPower
      };

  @override
  String toString() {
    return '{ $heaterModeKey: $mode,$heaterTuneModeKey: $tuneMode,$heaterDirectPowerKey: $directPower,  $heaterTriggersKey: ${triggers.toString()} }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsHeater &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          directPower == other.directPower &&
          tuneMode == other.tuneMode &&
          MapEquality().equals(triggers, other.triggers);

  @override
  int get hashCode =>
      mode.hashCode ^
      tuneMode.hashCode ^
      directPower.hashCode ^
      triggers.hashCode;
}
