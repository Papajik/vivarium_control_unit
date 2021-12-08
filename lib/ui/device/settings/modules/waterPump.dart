import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

class WaterPumpModuleSettings extends StatefulWidget {
  @override
  _WaterPumpModuleSettingsState createState() =>
      _WaterPumpModuleSettingsState();
}

class _WaterPumpModuleSettingsState extends State<WaterPumpModuleSettings> {
  Device? device;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    device ??= Provider.of<DeviceStreamObject>(context, listen: false).device;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return device == null
        ? CircularProgressIndicator()
        : ModuleCard(
            deviceMac: device!.info.macAddress,
            deviceId: device!.info.id,
            moduleKey: WP_CONNECTED,
            connected: device!.state.pump!.connected,
            title: 'Water Pump Module',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsDivider(),
                SettingsSlider(
                  title: 'Target level',
                  value: device!.settings.pump!.goalLevel,
                  providerKey: WP_GOAL,
                  onChangeEnd: (value) =>
                      setState(() => device!.settings.pump!.goalLevel = value!),
                  onChanged: (value) {},
                  division: 95,
                  min: 5,
                  max: 100,
                  upLimit: 100,
                  lowLimit: 5,
                ),
              ],
            ),
          );
  }
}
