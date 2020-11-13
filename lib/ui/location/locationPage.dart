
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/location.dart';
import 'package:vivarium_control_unit/ui/location/deviceList.dart';

class LocationPage extends StatefulWidget {
  final String uid;
  final Location location;

  LocationPage({Key key, this.uid, this.location}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.location.name + ' - overview'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: DeviceList(locationId: widget.location.id),
            )
          ],
        ));
  }
}
