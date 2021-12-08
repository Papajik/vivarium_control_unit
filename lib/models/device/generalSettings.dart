/// General settings of device
/// Don't depend on supported modules
/// Used across all devices
class GeneralSettings {
  bool trackAlive;

  GeneralSettings({required this.trackAlive});

  factory GeneralSettings.fromJson(Map data) =>
      GeneralSettings(trackAlive: data['trackAlive'] as bool);

  Map<String, dynamic> toJson() => {
        'trackAlive': trackAlive,
      };

  @override
  String toString() {
    return '{ trackAlive: $trackAlive }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralSettings &&
          runtimeType == other.runtimeType &&
          trackAlive == other.trackAlive;

  @override
  int get hashCode => trackAlive.hashCode;
}
