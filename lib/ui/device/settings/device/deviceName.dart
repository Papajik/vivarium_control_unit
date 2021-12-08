import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/common/styles.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class DeviceName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Consumer2<DeviceProvider, DeviceStreamObject>(
            builder: (context, provider, deviceObj, child) => TextFormField(
              style: TextStyle(color: Colors.white, fontSize: 18),
              onFieldSubmitted: (value) async {
                FocusScope.of(context).unfocus();
                await provider.saveValue(key: DEVICE_NAME, value: value);
              },
              decoration: inputDecoration('Device Name', fontSize: 35),
              initialValue: deviceObj.device.info.name,
            ),
          ),
        ));
  }
}
