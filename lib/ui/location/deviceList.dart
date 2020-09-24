import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/ui/location/deviceTile.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class DeviceList extends StatelessWidget {
  final String locationId;

  DeviceList({Key key, @required this.locationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("devices")
          .where("info.location", isEqualTo: locationId)
          .where("info.active", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return new ListView(
          children: snapshot.data.docs.map((document) {
            return DeviceTile(
              device:Device.fromJSON(document.data()),
            );
          }).toList(),
        );
      },
    );
  }
}
