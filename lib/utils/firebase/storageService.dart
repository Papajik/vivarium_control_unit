import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  StorageService();

  Future<Uint8List?> getImage(
      {required String deviceId, required String userId}) async {
    var ref = _storage.ref('camera/' + userId + '/' + deviceId + '/photo.jpg');
    try {
      return await ref.getData(1000000);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
