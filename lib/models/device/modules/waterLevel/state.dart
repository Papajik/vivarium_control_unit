class StateWaterLevel {
  bool connected;

  StateWaterLevel({this.connected = false});

  factory StateWaterLevel.fromJson(Map data) =>
      StateWaterLevel(connected: data['connected'] as bool);

  Map<String, dynamic> toJson() => {'connected': connected};

  @override
  String toString(){
    return '{connected: $connected}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateWaterLevel &&
          runtimeType == other.runtimeType &&
          connected == other.connected;

  @override
  int get hashCode => connected.hashCode;
}
