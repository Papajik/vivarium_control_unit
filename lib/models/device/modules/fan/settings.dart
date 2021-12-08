import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class SettingsFan {
  double maxAt;
  double startAt;

  SettingsFan({required this.maxAt, required this.startAt});

  factory SettingsFan.fromJson(Map data) => SettingsFan(
        maxAt: data[fanMaxAtKey].toDouble(),
        startAt: data[fanStartAtKey].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        '$fanStartAtKey': startAt,
        '$fanMaxAtKey': maxAt,
      };

  @override
  String toString() {
    return '{ $fanMaxAtKey: $maxAt, $fanStartAtKey: $startAt }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsFan &&
          runtimeType == other.runtimeType &&
          maxAt == other.maxAt &&
          startAt == other.startAt;

  @override
  int get hashCode => maxAt.hashCode ^ startAt.hashCode;
}
