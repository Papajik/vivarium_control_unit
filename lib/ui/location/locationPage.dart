import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vivarium_control_unit/models/location.dart';
import 'package:vivarium_control_unit/ui/location/deviceList.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

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
          title: Text(widget.location.name + " - overview"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new DeviceList(locationId: widget.location.id),
            )
          ],
        ));
  }

  Future<String> getData() async {
    Map data;

    var response = await http.post(

        // replace with your device id.
        // also update the access token with your own.

        Uri.encodeFull(
            "https://api.particle.io/v1/devices/${widget.location.id}/led"),
        headers: {"Accept": "application/json"},
        body: {"arg": "off", "access_token": photonAccessToken});
    data = json.decode(response.body);
    print(data);

    return "Success!";
  }
}
