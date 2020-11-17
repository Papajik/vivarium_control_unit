import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/location/deviceTile.dart';
import 'package:vivarium_control_unit/utils/firebaseProvider.dart';

class DeviceList extends StatelessWidget {
  final String locationId;

  DeviceList({Key key, @required this.locationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: devicesStream(locationId:locationId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null || snapshot.data.docs == null){
          return Text("Should'nt not see this");
        }
        return ListView(
          children: snapshot.data.docs.map((document) {
            return DeviceTile(
              device:Device.fromJson(document.data()),
            );
          }).toList(),
        );
      },
    );
  }
}
