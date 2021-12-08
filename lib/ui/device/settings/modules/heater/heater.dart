import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/advancedSettings/advancedArguments.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/trigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsDropdown.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsExpansionTile.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

import 'heaterTriggerTile.dart';

class HeaterModuleSettings extends StatefulWidget {
  @override
  _HeaterModuleSettingsState createState() => _HeaterModuleSettingsState();
}

class _HeaterModuleSettingsState extends State<HeaterModuleSettings> {
  Device? device;
  bool goalVisible = false;
  bool directPowerVisible = false;
  bool learnVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    device ??= Provider.of<DeviceStreamObject>(context, listen: false).device;
    goalVisible = device!.settings.heater!.isInternal;
    directPowerVisible = device!.settings.heater!.isDirect;
    learnVisible =
        !device!.state.heater!.tuning && device!.settings.heater!.isPID;
    print('LearnVisible = $learnVisible');
    print('tuning = ${!device!.state.heater!.tuning}');
    print('isPID = ${device!.settings.heater!.isPID}');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return device == null
        ? CircularProgressIndicator()
        : ModuleCard(
            deviceMac: device!.info.macAddress,
            deviceId: device!.info.id,
            moduleKey: HEATER_CONNECTED,
            connected: device!.state.heater!.connected,
            title: 'Heater Module',
            child: Consumer<DeviceProvider>(
              builder: (context, provider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsDivider(),
                  SettingsDropdown(
                    title: 'Mode',
                    items: SettingsHeater.modeValues,
                    providerKey: HEATER_MODE,
                    value: device!.settings.heater!.mode,
                    onChanged: (value) => setState(() {
                      directPowerVisible = SettingsHeater.isModeDirect(value!);
                      goalVisible = SettingsHeater.isModeInternal(value);
                      learnVisible = SettingsHeater.isModeAutomatic(value) &
                          !device!.state.heater!.tuning;
                    }),
                  ),
                  Visibility(
                    visible: learnVisible,
                    child: Column(
                      children: [
                        SettingsDivider(),
                        ElevatedButton.icon(
                            icon: Icon(Icons.tune),
                            label: Text('Go to Tuning Settings'),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                  context, Routes.pidTuning,
                                  arguments: AdvancedSettingsPageArguments(
                                      device: device!,
                                      bluetoothConnector:
                                          Provider.of<BluetoothConnector>(
                                              context,
                                              listen: false),
                                      deviceProvider:
                                          Provider.of<DeviceProvider>(context,
                                              listen: false)));
                            })
                      ],
                    ),
                  ),
                  SettingsDivider(),
                  Visibility(
                    visible: directPowerVisible,
                    child: SettingsSlider(
                      title: 'Power',
                      value: device!.settings.heater!.directPower,
                      providerKey: HEATER_DIRECT_POWER,
                      onChangeEnd: (value) => setState(
                          () => device!.settings.heater!.directPower = value!),
                      division: 200,
                      min: 0,
                      max: 100,
                      lowLimit: 0,
                      upLimit: 100,
                    ),
                  ),
                  SettingsDivider(),
                  Visibility(
                    visible: goalVisible,
                    child: SettingsSlider(
                      title: 'Temp Goal',
                      value: device!.state.heater!.goal,
                      providerKey: HEATER_GOAL,
                      onChangeEnd: (value) =>
                          setState(() => device!.state.heater!.goal = value!),
                      division: 60,
                      min: 5,
                      max: 35,
                      lowLimit: 5,
                      upLimit: 35,
                    ),
                  ),
                  SettingsDivider(),
                  SettingsExpansionTile(
                    initiallyExpanded: true,
                    key: PageStorageKey('heaterTriggers'),
                    iconColor: Colors.white,
                    title: Text('Triggers',
                        style: Theme.of(context).textTheme.headline4),
                    children: [
                      SettingsDivider(
                        color: Colors.white,
                        height: 2,
                        thickness: 2,
                        indent: 20,
                        endIndent: 50,
                      ),
                      if (device!.settings.heater?.triggers != null)
                        _heaterTriggerList(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              label: Text('Add new Trigger'),
                              onPressed: () => _onAddNewTrigger(device!)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  Widget _heaterTriggerList() {
    var sortedKeys = device!.settings.heater!.triggers.keys.toList()
      ..sort((s1, s2) => device!.settings.heater!.triggers[s1]!.time
          .compareTo(device!.settings.heater!.triggers[s2]!.time));

    return ListView.separated(
      key: PageStorageKey('heaterTriggers'),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) => HeaterTriggerTile(
          key: UniqueKey(),
          trigger:
              device!.settings.heater!.triggers[sortedKeys.elementAt(index)],
          heaterKey: sortedKeys.elementAt(index),
          onDelete: () => {
                setState(() => device!.settings.heater!.triggers
                    .remove(sortedKeys.elementAt(index)))
              },
          onTimeChanged: (time) => setState(() => device!.settings.heater!
              .triggers[sortedKeys.elementAt(index)]!.time = time),
          onGoalChanged: (goal) => setState(() => device!.settings.heater!
              .triggers[sortedKeys.elementAt(index)]!.goal = goal)),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
        thickness: 2,
      ),
    );
  }

  void _onAddNewTrigger(Device device) async {
    if (device.settings.led!.triggers.length < 10) {
      var v = HeaterTrigger(time: 0, goal: 15);

      var key = await Provider.of<DeviceProvider>(context, listen: false)
          .pushValue(
              deviceId: device.info.id,
              key: HEATER_TRIGGERS + '/',
              value: v.toJson());
      if (key != null) {
        setState(() {
          device.settings.heater!.triggers.addAll({key: v});
        });
      }
    } else {
      await Fluttertoast.showToast(
          msg: 'Max 10 triggers allowed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
