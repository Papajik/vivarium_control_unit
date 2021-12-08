import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

class WaterTempModuleSettings extends StatefulWidget {
  @override
  _WaterTempModuleSettingsState createState() =>
      _WaterTempModuleSettingsState();
}

class _WaterTempModuleSettingsState extends State<WaterTempModuleSettings> {
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
            moduleKey: WT_CONNECTED,
            connected: device!.state.waterTemp!.connected,
            title: 'Water Temp Module',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsDivider(),
                SettingsSlider(
                  providerKey: WT_MAX_TEMP,
                  title: 'Max temperature',
                  value: device!.settings.waterTemp!.maxTemp,
                  lowLimit: device!.settings.waterTemp!.minTemp,
                  onChangeEnd: (value) => setState(
                      () => device!.settings.waterTemp!.maxTemp = value!),
                  max: 35,
                  min: 5,
                  division: 60,
                  upLimit: 35,
                ),
                SettingsDivider(),
                SettingsSlider(
                  providerKey: WT_MIN_TEMP,
                  title: 'Min temperature',
                  value: device!.settings.waterTemp!.minTemp,
                  upLimit: device!.settings.waterTemp!.maxTemp,
                  onChangeEnd: (value) => setState(
                      () => device!.settings.waterTemp!.minTemp = value!),
                  max: 35,
                  min: 5,
                  division: 60,
                  lowLimit: 5,
                ),
                SettingsDivider(),
              ],
            ),
          );
  }
}
