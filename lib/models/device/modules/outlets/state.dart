import 'package:collection/collection.dart';

class Outlet {
  bool? isOn;
  bool? isAvailable;

  Outlet({this.isOn, this.isAvailable});

  @override
  bool operator ==(other) {
    return (other is Outlet) &&
        other.isOn == isOn &&
        other.isAvailable == isAvailable;
  }

  @override
  int get hashCode => isOn.hashCode ^ isAvailable.hashCode;
}

class StateOutlet {
  List<Outlet> outlets = <Outlet>[];

  StateOutlet({required this.outlets});

  factory StateOutlet.fromJson(Map? data) => StateOutlet(
        outlets: [
          Outlet(
              isAvailable: data?['o0'] != null,
              isOn: data?['o0'] as bool? ?? false),
          Outlet(
              isAvailable: data?['o1'] != null,
              isOn: data?['o1'] as bool? ?? false),
          Outlet(
              isAvailable: data?['o2'] != null,
              isOn: data?['o2'] as bool? ?? false),
          Outlet(
              isAvailable: data?['o3'] != null,
              isOn: data?['o3'] as bool? ?? false)
        ],
      );

  Map<String, dynamic> toJson() => {
        if (outlets[0].isAvailable ?? false) 'o0': outlets[0].isOn,
        if (outlets[1].isAvailable ?? false) 'o1': outlets[1].isOn,
        if (outlets[2].isAvailable ?? false) 'o2': outlets[2].isOn,
        if (outlets[3].isAvailable ?? false) 'o3': outlets[3].isOn,
      };

  @override
  String toString() {
    var s = '{ ';
    if (outlets[0].isAvailable ?? false) s += 'o0: ${outlets[0].isOn}';
    if (outlets[1].isAvailable ?? false) s += 'o1: ${outlets[1].isOn}';
    if (outlets[2].isAvailable ?? false) s += 'o2: ${outlets[2].isOn}';
    if (outlets[3].isAvailable ?? false) s += 'o3: ${outlets[3].isOn}';
    s += '}';
    return s;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateOutlet &&
          runtimeType == other.runtimeType &&
          ListEquality().equals(outlets, other.outlets);

  @override
  int get hashCode => outlets.hashCode;
}
