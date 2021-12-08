import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/modules/feeder/settings.dart';
import 'package:vivarium_control_unit/models/device/modules/feeder/trigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/feederTriggerTile.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsDropdown.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsExpansionTile.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class FeederModuleSettings extends StatefulWidget {
  @override
  _FeederModuleSettingsState createState() => _FeederModuleSettingsState();
}

class _FeederModuleSettingsState extends State<FeederModuleSettings> {
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
    var sortedKeys = device!.settings.feeder!.triggers.keys.toList()
      ..sort((s1, s2) => device!.settings.feeder!.triggers[s1]!.time!
          .compareTo(device!.settings.feeder!.triggers[s2]!.time!));

    return device == null
        ? CircularProgressIndicator()
        : ModuleCard(
            deviceMac: device!.info.macAddress,
            deviceId: device!.info.id,
            moduleKey: FEEDER_CONNECTED,
            connected: device!.state.feeder!.connected,
            title: 'Feeder Module',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsDropdown(
                  items: modeValues,
                  value: device!.settings.feeder!.type,
                  title: 'Mode',
                  providerKey: FEEDER_MODE,
                ),
                SettingsDivider(),
                SettingsExpansionTile(
                  initiallyExpanded: true,
                  key: PageStorageKey('feedTriggers'),
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
                    ListView.separated(
                      key: PageStorageKey('feedTriggers'),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: device!.settings.feeder!.triggers.length,
                      itemBuilder: (context, index) => FeederTriggerTile(
                        key: UniqueKey(),
                        trigger: device!.settings.feeder!
                            .triggers[sortedKeys.elementAt(index)],
                        feederKey: sortedKeys.elementAt(index),
                        onDelete: () => {
                          setState(() => device!.settings.feeder!.triggers
                              .remove(sortedKeys.elementAt(index)))
                        },
                        onChanged: (time) => setState(() => device!
                            .settings
                            .feeder!
                            .triggers[sortedKeys.elementAt(index)]!
                            .time = time),
                      ),
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                    ),
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
          );
  }

  void _onAddNewTrigger(Device device) async {
    if (device.settings.feeder!.triggers.length < 10) {
      var v = FeedTrigger(time: 0);
      var key = await Provider.of<DeviceProvider>(context, listen: false)
          .pushValue(
              deviceId: device.info.id,
              key: FEEDER_TRIGGERS + '/',
              value: v.toJson());
      if (key != null) {
        setState(() {
          device.settings.feeder!.triggers.addAll({key: v});
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
