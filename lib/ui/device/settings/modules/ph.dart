import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class PhModuleSettings extends StatefulWidget {
  @override
  _PhModuleSettingsState createState() => _PhModuleSettingsState();
}

class _PhModuleSettingsState extends State<PhModuleSettings> {
  Device? device;
  bool? continuous;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    device ??= Provider.of<DeviceStreamObject>(context, listen: false).device;
    continuous = device!.settings.ph!.continuous;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return device == null
        ? CircularProgressIndicator()
        : ModuleCard(
            deviceMac: device!.info.macAddress,
            deviceId: device!.info.id,
            moduleKey: PH_CONNECTED,
            connected: device!.state.ph!.connected,
            title: 'pH Module',
            child: Consumer<DeviceProvider>(
              builder: (context, provider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _divider(),

                  /// Max PH
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Max Ph: ',
                            style: Theme.of(context).textTheme.headline5),
                        Text(device!.settings.ph!.maxPh.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ),
                  Slider(
                    onChanged: (double? value) {
                      setState(() {
                        if (value! < device!.settings.ph!.minPh) {
                          value = device!.settings.ph!.minPh;
                        }
                        device!.settings.ph!.maxPh = value!;
                      });
                    },
                    onChangeEnd: (value) {
                      provider.saveValue(
                          key: PH_MAX,
                          value: double.parse(
                              device!.settings.ph!.maxPh.toStringAsFixed(1)));
                    },
                    value: device!.settings.ph!.maxPh,
                    max: 14,
                    min: 0,
                    divisions: 70,
                    label: device!.settings.ph!.maxPh.toStringAsFixed(1),
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                  ),
                  _divider(),

                  /// Min PH
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Min Ph: ',
                            style: Theme.of(context).textTheme.headline5),
                        Text(device!.settings.ph!.minPh.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ),
                  Slider(
                    onChanged: (double? value) {
                      setState(() {
                        if (value! > device!.settings.ph!.maxPh) {
                          value = device!.settings.ph!.maxPh;
                        }
                        device!.settings.ph!.minPh = value!;
                      });
                    },
                    onChangeEnd: (value) {
                      provider.saveValue(
                          key: PH_MIN,
                          value: double.parse(
                              device!.settings.ph!.minPh.toStringAsFixed(1)));
                    },
                    value: device!.settings.ph!.minPh,
                    max: 14,
                    min: 0,
                    divisions: 70,
                    label: device!.settings.ph!.minPh.toStringAsFixed(1),
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                  ),
                  _divider(),
                  SwitchListTile(
                    title: Text('Continuous',
                        style: Theme.of(context).textTheme.headline5),
                    onChanged: (bool value) {
                      setState(() {
                        continuous = value;
                      });
                      provider.saveValue(
                          key: PH_CONTINUOUS,
                          value: value);
                    },
                    value: continuous!,
                  ),
                  _divider(),
                  Visibility(
                    visible: continuous!,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delay between scans: ',
                                  style: Theme.of(context).textTheme.headline5),
                              Text(device!.settings.ph!.continuousDelay.toString(),
                                  style: Theme.of(context).textTheme.headline5),
                            ],
                          ),
                        ),
                        Slider(
                          onChanged: (double value) {
                            setState(() {
                              device!.settings.ph!.continuousDelay = value.truncate();
                            });
                          },
                          onChangeEnd: (value) {
                            provider.saveValue(
                                key: PH_CONTINUOUS_DELAY,
                                value: device!.settings.ph!.continuousDelay);
                          },
                          value: device!.settings.ph!.continuousDelay.toDouble(),
                          max: 100,
                          min: 5,
                          divisions: 70,
                          label: device!.settings.ph!.continuousDelay.toString(),
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Divider _divider() {
    return Divider(
      height: 35,
    );
  }
}
