import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/location.dart';
import 'package:vivarium_control_unit/ui/locations/locationTile.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class LocationList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('locations')
              //.orderBy("condition", descending: true) //TODO add index to firestore
            .where('active', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          List<DocumentSnapshot> locations = snapshot.data.docs;
          print('sort');
          locations.sort((a, b) {
            if (a.data()['condition'] < b.data()['condition']) {
              return 1;
            } else if (a.data()['condition'] == b.data()['condition']) {
              return 0;
            } else {
              return -1;
            }
          });
          return ListView(
            children: snapshot.data.docs.map((document) {
              return LocationTile(
                  location:
                      Location.fromJson(document.data(), document.id));
            }).toList(),
          );
        });
  }
}
