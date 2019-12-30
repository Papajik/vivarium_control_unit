import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/auth.dart';
import 'package:vivarium_control_unit/ui/device/devicePage.dart';

class LocationList extends StatelessWidget {
  String locationId;
  LocationList({Key key, @required this.locationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(userId)
          .collection("locations")
          .document(locationId)
          .collection("devices")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new Ink(
              child: ListTile(
                title: new Center(child: Text(document['name'])),

                enabled: document["active"],
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                        return new DevicePage(
                          deviceName: document["name"]);
                      }));
                },
                onLongPress: () {},
                //subtitle: new Text(""+document['condition']),
              ),
              //color: document["active"]? Colors.lightGreen : Colors.grey,
            );
          }).toList(),
        );
      },
    );
  }
}
