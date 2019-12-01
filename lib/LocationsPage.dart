import 'package:flutter/material.dart';

class LocationsPage extends StatefulWidget {
  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];
    _addLocation() {}

    return Scaffold(
        appBar: AppBar(
          title: Text("Locations"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      color: Colors.amber[colorCodes[index]],
                      child: Center(child: Text("Entry ${entries[index]}")));
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
