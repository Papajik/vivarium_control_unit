import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/addLocationPage.dart';
import 'package:vivarium_control_unit/ui/locationList.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class LocationsPage extends StatefulWidget {
  final String uid;

  LocationsPage({Key key, this.uid}) : super(key: key);

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  @override
  Widget build(BuildContext context) {
    _addLocation() {
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new AddLocation(uid: userId);
      }));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Locations"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new LocationList(uid: widget.uid),
            ),
            RaisedButton(
              color: Colors.blueGrey[300],
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
