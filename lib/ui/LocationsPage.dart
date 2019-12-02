import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/locationList.dart';

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


