import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/router.dart';

class DeviceCard extends StatelessWidget {
  final Device device;

  const DeviceCard({Key? key, required this.device}) : super(key: key);

  Color getColor(Device device) {
    if (!device.settings.general.trackAlive) return Colors.grey.shade500;
    if (device.isAlive) {
      return Colors.green.shade500;
    } else {
      return Colors.red.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
            title: Text(device.info.name,
                style: Theme.of(context).textTheme.headline4),
            subtitle: Text(
              device.info.id,
              style: Theme.of(context).textTheme.headline6,
            ),
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(Icons.circle, color: getColor(device), size: 20),
            ),
            onTap: () => Navigator.pushNamed(context, Routes.device,
                arguments: device)),
      ),
    );
  }
}
