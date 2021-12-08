import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

class FanModuleSettings extends StatefulWidget {
  @override
  _FanModuleSettingsState createState() => _FanModuleSettingsState();
}

class _FanModuleSettingsState extends State<FanModuleSettings> {
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
            moduleKey: FAN_CONNECTED,
            connected: device!.state.fan!.connected,
            title: 'Fan Module',
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsDivider(),
                  SettingsSlider(
                    lowLimit: 5,
                    title: 'Start at...',
                    value: device!.settings.fan!.startAt,
                    providerKey: FAN_START_AT,
                    onChangeEnd: (value) =>
                        setState(() => device!.settings.fan!.startAt = value!),
                    onChanged: (value) {},
                    upLimit: device!.settings.fan!.maxAt,
                    division: 70,
                    min: 5,
                    max: 40,
                  ),
                  SettingsDivider(),
                  SettingsSlider(
                    title: 'Max at...',
                    value: device!.settings.fan!.maxAt,
                    providerKey: FAN_MAX_AT,
                    onChangeEnd: (value) =>
                        setState(() => device!.settings.fan!.maxAt = value!),
                    lowLimit: device!.settings.fan!.startAt,
                    division: 70,
                    min: 5,
                    max: 40,
                    upLimit: 40,
                  ),
                ],
              ),
            );
  }
}
