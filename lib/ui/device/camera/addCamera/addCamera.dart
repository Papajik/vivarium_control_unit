import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/router.dart';

class AddCameraCard extends StatefulWidget {
  @override
  _AddCameraCardState createState() => _AddCameraCardState();
}

class _AddCameraCardState extends State<AddCameraCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          onPressed: () => Navigator.pushNamed(context, Routes.addCameraList, arguments: Provider.of<DeviceStreamObject>(context, listen: false).device.info.id),
          child: Text('Add new camera')),
    );
  }
}
