import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivarium_control_unit/models/waterHeaterType.dart';
import 'package:vivarium_control_unit/ui/device/overview/animatedChart.dart';
import 'package:vivarium_control_unit/ui/device/overview/iconRotation.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/firebaseProvider.dart'
    as sensor_values;
import 'package:vivarium_control_unit/utils/firebaseProvider.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sensor_values.deviceHistoryStream(widget.deviceId),
      builder: (context, deviceHistorySnapshot) => StreamBuilder(
        stream: sensor_values.deviceStream(widget.deviceId),
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

  final List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    StaggeredTile.count(4, 2), //Temperature
    StaggeredTile.count(4, 2), //Ph
    StaggeredTile.count(4, 2), //Water level
    StaggeredTile.count(2, 1), //Outlet 1
    StaggeredTile.count(2, 1), //Outlet 2
    StaggeredTile.count(2, 1), //Feeding
    StaggeredTile.count(2, 1), //Lights
    StaggeredTile.count(2, 1), //Fan
    StaggeredTile.count(2, 1), //Heater
  ];

  List<Widget> _createHistoryTiles(AsyncSnapshot<dynamic> snapshot) {
    List history;
    if (snapshot.hasData) history = snapshot.data.data()['sensorValuesHistory'];

    return <Widget>[
      OverviewCard(
        title: 'Temperature',
        additionalHeaders: [
          "T1: ${snapshot.hasData ? getLastValue(history, 'waterTemperature1') : "..."} °C",
          "T2: ${snapshot.hasData ? getLastValue(history, 'waterTemperature2') : "..."} °C"
        ],
        body: snapshot.hasData
            ? AnimatedChart(lines: [
                sensor_values.getHistoryDoubleMap(history, 'waterTemperature1'),
                sensor_values.getHistoryDoubleMap(history, 'waterTemperature2')
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
          title: 'Water pH',
          additionalHeaders: [
            "pH: ${snapshot.hasData ? sensor_values.getLastValue(history, 'waterPh') : "..."}"
          ],
          body: snapshot.hasData
              ? AnimatedChart(lines: [
                  sensor_values.getHistoryDoubleMap(history, 'waterPh')
                ], colors: [
                  Colors.red
                ], units: [
                  ''
                ])
              : Center(child: CircularProgressIndicator()),
          key: UniqueKey()),
      OverviewCard(
          title: 'Water level',
          additionalHeaders: [
            "Level: ${snapshot.hasData ? sensor_values.getLastValue(history, 'waterLevel') : "..."} cm"
          ],
          body: snapshot.hasData
              ? AnimatedChart(lines: [
                  sensor_values.getHistoryDoubleMap(history, 'waterLevel')
                ], colors: [
                  Colors.red
                ], units: [
                  'cm'
                ])
              : Center(child: CircularProgressIndicator()),
          key: UniqueKey()),
    ];
  }

  List<Widget> _createStateTiles(AsyncSnapshot<dynamic> snapshot) {
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

  OverviewCard _buildOutlet1(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
        title: 'Outlet 1',
        body: TriggerCardBody(
          icon: (hasData &&
                  sensor_values.getStateValue(device, 'powerOutletOneOn'))
              ? Icon(Icons.power, color: Colors.orangeAccent)
              : Icon(Icons.power_off),
          nextTriggerTime: hasData
              ? sensor_values.getNextTriggerTime(
                  device, 'powerOutletOneTriggers')
              : '...',
          nextChange: hasData
              ? sensor_values.getNextTriggerValue(
                      device, 'powerOutletOneTriggers', 'outletOn')
                  ? Text('Turn ON')
                  : Text('Turn OFF')
              : Text('...'),
        ));
  }

  OverviewCard _buildOutlet2(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
        title: 'Outlet 1',
        body: TriggerCardBody(
          icon: (hasData &&
                  sensor_values.getStateValue(device, 'powerOutletTwoOn'))
              ? Icon(Icons.power, color: Colors.orangeAccent)
              : Icon(Icons.power_off),
          nextTriggerTime: hasData
              ? sensor_values.getNextTriggerTime(
                  device, 'powerOutletTwoTriggers')
              : '...',
          nextChange: hasData
              ? sensor_values.getNextTriggerValue(
                      device, 'powerOutletTwoTriggers', 'outletOn')
                  ? Text('Turn ON')
                  : Text('Turn OFF')
              : Text('...'),
        ));
  }

  OverviewCard _buildFeed(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
      title:
          "Feed ${hasData ? "(${sensor_values.getNumberOfTriggers(device, 'feedTriggers')})" : ""}",
      background: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Text(
                "Last feeding: ${hasData ? sensor_values.getLastTrigger(device, 'feedTriggers') : "..."}"),
            SizedBox(
              height: 10,
            ),
            Text(
                "Next feeding: ${hasData ? sensor_values.getNextTriggerTime(device, 'feedTriggers') : "..."}")
          ],
        ),
      ),
    );
  }

  OverviewCard _buildLED(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
        title:
            "LED ${hasData ? "(${sensor_values.getNumberOfTriggers(device, 'ledTriggers')})" : ""}",
        body: TriggerCardBody(
          icon: hasData && sensor_values.getStateValue(device, 'ledOn')
              ? Icon(Icons.lightbulb,
                  color: Color(sensor_values.getStateValue(device, 'ledColor')))
              : Icon(Icons.lightbulb_outline),
          nextTriggerTime: hasData
              ? sensor_values.getNextTriggerTime(device, 'ledTriggers')
              : '...',
          nextChange: hasData
              ? (sensor_values.getNextTriggerValue(
                          device, 'ledTriggers', 'color') as int ==
                      0)
                  ? Text('Turn OFF')
                  : ClipOval(
                      child: Container(
                          height: 20,
                          width: 20,
                          color: Color((sensor_values.getNextTriggerValue(
                              device, 'ledTriggers', 'color')))),
                    )
              : Text('...'),
        ));
  }

  OverviewCard _buildFan(bool hasData, Map<String, dynamic> device) {
    return OverviewCard(
      title: 'Fan',
      body: CardBody(
        icon: IconRotation(
          icon: FaIcon(FontAwesomeIcons.fan),
          speed: hasData
              ? sensor_values.getStateValue(device, 'fanSpeed') + .0
              : 0.0,
        ),
        children: [
          hasData
              ? Text(
                  "Fan speed: ${sensor_values.getStateValue(device, 'fanSpeed')} %")
              : Text('Fan speed: 0 %')
        ],
      ),
    );
  }

  OverviewCard _buildHeater(bool hasData, Map<String, dynamic> device) {
    var status = '...';
    var type = HeaterType.values[0].text;
    if (hasData) {
      status =
          sensor_values.getStateValue(device, 'waterHeaterOn') ? 'ON' : 'OFF';
      type = HeaterType
          .values[sensor_values.getStateValue(device, 'waterHeaterType')].text;
    }
    return OverviewCard(
      title: 'Heater',
      body: CardBody(
        icon: Icon(Icons.local_fire_department),
        children: [
          Text('Heater status: $status'),
          SizedBox(
            height: 10,
          ),
          Text('Heater type: $type')
        ],
      ),
    );
  }
}
