import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivarium_control_unit/models/waterHeaterType.dart';
import 'package:vivarium_control_unit/ui/device/overview/animatedChart.dart';
import 'package:vivarium_control_unit/ui/device/overview/iconRotation.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/sensorValuesProvider.dart'
    as SensorValues;
import 'package:vivarium_control_unit/utils/sensorValuesProvider.dart';

class DeviceOverviewSubpage extends StatefulWidget {
  final String deviceId;
  final String userId;

  DeviceOverviewSubpage({Key key, this.deviceId, this.userId})
      : super(key: key);

  @override
  _DeviceOverviewSubpageState createState() => _DeviceOverviewSubpageState();
}

class _DeviceOverviewSubpageState extends State<DeviceOverviewSubpage> {
  @override
  void initState() {
    SensorValues.deviceId = widget.deviceId;
    SensorValues.userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: SensorValues.deviceHistoryStream(),
      builder: (context, deviceHistorySnapshot) => StreamBuilder(
        stream: SensorValues.deviceStream(),
        builder: (context, deviceSnapshot) {
          return Scaffold(
              body: Padding(
            padding: EdgeInsets.all(5),
            child: StaggeredGridView.count(
              crossAxisCount: 4,
              staggeredTiles: _staggeredTiles,
              children: _createHistoryTiles(deviceHistorySnapshot) +
                  _createStateTiles(deviceSnapshot),
            ),
          ));
        },
      ),
    );
  }

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(4, 2), //Temperature
    const StaggeredTile.count(4, 2), //Ph
    const StaggeredTile.count(4, 2), //Water level
    const StaggeredTile.count(2, 1), //Outlet 1
    const StaggeredTile.count(2, 1), //Outlet 2
    const StaggeredTile.count(2, 1), //Feeding
    const StaggeredTile.count(2, 1), //Lights
    const StaggeredTile.count(2, 1), //Fan
    const StaggeredTile.count(2, 1), //Heater
  ];

  _createHistoryTiles(AsyncSnapshot<dynamic> snapshot) {
    List history;
    if (snapshot.hasData) history = snapshot.data.data()['sensorValuesHistory'];

    return <Widget>[
      OverviewCard(
        title: "Temperature",
        additionalHeaders: [
          "T1: ${snapshot.hasData ? getLastValue(history, 'waterTemperature1') : "..."} °C",
          "T2: ${snapshot.hasData ? getLastValue(history, 'waterTemperature2') : "..."} °C"
        ],
        body: snapshot.hasData
            ? AnimatedChart(lines: [
                SensorValues.getHistoryDoubleMap(history, "waterTemperature1"),
                SensorValues.getHistoryDoubleMap(history, "waterTemperature2")
              ], colors: [
                Colors.red,
                Colors.blue
              ], units: [
                '°C',
                '°C'
              ])
            : Center(child: CircularProgressIndicator()),
        key: UniqueKey(),
      ),
      OverviewCard(
          title: "Water pH",
          additionalHeaders: [
            "pH: ${snapshot.hasData ? SensorValues.getLastValue(history, 'waterPh') : "..."}"
          ],
          body: snapshot.hasData
              ? AnimatedChart(
                  lines: [SensorValues.getHistoryDoubleMap(history, 'waterPh')],
                  colors: [Colors.red],
                  units: [''])
              : Center(child: CircularProgressIndicator()),
          key: UniqueKey()),
      OverviewCard(
          title: "Water level",
          additionalHeaders: [
            "Level: ${snapshot.hasData ? SensorValues.getLastValue(history, 'waterLevel') : "..."} cm"
          ],
          body: snapshot.hasData
              ? AnimatedChart(lines: [
                  SensorValues.getHistoryDoubleMap(history, 'waterLevel')
                ], colors: [
                  Colors.red
                ], units: [
                  'cm'
                ])
              : Center(child: CircularProgressIndicator()),
          key: UniqueKey()),
    ];
  }

  _createStateTiles(AsyncSnapshot<dynamic> snapshot) {
    Map<String, dynamic> device;
    if (snapshot.hasData) device = snapshot.data.data();
    print(Colors.red.value);
    return <Widget>[
      _buildOutlet1(snapshot.hasData, device),
      _buildOutlet2(snapshot.hasData, device),
      _buildFeed(snapshot.hasData, device),
      _buildLED(snapshot.hasData, device),
      _buildFan(snapshot.hasData, device),
      _buildHeater(snapshot.hasData, device)
    ];
  }

  _buildOutlet1(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
        title: "Outlet 1",
        body: TriggerCardBody(
          icon: (hasData &&
                  SensorValues.getStateValue(device, 'powerOutletOneOn'))
              ? Icon(Icons.power, color: Colors.orangeAccent)
              : Icon(Icons.power_off),
          nextTriggerTime: hasData
              ? SensorValues.getNextTriggerTime(
                  device, 'powerOutletOneTriggers')
              : "...",
          nextChange: hasData
              ? SensorValues.getNextTriggerValue(
                      device, 'powerOutletOneTriggers', 'outletOn')
                  ? Text("Turn ON")
                  : Text("Turn OFF")
              : Text("..."),
        ));
  }

  _buildOutlet2(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
        title: "Outlet 1",
        body: TriggerCardBody(
          icon: (hasData &&
                  SensorValues.getStateValue(device, 'powerOutletTwoOn'))
              ? Icon(Icons.power, color: Colors.orangeAccent)
              : Icon(Icons.power_off),
          nextTriggerTime: hasData
              ? SensorValues.getNextTriggerTime(
                  device, 'powerOutletTwoTriggers')
              : "...",
          nextChange: hasData
              ? SensorValues.getNextTriggerValue(
                      device, 'powerOutletTwoTriggers', 'outletOn')
                  ? Text("Turn ON")
                  : Text("Turn OFF")
              : Text("..."),
        ));
  }

  _buildFeed(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
      title:
          "Feed ${hasData ? "(${SensorValues.getNumberOfTriggers(device, 'feedTriggers')})" : ""}",
      background: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Text(
                "Last feeding: ${hasData ? SensorValues.getLastTrigger(device, 'feedTriggers') : "..."}"),
            SizedBox(
              height: 10,
            ),
            Text(
                "Next feeding: ${hasData ? SensorValues.getNextTriggerTime(device, 'feedTriggers') : "..."}")
          ],
        ),
      ),
    );
  }

  _buildLED(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
        title:
            "LED ${hasData ? "(${SensorValues.getNumberOfTriggers(device, 'ledTriggers')})" : ""}",
        body: TriggerCardBody(
          icon: hasData && SensorValues.getStateValue(device, 'ledOn')
              ? Icon(Icons.lightbulb,
                  color: Color(SensorValues.getStateValue(device, 'ledColor')))
              : Icon(Icons.lightbulb_outline),
          nextTriggerTime: hasData
              ? SensorValues.getNextTriggerTime(device, 'ledTriggers')
              : "...",
          nextChange: hasData
              ? (SensorValues.getNextTriggerValue(
                          device, 'ledTriggers', 'color') as int ==
                      0)
                  ? Text("Turn OFF")
                  : ClipOval(
                      child: Container(
                          height: 20,
                          width: 20,
                          color: Color((SensorValues.getNextTriggerValue(
                              device, 'ledTriggers', 'color')))),
                    )
              : Text("..."),
        ));
  }

  _buildFan(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
      title: "Fan",
      body: CardBody(
        icon: IconRotation(
          icon: FaIcon(FontAwesomeIcons.fan),
          speed: hasData
              ? SensorValues.getStateValue(device, 'fanSpeed') + .0
              : 0.0,
        ),
        children: [
          hasData
              ? Text(
                  "Fan speed: ${SensorValues.getStateValue(device, 'fanSpeed')} %")
              : Text("Fan speed: 0 %")
        ],
      ),
    );
  }

  _buildHeater(bool hasData, Map<String, dynamic> device) {
    String status = "...";
    String type = HeaterType.values[0].text;
    if (hasData) {
      status = SensorValues.getStateValue(device, "waterHeaterOn")?"ON":"OFF";
      type = HeaterType
          .values[SensorValues.getStateValue(device, "waterHeaterType")].text;
    }
    return OverviewCard(
      title: "Heater",
      body: CardBody(
        icon: Icon(Icons.local_fire_department),
        children: [
          Text("Heater status: $status"),
          SizedBox(
            height: 10,
          ),
          Text("Heater type: $type")
        ],
      ),
    );
  }
}
