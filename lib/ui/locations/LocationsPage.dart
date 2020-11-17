import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/addLocation/addLocationPage.dart';
import 'package:vivarium_control_unit/ui/locations/locationList.dart';

class LocationsPage extends StatefulWidget {

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  @override
  Widget build(BuildContext context) {

    void _addLocation() {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return AddLocationPage();
      }));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: LocationList(),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addLocation,
      ),
    );
  }
}
