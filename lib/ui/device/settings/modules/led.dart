import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/modules/led/trigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/ledTriggerTile.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/module.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsExpansionTile.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';
import 'package:vivarium_control_unit/utils/converters.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class LedModuleSettings extends StatefulWidget {
  @override
  _LedModuleSettingsState createState() => _LedModuleSettingsState();
}

class _LedModuleSettingsState extends State<LedModuleSettings> {
  Device? device;

  @override
  void didChangeDependencies() {
    device = Provider.of<DeviceStreamObject>(context, listen: false).device;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return device == null
        ? CircularProgressIndicator()
        : ModuleCard(
            deviceMac: device!.info.macAddress,
            deviceId: device!.info.id,
            moduleKey: LED_CONNECTED,
            connected: device!.state.led!.connected,
            title: 'LED Module',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsDivider(),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Row(
                    children: [
                      Text('Current color:',
                          style: Theme.of(context).textTheme.headline5),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: ColorIndicator(
                          width: 30,
                          height: 30,
                          borderRadius: 4,
                          color: getColorFromInt(device!.state.led!.color),
                          onSelect: () async {
                            final color = device!.state.led!.color;
                            if (!(await colorPickerDialog())) {
                              setState(() {
                                device!.state.led!.color = color;
                              });
                            } else {
                              await Provider.of<DeviceProvider>(context,
                                      listen: false)
                                  .saveValue(
                                      key: LED_COLOR,
                                      value: device!.state.led!.color);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SettingsDivider(),
                SettingsExpansionTile(
                  initiallyExpanded: true,
                  key: PageStorageKey('ledTriggers'),
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
                    if (device!.settings.led?.triggers != null)
                      _ledTriggerList(),
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

  Widget _ledTriggerList() {
    var sortedKeys = device!.settings.led!.triggers.keys.toList()
      ..sort((s1, s2) => device!.settings.led!.triggers[s1]!.time!
          .compareTo(device!.settings.led!.triggers[s2]!.time!));

    return ListView.separated(
      key: PageStorageKey('ledTriggers'),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) => LedTriggerTile(
          key: UniqueKey(),
          trigger: device!.settings.led!.triggers[sortedKeys.elementAt(index)]!,
          ledKey: sortedKeys.elementAt(index),
          onDelete: () => {
                setState(() => device!.settings.led!.triggers
                    .remove(sortedKeys.elementAt(index)))
              },
          onTimeChanged: (time) => setState(() => device!.settings.led!
              .triggers[sortedKeys.elementAt(index)]!.time = time),
          onColorChanged: (color) => setState(() => device!.settings.led!
              .triggers[sortedKeys.elementAt(index)]!.color = color)),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
        thickness: 2,
      ),
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: getColorFromInt(device!.state.led!.color),
      onColorChanged: (Color color) {
        setState(() => device!.state.led!.color = getIntFromColor(color));
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 250,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,

      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      // Showing color code prefix and text styled differently in the dialog.
      colorCodeTextStyle: Theme.of(context).textTheme.bodyText2,
      colorCodePrefixStyle: Theme.of(context).textTheme.caption,
      // Showing the new thumb color property option in dialog version
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.wheel: true,
        ColorPickerType.custom: false,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  void _onAddNewTrigger(Device device) async {
    if (device.settings.led!.triggers.length < 10) {
      var v = LedTrigger(time: 0, color: 0);

      var key = await Provider.of<DeviceProvider>(context, listen: false)
          .pushValue(
              deviceId: device.info.id,
              key: LED_TRIGGERS + '/',
              value: v.toJson());
      if (key != null) {
        setState(() {
          device.settings.led!.triggers.addAll({key: v});
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
