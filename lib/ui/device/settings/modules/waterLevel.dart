import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

class WaterLevelModuleSettings extends StatefulWidget {
  @override
  _WaterLevelModuleSettingsState createState() =>
      _WaterLevelModuleSettingsState();
}

class _WaterLevelModuleSettingsState extends State<WaterLevelModuleSettings> {
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
    if (device == null) {
      return CircularProgressIndicator();
    } else {
      return ModuleCard(
        deviceMac: device!.info.macAddress,
        deviceId: device!.info.id,
        moduleKey: WL_CONNECTED,
        connected: device!.state.waterLevel!.connected,
        title: 'Water Level Module',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsDivider(),
            SettingsSlider(
              title: 'Sensor height',
              value: device!.settings.waterLevel!.sensorHeight,
              providerKey: WL_SENSOR_HEIGHT,
              onChangeEnd: (value) => setState(
                  () => device!.settings.waterLevel!.sensorHeight = value!),
              onChanged: (value) {},
              lowLimit: device!.settings.waterLevel!.maxLevel,
              division: 95,
              min: 5,
              max: 100,
              upLimit: 100,
            ),
            SettingsDivider(),
            SettingsSlider(
                title: 'Max level',
                value: device!.settings.waterLevel!.maxLevel,
                providerKey: WL_MAX_L,
                onChangeEnd: (value) => setState(
                    () => device!.settings.waterLevel!.maxLevel = value!),
                onChanged: (value) {},
                lowLimit: device!.settings.waterLevel!.minLevel,
                upLimit: device!.settings.waterLevel!.sensorHeight,
                division: 95,
                min: 5,
                max: 100),
            SettingsDivider(),
            SettingsSlider(
              title: '´Min level',
              value: device!.settings.waterLevel!.minLevel,
              providerKey: WL_MIN_L,
              onChangeEnd: (value) => setState(
                  () => device!.settings.waterLevel!.minLevel = value!),
              onChanged: (value) {},
              upLimit: device!.settings.waterLevel!.maxLevel,
              division: 95,
              min: 5,
              max: 100,
              lowLimit: 5,
            ),
          ],
        ),
      );
    }
  }
}
