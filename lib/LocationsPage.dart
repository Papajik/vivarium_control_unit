import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationsPage extends StatefulWidget {
  final String uid;

  LocationsPage({Key key, this.uid}) : super(key: key);

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  @override
  Widget build(BuildContext context) {
    final locations = Firestore.instance.collection("users").document(widget.uid).collection("locations");
    List<String> names = <String>[];

    //get devices
    locations
        .getDocuments()
        .then((QuerySnapshot snapshot) {

      snapshot.documents.forEach((f) =>
      {
        print(f.data["name"]),
        names.add(f.data["name"])
      });

    });






    _addLocation() {

    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Locations"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: names.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      color: Colors.red,
                      child: Center(child: Text("Entry ${names[index]}")));
                },
              ),
            ),
            RaisedButton(
              color: Colors.green[300],
              onPressed: _addLocation,
              child: Text(
                "Add location",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ));
  }
}
