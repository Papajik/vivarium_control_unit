import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class OutletSettings extends StatefulWidget {
  @override
  _OutletSettingsState createState() => _OutletSettingsState();
}

class _OutletSettingsState extends State<OutletSettings> {
  late Device _device;

  @override
  void initState() {
    _device = Provider.of<DeviceStreamObject>(context, listen: false).device;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_device.state.outlet!.outlets[0].isAvailable!)
          _createCard(0, OUTLET_0),
        if (_device.state.outlet!.outlets[1].isAvailable!)
          _createCard(1, OUTLET_1),
        if (_device.state.outlet!.outlets[2].isAvailable!)
          _createCard(2, OUTLET_2),
        if (_device.state.outlet!.outlets[3].isAvailable!)
          _createCard(3, OUTLET_3)
      ],
    );
  }

  Widget _createCard(int index, String key) {
    return Card(
      color: Colors.black26,
      child: SwitchListTile(
        title: Text('Outlet ' + index.toString(),
            style: TextStyle(fontSize: 26, color: Colors.cyanAccent)),
        subtitle: Text(
            _device.state.outlet!.outlets[index].isOn! ? 'ON' : 'OFF',
            style: Theme.of(context).textTheme.headline6),
        value: _device.state.outlet!.outlets[index].isOn!,
        onChanged: (value) => setState(() => {
              _device.state.outlet!.outlets[index].isOn = value,
              Provider.of<DeviceProvider>(context, listen: false)
                  .saveValue(key: key, value: value)
            }),
      ),
    );
  }
}
