import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as SettingsScreen;
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/ui/device/feedTriggerDialog.dart';
import 'package:vivarium_control_unit/ui/device/settingsFeedList.dart';
import 'package:vivarium_control_unit/utils/cloudSettingsConverter.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class DeviceSettingsSubpage extends StatefulWidget {
  final String deviceId;
  final String userId;
  final BluetoothDevice device;
  @required
  final bool useCloud;

  DeviceSettingsSubpage(
      {Key key, this.deviceId, this.userId, this.device, this.useCloud})
      : super(key: key);

  @override
  _DeviceSettingsSubpageState createState() => _DeviceSettingsSubpageState();
}

class _DeviceSettingsSubpageState extends State<DeviceSettingsSubpage> {
  SettingsConverter _settingsConverter;

  bool _change = false;
  bool _default = true;

  @override
  void initState() {
    super.initState();
    _settingsConverter = new SettingsConverter(
        deviceId: widget.deviceId, userId: widget.userId);
    if (widget.useCloud) {
      _settingsConverter.loadSettingsFromCloud().then((val) => {
            setState(() {
              print("loaded from cloud");
            })
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _createSettingList();
  }

  Widget _createSettingList() {
    return Column(
      children: [
        Expanded(
            child: ListView(
              children: [
                _createWaterLevelGroup(),
                //_createLedGroup(),
                _createFeederGroup(),
                //_createWaterTemperatureGroup(),
                //_createWaterPHGroup(),
                //_createTimeGroup(),
                //_createTest2()
              ],
            )),
        //createButton()
      ],
    );
  }

  Widget createButton(){
    return SettingsScreen.SettingsContainer(
      children: [
        RaisedButton(
            child: Text("upload settings"),
            onPressed: _change
                ? () {
              _settingsConverter.saveSettingsToCloud();
              setState(() {
                _change = false;
              });
            }
                : null)
      ],
    );
  }


  Future<bool> _saveToDevice() async {
    if (widget.device == null) return false;
    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase().substring(4, 8) ==
          Constants.of(context).bleService) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase().substring(4, 8) ==
              Constants.of(context).bleCharacteristic) {
            //TODO add Flutter - Arduino communication
          }
        });
      }
    });
    return true;
  }

  _getDeviceCharacteristic() {
    print("settings subpage: set characteristic");
    widget.device.discoverServices().then((services) => {
          services.forEach((service) {
            print(service.uuid);
            if (service.uuid.toString().toUpperCase().substring(4, 8) ==
                Constants.of(context).bleService) {
              print("settings subpage: characteristics:");
              service.characteristics.forEach((characteristic) {
                if (characteristic.uuid
                        .toString()
                        .toUpperCase()
                        .substring(4, 8) ==
                    Constants.of(context).bleCharacteristic) {
                  print(characteristic);
                  setState(() {
                    //_characteristic = characteristic;
                  });
                }
              });
            }
          })
        });
  }


  _createWaterLevelGroup() {
    return SettingsScreen.SettingsGroup(
      title: Constants.of(context).settingsWaterLevelTitle,
      children: [
        SettingsScreen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelSensorHeight,
          initialValue: _settingsConverter.getValueFromBox(widget.deviceId + WATER_LEVEL_SENSOR_HEIGHT),
          settingKey: widget.deviceId + WATER_LEVEL_SENSOR_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return int.tryParse(height) != null ? null : "Input must be number";
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async {
            await _settingsConverter.saveItemToCloud(WATER_LEVEL_SENSOR_HEIGHT, int.parse(val)); //TODO add logic on failed update
          },
        ),
        SettingsScreen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelMaxHeight,
          initialValue: _settingsConverter.getValueFromBox(widget.deviceId + WATER_LEVEL_MAX_HEIGHT),
          settingKey: widget.deviceId + WATER_LEVEL_MAX_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return validateMaxWaterLevel(height);
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async {
             await _settingsConverter.saveItemToCloud(WATER_LEVEL_MAX_HEIGHT, int.parse(val)); //TODO add logic on failed update
          },
        ),
        SettingsScreen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelMinHeight,
          initialValue: _settingsConverter.getValueFromBox(widget.deviceId + WATER_LEVEL_MIN_HEIGHT),
          settingKey: widget.deviceId + WATER_LEVEL_MIN_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return validateMinWaterLevel(height);
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async {
            await _settingsConverter.saveItemToCloud(WATER_LEVEL_MIN_HEIGHT, int.parse(val)); //TODO add logic on failed update
          },
        )
      ],
    );
  }

  _createLedGroup() {
    return SettingsScreen.SettingsGroup(
      title: "LED",
      children: [
        SettingsScreen.ColorPickerSettingsTile(
          title: "Current color",
          settingKey: widget.deviceId + LED_CURRENT_COLOR,
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: LED_IS_ON,
          title: "Lights on",
        ),
        SettingsScreen.ExpandableSettingsTile(
          title: "LED Triggers",
          children: [],
        )
      ],
    );
  }

  _createFeederGroup() {
    return SettingsScreen.SettingsGroup(
      title: "Feeder",
      children: [
        SettingsScreen.ExpandableSettingsTile(
          title: "Feeding times",
          children: [
            SettingsFeedList(
              deviceId: widget.deviceId,
              onChanged: (val) async {
                await _settingsConverter.saveItemToCloud(FEED_TRIGGERS,_settingsConverter.getFeedTriggers().map((e) => e.toJson()).toList());
                setState(() {
                    print("settingsSubpage changing state");
                });
              },
            ),

          ],
        )
      ],
    );
  }

  _createWaterTemperatureGroup() {
    return SettingsScreen.SettingsGroup(
      title: "Water temperature",
      children: [
        SettingsScreen.SliderSettingsTile(
            title: "Optimal temperature",
            settingKey: widget.deviceId + "-water-optimal-temperature",
            min: 15,
            max: 35,
            defaultValue: 15,
            step: 0.1),
        SettingsScreen.SimpleRadioSettingsTile(
          title: "Heater mode",
          settingKey: widget.deviceId + "-water-heater-mode",
          selected: 'PID',
          values: ['PID', 'AUTO'],
        )
      ],
    );
  }

  _createWaterPHGroup() {
    return SettingsScreen.SettingsGroup(
      title: "Water PH ",
      children: [
        SettingsScreen.TextInputSettingsTile(
          title: "Max PH",
          settingKey: widget.deviceId + "-water-ph-max",
        ),
        SettingsScreen.TextInputSettingsTile(
          title: "Min PH",
          settingKey: widget.deviceId + "-water-ph-min",
        )
      ],
    );
  }

  _createTimeGroup() {
    return SettingsScreen.SettingsGroup(
      title: "Time",
      children: [],
    );
  }

  _createTest() {
    return SettingsScreen.ExpandableSettingsTile(
      title: 'Quick setting 2',
      subtitle: 'Expandable Settings',
      children: <Widget>[
        SettingsScreen.CheckboxSettingsTile(
          settingKey: 'key-day-light-savings-2',
          title: 'Daylight Time Saving',
          enabledLabel: 'Enabled',
          disabledLabel: 'Disabled',
          leading: Icon(Icons.timelapse),
          onChange: (value) {
            debugPrint('key-day-light-savings-2: $value');
          },
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: 'key-dark-mode-2',
          title: 'Dark Mode',
          enabledLabel: 'Enabled',
          disabledLabel: 'Disabled',
          leading: Icon(Icons.palette),
          onChange: (value) {
            debugPrint('key-dark-mode-2: $value');
          },
        ),
      ],
    );
  }

  _createTest2() {
    return SettingsScreen.ModalSettingsTile(
      title: 'Quick setting dialog',
      subtitle: 'Settings on a dialog',
      children: <Widget>[
        SettingsScreen.CheckboxSettingsTile(
          settingKey: 'key-day-light-savings',
          title: 'Daylight Time Saving',
          enabledLabel: 'Enabled',
          disabledLabel: 'Disabled',
          leading: Icon(Icons.timelapse),
          onChange: (value) {
            debugPrint('key-day-light-saving: $value');
          },
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: 'key-dark-mode',
          title: 'Dark Mode',
          enabledLabel: 'Enabled',
          disabledLabel: 'Disabled',
          leading: Icon(Icons.palette),
          onChange: (value) {
            debugPrint('jey-dark-mode: $value');
          },
        ),
      ],
    );
  }


  validateMaxWaterLevel(String height) {
    if (int.tryParse(height) == null) return "Input must be number";
    int max = int.parse(height);
    String min = SettingsScreen.Settings.getValue(
        widget.deviceId + WATER_LEVEL_MIN_HEIGHT, height);
    if (min == null || min.isEmpty) return null;
    if (int.parse(min) > max) {
      return "Maximum < minimum (" + min + ")";
    }
    String sensorHeight = SettingsScreen.Settings.getValue(
        widget.deviceId + WATER_LEVEL_SENSOR_HEIGHT, height);
    if (int.parse(sensorHeight) < max) {
      return "Maximum > Height (" + height + ")";
    }
    return null;
  }

  validateMinWaterLevel(String height) {
    if (int.tryParse(height) == null) return "Input must be number";
    int min = int.parse(height);
    String max = SettingsScreen.Settings.getValue(
        widget.deviceId + WATER_LEVEL_MAX_HEIGHT, height);
    if (max == null || max.isEmpty) return null;
    if (int.parse(max) < min) {
      return "Minimum > maximum (" + max + ")";
    }
    return null;
  }
}
