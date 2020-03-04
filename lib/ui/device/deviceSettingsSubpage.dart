import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vivarium_control_unit/models/settingsObject.dart';

class DeviceSettingsSubpage extends StatefulWidget {
  final String deviceId;
  final String userId;

  DeviceSettingsSubpage({Key key, this.deviceId, this.userId})
      : super(key: key);

  @override
  _DeviceSettingsSubpageState createState() => _DeviceSettingsSubpageState();
}

class _DeviceSettingsSubpageState extends State<DeviceSettingsSubpage> {
  bool _change = false;
  SettingsObject _settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Center(
          child: Text("Settings", style: new TextStyle(fontSize: 20)),
        ),
        FutureBuilder(
            future: _getSettings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (_settings == null) {
                  _settings = snapshot.data;
                }
              } else {
                if (_settings == null) {
                  _settings =
                      new SettingsObject(heaterAuto: true, tempGoal: 20);
                }
              }

              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Heater auto"),
                      Checkbox(
                        value: _settings.heaterAuto,
                        onChanged: (value) {
                          setState(() {
                            _change = true;
                            _settings = new SettingsObject(
                                tempGoal: _settings.tempGoal,
                                heaterAuto: value);
                          });
                        },
                        activeColor: Colors.green,
                        tristate: false,
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Temperature Goal"),
                      Slider(
                        value: _settings.tempGoal,
                        min: 15,
                        max: 30,
                        onChanged: (value) {
                          setState(() {
                            _change = true;
                            _settings = new SettingsObject(
                                tempGoal: value,
                                heaterAuto: _settings.heaterAuto);
                          });
                        },
                      ),
                      Text(_settings.tempGoal.toStringAsFixed(1))
                    ],
                  ),
                  Center(
                    child: RaisedButton(
                      onPressed: _saveSettings(),
                      child: Text(
                        "Save settings",
                        style: TextStyle(fontSize: 18),
                      ),
                      color: Colors.blue,
                    ),
                  )
                ],
              );
            })
      ],
    ));
  }

  _getSettings() async {
    var docRef = Firestore.instance
        .collection("users")
        .document(widget.userId)
        .collection("devices")
        .document(widget.deviceId);
    var data = await docRef.get();

    var settings = data["settings"];
    var obj = SettingsObject.fromJSON(Map<String, dynamic>.from(settings));
    return obj;
  }

  _saveSettings() {
    if (!_change) {
      return null;
    } else {


      return () {
        Firestore.instance
            .collection("users")
            .document(widget.userId)
            .collection("devices")
            .document(widget.deviceId)
            .updateData({"settings": jsonEncode(_settings)});

        setState(() {
          _change = false;
        });
      };
    }
  }
}
