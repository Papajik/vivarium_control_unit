import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/location.dart';
import 'package:vivarium_control_unit/ui/locations/locationTile.dart';

class LocationList extends StatelessWidget {
  final String uid;

  // Location location;

  LocationList({Key key, @required this.uid}) : super(key: key);

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("users")
            .document(uid)
            .collection("locations")
              //.orderBy("condition", descending: true) //TODO add index to firestore
            .where("active", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> locations = snapshot.data.documents;
          print("sort");
          locations.sort((a, b) {
            if (a.data["condition"] < b.data["condition"])
              return 1;
            else if (a.data["condition"] == b.data["condition"])
              return 0;
            else
              return -1;
          });
          return new ListView(
            children: snapshot.data.documents.map((document) {
              return LocationTile(
                  location:
                      Location.fromJson(document.data, document.documentID));
            }).toList(),
          );
        });
  }
}
