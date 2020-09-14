import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device.dart';

class DeviceViewSubpage extends StatefulWidget {
  final Device device;
  final String userId;

  DeviceViewSubpage({Key key, this.device, this.userId})
      : super(key: key);

  @override
  _DeviceViewSubpageState createState() => _DeviceViewSubpageState();
}

class _DeviceViewSubpageState extends State<DeviceViewSubpage> {
  @override
  Widget build(BuildContext context) {
    print("building image widget");
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: NetworkImage(widget.device.camera.address),
        key: ValueKey(new Random().nextInt(1000)),
        fit: BoxFit.cover
      )
    );
  }

}