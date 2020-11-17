import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/triggers/waterHeaterType.dart';
import 'package:vivarium_control_unit/models/deviceHistory.dart';
import 'package:vivarium_control_unit/ui/device/overview/animatedChart.dart';
import 'package:vivarium_control_unit/ui/device/overview/iconRotation.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/converters.dart';
import 'package:vivarium_control_unit/utils/firebaseProvider.dart';

class DeviceOverviewSubpage extends StatefulWidget {
  final Device device;

  DeviceOverviewSubpage({Key key, this.device}) : super(key: key);

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
    print('DeviceOverviewSubpage build');

    return StreamBuilder<DocumentSnapshot>(
      stream: deviceHistoryStream(widget.device.info.id),
      builder: (context, deviceHistorySnapshot) {
        return StreamBuilder<DocumentSnapshot>(
          stream: deviceStream(widget.device.info.id),
          builder: (context, deviceSnapshot) {
            var widgets = <Widget>[];
            if (deviceHistorySnapshot.hasData) {
              widgets.addAll(_createHistoryTiles(
                  DeviceHistory.fromJson(deviceHistorySnapshot.data.data())));
            } else {
              widgets.addAll(
                  [SizedBox.shrink(), SizedBox.shrink(), SizedBox.shrink()]);
            }

            if (deviceSnapshot.hasData) {
              widgets.addAll(_createStateTiles(
                  Device.fromJson(deviceSnapshot.data.data())));
            }

            return Scaffold(
                body: Padding(
              padding: EdgeInsets.all(5),
              child: StaggeredGridView.count(
                crossAxisCount: 4,
                staggeredTiles: _staggeredTiles,
                children: widgets,
              ),
            ));
          },
        );
      },
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

  List<Widget> _createHistoryTiles(DeviceHistory deviceHistory) {
    var widgets = <Widget>[];
    widgets.add(OverviewCard(
      title: 'Temperature',
      additionalHeaders: [
        'T1: ${deviceHistory.lastWaterTemperature1} °C',
        'T2: ${deviceHistory.lastWaterTemperature2} °C'
      ],
      body: AnimatedChart(lines: [
        deviceHistory.waterTemperature1History,
        deviceHistory.waterTemperature2History
      ], colors: [
        Colors.red,
        Colors.blue
      ], units: [
        '°C',
        '°C'
      ]),
      key: UniqueKey(),
    ));

    widgets.add(OverviewCard(
        title: 'Water pH',
        additionalHeaders: ['pH: ${deviceHistory.lastWaterPh}'],
        body: AnimatedChart(
            lines: [deviceHistory.waterPhHistory],
            colors: [Colors.red],
            units: ['']),
        key: UniqueKey()));

    widgets.add(OverviewCard(
        title: 'Water level',
        additionalHeaders: ['Level: ${deviceHistory.lastWaterLevel} cm'],
        body: AnimatedChart(
            lines: [deviceHistory.waterLevelHistory],
            colors: [Colors.red],
            units: ['cm']),
        key: UniqueKey()));

    return widgets;
  }

  List<Widget> _createStateTiles(Device device) {
    return <Widget>[
      _buildOutlet1(device),
      _buildOutlet2(device),
      _buildFeed(device),
      _buildLED(device),
      _buildFan(device),
      _buildHeater(device)
    ];
  }

  OverviewCard _buildOutlet1(Device device) {
    var next = device.settings.nextOutletOneTrigger;
    var icon = widget.device.state.powerOutletOneOn
        ? Icon(Icons.power, color: Colors.orangeAccent)
        : Icon(Icons.power_off);

    if (next == null) {
      return OverviewCard(
        title: 'Outlet 1',
        body: TriggerCardBody(
          icon: icon,
          hasTrigger: false,
        ),
      );
    } else {
      return OverviewCard(
          title: 'Outlet 1',
          body: TriggerCardBody(
              icon: icon,
              nextTriggerTime: next.time,
              nextChange: next.outletOn ? Text('Turn ON') : Text('Turn OFF')));
    }
  }

  OverviewCard _buildOutlet2(Device device) {
    var next = device.settings.nextOutletTwoTrigger;
    var icon = widget.device.state.powerOutletOneOn
        ? Icon(Icons.power, color: Colors.orangeAccent)
        : Icon(Icons.power_off);
    if (next == null) {
      return OverviewCard(
        title: 'Outlet 1',
        body: TriggerCardBody(
          icon: icon,
          hasTrigger: false,
        ),
      );
    } else {
      return OverviewCard(
          title: 'Outlet 2',
          body: TriggerCardBody(
              icon: device.state.powerOutletTwoOn
                  ? Icon(Icons.power, color: Colors.orangeAccent)
                  : Icon(Icons.power_off),
              nextTriggerTime: next.time,
              nextChange: next.outletOn ? Text('Turn ON') : Text('Turn OFF')));
    }
  }

  OverviewCard _buildFeed(Device device) {
    var next = device.settings.nextFeedTrigger;
    var last = device.settings.lastFeedTrigger;

    return OverviewCard(
      title: 'Feed (${device.settings.feedTriggers.length.toString()})',
      background: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Text('Last feeding: ${getTimeStringFromTime(last?.time)}'),
            SizedBox(
              height: 10,
            ),
            Text('Next feeding: ${getTimeStringFromTime(next?.time)}')
          ],
        ),
      ),
    );
  }

  OverviewCard _buildLED(Device device) {
    var next = device.settings.nextLedTrigger;

    return OverviewCard(
        title: 'Feed (${device.settings.ledTriggers.length.toString()})',
        body: TriggerCardBody(
          icon: device.state.ledOn
              ? Icon(Icons.lightbulb,
                  color: Color(device.state.currentLedColor))
              : Icon(Icons.lightbulb_outline),
          nextTriggerTime: next.time,
          nextChange: next.color == 0
              ? Text('Turn OFF')
              : ClipOval(
                  child: Container(
                      height: 20, width: 20, color: Color(next.color)),
                ),
        ));
  }

  OverviewCard _buildFan(Device device) {
    return OverviewCard(
      title: 'Fan',
      body: CardBody(
        icon: IconRotation(
          icon: FaIcon(FontAwesomeIcons.fan),
          speed: device.state.fanSpeed,
        ),
        children: [Text('Fan speed: ${device.state.fanSpeed.toString()} %')],
      ),
    );
  }

  OverviewCard _buildHeater(Device device) {
    return OverviewCard(
      title: 'Heater',
      body: CardBody(
        icon: Icon(Icons.local_fire_department),
        children: [
          Text('Heater status: ${device.state.heaterOn ? 'ON' : 'OFF'}'),
          SizedBox(
            height: 10,
          ),
          Text('Heater type: ${device.state.waterHeaterType.text}')
        ],
      ),
    );
  }
}
