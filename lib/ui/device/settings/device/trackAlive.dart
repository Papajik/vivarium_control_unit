import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class TrackAlive extends StatefulWidget {
  @override
  _TrackAliveState createState() => _TrackAliveState();
}

class _TrackAliveState extends State<TrackAlive> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Consumer2<DeviceProvider, DeviceStreamObject>(
              builder: (context, provider, obj, child) =>  SwitchListTile(
                      title: Text('Track Connection',
                          style: TextStyle(
                              fontSize: 26, color: Colors.cyanAccent)),
                      subtitle: Text(obj.device.settings.general.trackAlive ? 'YES' : 'NO',
                          style: Theme.of(context).textTheme.headline6),
                      value: obj.device.settings.general.trackAlive,
                      onChanged: (value) => setState(() => {
                        obj.device.settings.general.trackAlive = value,
                            Provider.of<DeviceProvider>(context, listen: false)
                                .saveValue(
                                    key: DEVICE_TRACK_ALIVE, value: value)
                          }),
                    )),
        ));
  }
}
