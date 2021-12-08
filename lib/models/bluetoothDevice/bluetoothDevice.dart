import 'package:flutter/material.dart';

/// Object used for connecting vivarium/camera by bluetooth
@immutable
class BluetoothDevice {
  /// Firebase ID
  final String? firebaseId;

  /// Mac Address
  final String macAddress;

  /// Device Name
  final String name;

  /// RSSI Level
  final int? rssi;

  BluetoothDevice(
      {this.rssi,
      required this.macAddress,
      required this.name,
      this.firebaseId});

  BluetoothDevice copyWith(
          {int? rssi, String? macAddress, String? name, firebaseId}) =>
      BluetoothDevice(
          macAddress: macAddress ?? this.macAddress,
          name: name ?? this.name,
          rssi: rssi ?? this.rssi,
          firebaseId: firebaseId ?? this.firebaseId);

  @override
  String toString() {
    return '{macAddress: $macAddress, name: $name, rssi: $rssi, firebaseId: $firebaseId}';
  }
}

/// List of bluetooth devices. Encapsulated to allow being passed by Provider
@immutable
class BluetoothDeviceEncapsulation {
  final List<BluetoothDevice> devices;

  BluetoothDeviceEncapsulation({this.devices = const []});
}
