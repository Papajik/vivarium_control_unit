class SettingsPh {
  double maxPh;
  double minPh;
  bool continuous;
  int continuousDelay;

  SettingsPh({required this.maxPh, required this.minPh, required this.continuous, required this.continuousDelay});

  factory SettingsPh.fromJson(Map data) =>  SettingsPh(
          maxPh: data['maxPh'].toDouble(),
          minPh: data['minPh'].toDouble(),
          continuousDelay: data['continuousDelay'],
          continuous: data['continuous'] as bool);

  Map<String, dynamic> toJson() => {
        'maxPh': maxPh,
        'minPh': minPh,
        'continuous': continuous,
        'continuousDelay': continuousDelay
      };

  @override
  String toString() {
    return '{ maxPh: $maxPh, minPh: $minPh, continuous: $continuous }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsPh &&
          runtimeType == other.runtimeType &&
          maxPh == other.maxPh &&
          minPh == other.minPh &&
          continuous == other.continuous &&
          continuousDelay == other.continuousDelay;

  @override
  int get hashCode =>
      maxPh.hashCode ^
      minPh.hashCode ^
      continuous.hashCode ^
      continuousDelay.hashCode;
}
