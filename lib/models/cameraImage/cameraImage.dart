import 'dart:typed_data';

class CameraImage{
  final Uint8List? data;
  final DateTime? updated;

  CameraImage({this.data, this.updated});
}