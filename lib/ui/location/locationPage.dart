import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class LocationPage extends StatefulWidget {
  final String uid;
  final String locationId;
  final String locationName;

  LocationPage({Key key, this.uid, this.locationId, this.locationName})
      : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  _getFunctions() async {
    var response = await http.get(Uri.encodeFull(
        "https://api.particle.io/v1/devices/${widget.locationId}?access_token=$photonAccessToken"));
    Map data = json.decode(response.body);
    return data["functions"];
  }

  _getVariables() async {
    var response = await http.get(Uri.encodeFull(
        "https://api.particle.io/v1/devices/${widget.locationId}?access_token=$photonAccessToken"));
    Map data = json.decode(response.body);
    Map variables = data["variables"];
    return variables.keys.toList();
  }

  _getVariable(String variable) async{
    var response = await http.get(Uri.encodeFull(
        "https://api.particle.io/v1/devices/${widget.locationId}/$variable?access_token=$photonAccessToken"));
    Map data = json.decode(response.body);
    return  data["result"].toString();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.locationName + " - overview"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Text("Funkce"),
            new Expanded(
              child: (FutureBuilder(
                future: _getFunctions(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]),
                            onTap: () {},
                          );
                        });
                },
              )),
            ),
            Text("Proměnné"),
            new Expanded(
              child: (FutureBuilder(
                future: _getVariables(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index]),
                            onTap: () async {
                              String s = await _getVariable(snapshot.data[index]);
                              Toast.show(s, context,
                                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                            },
                          );
                        });
                },
              )),
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
            "https://api.particle.io/v1/devices/${widget.locationId}/led"),
        headers: {"Accept": "application/json"},
        body: {"arg": "off", "access_token": photonAccessToken});
    data = json.decode(response.body);
    print(data);

    return "Success!";
  }
}
