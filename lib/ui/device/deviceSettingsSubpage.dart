import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/settingsObject.dart';


class DeviceSettingsSubpage extends StatefulWidget {
  final String deviceId;
  final String userId;
  final BluetoothDevice device;

  DeviceSettingsSubpage({Key key, this.deviceId, this.userId, this.device})
      : super(key: key);

  @override
  _DeviceSettingsSubpageState createState() => _DeviceSettingsSubpageState();
}

class _DeviceSettingsSubpageState extends State<DeviceSettingsSubpage> {
  bool _change = false;
  SettingsObject _settings;
  bool _default = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _settings == null //No settings, has to load it
            ? FutureBuilder(
                future: _getSettings(),
                builder: (context, snapshot) {
                  return _createSettingList(snapshot.hasData
                      ? snapshot.data
                      : SettingsObject
                          .newEmpty()); //didn't receive any data (usually settings haven't been saved yet) -> create new one
                },
              )
            : _createSettingList(_settings)); //Use settings alredy in use
  }

  Widget buildObsolete(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Center(
          child: Text("Settings", style: new TextStyle(fontSize: 20)),
        ),
        FutureBuilder(
            future: _getSettings(),
            builder: (context, snapshot) {
              print("");
              print("Builder : new build");
              if (snapshot.hasData) {
                if (_settings == null || _default) {
                  _settings = snapshot.data;
                  print("Builder : snapshot has data - will modify");
                  _default = false;
                } else {
                  print("Builder : snapshot has data - won't modify");
                }
              } else {
                if (_settings == null) {
                  print(
                      "Builder : snapshot has no data & settings = null => create new settings object");
                  _settings = SettingsObject.newEmpty();
                } else {
                  print(
                      "Builder : snapshot has no data & settings != null => do nothing");
                }
              }

              print("Builder : info ");
              print((_settings.ledTriggers != null)
                  ? "Builder :" + _settings.ledTriggers.toString()
                  : "Builder : no triggers");
              print("");

              return Column(children: <Widget>[
                (widget.device == null)
                    ? Text("device null")
                    : Text("device provided"),
                Text("ASDFDSADS"),
                Row(children: <Widget>[
                  /**
                          Text("Fan"),
                          Checkbox(
                          value: _settings.peripherals.fan,
                          activeColor: Colors.green,
                          onChanged: (value){
                          setState(() {
                          _default = false;
                          _change = true;
                          _settings.peripherals.fan = value;
                          print(value);
                          });
                          },
                          tristate: true,
                          )
                          ]),

                          Row(
                          children: <Widget>[
                          Text("Heater auto"),
                          Checkbox(
                          value: _settings.heaterAuto,
                          onChanged: (value) {
                          setState(() {
                          _default = false;
                          _change = true;
                          _settings.heaterAuto = value;
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
                          _default = false;
                          _change = true;
                          _settings.tempGoal = value;
                          });
                          },
                          ),
                          Text(_settings.tempGoal.toStringAsFixed(1))
                          ],
                          ),
                       */
                  Center(
                      child: RaisedButton(
                    onPressed: _change ? _saveSettings() : null,
                    child: Text(
                      "Save settings",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: Colors.blue,
                  ))
                ])
              ]);
            })
      ],
    ));
  }

  Future<SettingsObject> _getSettings() async {
    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("devices")
        .doc(widget.deviceId);
    var data = await docRef.get();

    //  print("getSettings - start");

    var settings = data.data()["settings"];
    // print(settings);
    print("getSettings - createObject");
    //  print(settings["additionalInfo"]);
    // print(settings["peripherals"]);
    //print(settings["ledTriggers"]);
    var obj = SettingsObject.fromJson(Map<String, dynamic>.from(settings));
    //   print("getSettings - object created");
    // print(obj.peripherals.length);
    return obj;
  }

  _saveSettings() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("devices")
        .doc(widget.deviceId)
        .update({"settings": _settings.toJson()});

    if (widget.device != null) {
      _saveToDevice().then((value) => {
            setState(() {
              _change = false;
            })
          });
    } else {
      setState(() {
        _change = false;
      });
    }
  }

  Future<bool> _saveToDevice() async {
    if (widget.device == null) return false;
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase().substring(4, 8) ==
          Constants.of(context).bleService) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase().substring(4, 8) ==
              Constants.of(context).bleCharacteristic) {
            //TODO add Flutter - Arduino communication
          }
        });
      }
    });
    return true;
  }

  _getDeviceCharacteristic() {
    print("settings subpage: set characteristic");
    widget.device.discoverServices().then((services) => {
          services.forEach((service) {
            print(service.uuid);
            if (service.uuid.toString().toUpperCase().substring(4, 8) ==
                Constants.of(context).bleService) {
              print("settings subpage: characteristics:");
              service.characteristics.forEach((characteristic) {
                if (characteristic.uuid
                        .toString()
                        .toUpperCase()
                        .substring(4, 8) ==
                    Constants.of(context).bleCharacteristic) {
                  print(characteristic);
                  setState(() {
                    //_characteristic = characteristic;
                  });
                }
              });
            }
          })
        });
  }

  Widget _createSettingList(SettingsObject settingsObject) {



    return Column(
      children: [
        RaisedButton(
            child: Text(Constants.of(context).deviceSaveSettings),
          onPressed: null,
          ),
      ],
    );
  }
}
