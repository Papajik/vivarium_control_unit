import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/devices/deviceCard.dart';

class DeviceList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
            maxWidth: 600),
        child: Consumer<List<Device>>(
          builder: (context, devices, child) => ListView.separated(
            itemCount: devices.length,
            itemBuilder: (context, index) => DeviceCard(
              device: devices.elementAt(index),
            ),
            separatorBuilder: (context, index) => Container(height: 20),
          ),
        ),
      ),
    );
  }
}
