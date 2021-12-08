class StateWaterTemp {
  bool connected;

  StateWaterTemp({this.connected = false});

  factory StateWaterTemp.fromJson(Map data) =>
      StateWaterTemp(connected: data['connected'] as bool);

  Map<String, dynamic> toJson() => {'connected': connected};

  @override
  String toString(){
    return '{connected: $connected}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateWaterTemp &&
          runtimeType == other.runtimeType &&
          connected == other.connected;

  @override
  int get hashCode => connected.hashCode;
}
