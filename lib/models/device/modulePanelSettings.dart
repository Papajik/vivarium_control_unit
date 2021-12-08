class ModulePanelSettings {
  int brightness;

  ModulePanelSettings({required this.brightness});

  factory ModulePanelSettings.fromJson(Map data) {
    return ModulePanelSettings(
        brightness: data['brightness']);
  }

  Map<String, dynamic> toJson() => {
        'brightness': brightness,
      };

  @override
  String toString() {
    return '{ brightness: $brightness}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModulePanelSettings &&
          runtimeType == other.runtimeType &&
          brightness == other.brightness;

  @override
  int get hashCode => brightness.hashCode;
}
