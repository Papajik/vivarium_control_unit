import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

class DhtModuleSettings extends StatefulWidget {
  @override
  _DhtModuleSettingsState createState() => _DhtModuleSettingsState();
}

class _DhtModuleSettingsState extends State<DhtModuleSettings> {
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
            moduleKey: DHT_CONNECTED,
            connected: device!.state.dht!.connected,
            title: 'DHT Module',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsDivider(),
                SettingsSlider(
                    providerKey: DHT_MAX_HUM,
                    title: 'Max humidity',
                    value: device!.settings.dht!.maxHum,
                    lowLimit: device!.settings.dht!.minHum,
                    upLimit: 100,
                    onChangeEnd: (value) =>
                        setState(() => device!.settings.dht!.maxHum = value!),
                    max: 100,
                    min: 0,
                    division: 100),
                SettingsDivider(),
                SettingsSlider(
                    providerKey: DHT_MIN_HUM,
                    title: 'Min humidity',
                    lowLimit: 0,
                    value: device!.settings.dht!.minHum,
                    upLimit: device!.settings.dht!.maxHum,
                    onChangeEnd: (value) =>
                        setState(() => device!.settings.dht!.minHum = value!),
                    max: 100,
                    min: 0,
                    division: 100),
                SettingsDivider(),
                SettingsSlider(
                    providerKey: DHT_MAX_TEMP,
                    title: 'Max temperature',
                    value: device!.settings.dht!.maxTemp,
                    lowLimit: device!.settings.dht!.minTemp,
                    upLimit: 100,
                    onChangeEnd: (value) =>
                        setState(() => device!.settings.dht!.maxTemp = value!),
                    max: 100,
                    min: 0,
                    division: 100),
                SettingsDivider(),
                SettingsSlider(
                    providerKey: DHT_MIN_TEMP,
                    title: 'Min temperature',
                    value: device!.settings.dht!.minTemp,
                    upLimit: device!.settings.dht!.maxTemp,
                    onChangeEnd: (value) =>
                        setState(() => device!.settings.dht!.minTemp = value!),
                    max: 100,
                    lowLimit: 0,
                    min: 0,
                    division: 100),
                SettingsDivider()
              ],
            ),
          );
  }
}
