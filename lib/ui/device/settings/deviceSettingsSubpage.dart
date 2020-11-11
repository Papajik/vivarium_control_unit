import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as SettingsScreen;
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/waterHeaterType.dart';
import 'package:vivarium_control_unit/ui/device/settings/feedTriggerList.dart';
import 'package:vivarium_control_unit/ui/device/settings/ledTriggerList.dart';
import 'package:vivarium_control_unit/ui/device/settings/outletTriggerList.dart';
import 'package:vivarium_control_unit/utils/bluetoothProvider.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';
import 'package:vivarium_control_unit/utils/settingsConverter.dart';

class DeviceSettingsSubpage extends StatefulWidget {
  final String deviceId;
  final String userId;
  final BluetoothHandler bluetoothHandler;
  @required
  final bool useCloud;

  DeviceSettingsSubpage(
      {Key key,
      this.deviceId,
      this.userId,
      this.bluetoothHandler,
      this.useCloud})
      : super(key: key);

  @override
  _DeviceSettingsSubpageState createState() => _DeviceSettingsSubpageState();
}

class _DeviceSettingsSubpageState extends State<DeviceSettingsSubpage> {
  SettingsConverter _settingsConverter;
  bool sendingToBluetooth = false;

  @override
  void initState() {
    super.initState();
    _settingsConverter =
        new SettingsConverter(deviceId: widget.deviceId, userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _createSettingList();
  }

  Widget _createSettingList() {
    return FutureBuilder(
      future: _settingsConverter.loadSettingsFromCloud(),

      ///TODO load settings for whole device page, not only settings
      builder: (context, snapshot) {
        print("Settings Subpage - builder = Has data = " +
            snapshot.hasData.toString());
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return createColumns();
      },
    );
  }

  Widget createColumns() {
    return Column(
      children: [
        _createDirectSaveButton(),
        Expanded(
            child: ListView(
          children: [
            _createWaterLevelGroup(),
            _createLedGroup(),
            _createFeederGroup(),
            _createWaterTemperatureGroup(),
            _createWaterPHGroup(),
            _createOutletsGroup()
          ],
        )),
      ],
    );
  }

  _createWaterLevelGroup() {
    return SettingsScreen.SettingsGroup(
      title: Constants.of(context).settingsWaterLevelTitle,
      children: [
        SettingsScreen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelSensorHeight,
          initialValue: _settingsConverter
              .getValueFromBox(widget.deviceId + WATER_LEVEL_SENSOR_HEIGHT),
          settingKey: widget.deviceId + WATER_LEVEL_SENSOR_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return int.tryParse(height) != null ? null : "Input must be number";
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async => await _settingsConverter.saveItem(
              WATER_LEVEL_SENSOR_HEIGHT, int.parse(val)),
        ),
        SettingsScreen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelMaxHeight,
          initialValue: _settingsConverter
              .getValueFromBox(widget.deviceId + WATER_LEVEL_MAX_HEIGHT),
          settingKey: widget.deviceId + WATER_LEVEL_MAX_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return validateMaxWaterLevel(height);
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async {
            await _settingsConverter.saveItem(
                WATER_LEVEL_MAX_HEIGHT, int.parse(val));
          },
        ),
        SettingsScreen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelMinHeight,
          initialValue: _settingsConverter
              .getValueFromBox(widget.deviceId + WATER_LEVEL_MIN_HEIGHT),
          settingKey: widget.deviceId + WATER_LEVEL_MIN_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return validateMinWaterLevel(height);
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async {
            await _settingsConverter.saveItem(
                WATER_LEVEL_MIN_HEIGHT, int.parse(val));
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
          settingKey: widget.deviceId + LED_COLOR + "string",
          onChange: (Color value) async {
            print("deviceSettingsSubpage - color changed");
            await _settingsConverter.saveItem(LED_COLOR, value.value);
          },
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: widget.deviceId + LED_ON,
          title: "Lights on",
          onChange: (value) async {
            await _settingsConverter.saveItem(LED_ON, value);
          },
        ),
        SettingsScreen.ExpandableSettingsTile(
          title: "LED Triggers",
          children: [
            LedTriggerList(
              deviceId: widget.deviceId,
              onChanged: (trigger) async {
                if (trigger != null) {
                  print(
                      "deviceSettingsSubpage - ledTriggerList, saving trigger = $trigger");
                  await trigger.save();
                }
                await _settingsConverter.saveItemToCloud(
                    LED_TRIGGERS,
                    _settingsConverter
                        .getLedTriggers()
                        .map((e) => e.toJson())
                        .toList());
              },
            )
          ], //TODO add led triggers list with custom tiles
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
                await _settingsConverter.saveItemToCloud(
                    FEED_TRIGGERS,
                    _settingsConverter
                        .getFeedTriggers()
                        .map((e) => e.toJson())
                        .toList());
                setState(() {
                  print("deviceSettingsSubpage - changing state");
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
          settingKey: widget.deviceId + WATER_OPTIMAL_TEMPERATURE,
          min: 15,
          max: 35,
          defaultValue: 15,
          step: 0.1,
          onChangeEnd: (val) async =>
              await _settingsConverter.saveItem(WATER_OPTIMAL_TEMPERATURE, val),
        ),
        SettingsScreen.SimpleRadioSettingsTile(
            title: "Heater mode",
            //   subtitle: _settingsConverter.getValueFromBox(widget.deviceId + WATER_HEATER_TYPE).toString(),
            settingKey: widget.deviceId + WATER_HEATER_TYPE,
            selected: _settingsConverter
                .getValueFromBox(widget.deviceId + WATER_HEATER_TYPE),
            values: HeaterType.values.map((e) => e.text).toList(),
            onChange: (val) async => {
                  print("Saving in SimpleRadioSettingsTile, val = $val"),
                  await _settingsConverter.saveToCache(WATER_HEATER_TYPE, val),
                  await _settingsConverter.saveItemToCloud(
                      WATER_HEATER_TYPE, getIndexOfHeaterTypeFromString(val))
                }),
      ],
    );
  }

  _createWaterPHGroup() {
    return SettingsScreen.SettingsGroup(
      title: "Water PH ",
      children: [
        SettingsScreen.SliderSettingsTile(
          min: 0,
          max: 14,
          step: 0.1,
          defaultValue: 7,
          title: "Max PH",
          settingKey: widget.deviceId + WATER_MAX_PH,
          onChangeEnd: (val) async => await _settingsConverter.saveItem(
              WATER_MAX_PH,
              val), //TODO add bounding between min-max sliders - states
        ),
        SettingsScreen.SliderSettingsTile(
          min: 0,
          max: 14,
          step: 0.1,
          defaultValue: 7,
          title: "Min PH",
          settingKey: widget.deviceId + WATER_MIN_PH,
          onChangeEnd: (val) async =>
              await _settingsConverter.saveItem(WATER_MIN_PH, val),
        )
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
      return "Maximum < minimum ($min)";
    }
    String sensorHeight = SettingsScreen.Settings.getValue(
        widget.deviceId + WATER_LEVEL_SENSOR_HEIGHT, height);
    if (int.parse(sensorHeight) < max) {
      return "Maximum > Height ($height)";
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
      return "Minimum > maximum ($max)";
    }
    return null;
  }

  _createOutletsGroup() {
    // print("_createOutletsGroup");
    return SettingsScreen.SettingsGroup(
      title: 'Power outlets',
      children: [
        SettingsScreen.SwitchSettingsTile(
          settingKey: widget.deviceId + POWER_OUTLET_ONE_ON,
          title: 'Outlet one:',
          onChange: (value) async {
            await _settingsConverter.saveItem(POWER_OUTLET_ONE_ON, value);
          },
        ),
        SettingsScreen.ExpandableSettingsTile(
          title: 'Power outlet 1 triggers',
          children: [
            OutletTriggerList(
              deviceId: widget.deviceId,
              boxName: HiveBoxes.outletOneTriggerList,
              onChanged: (trigger) async {
                if (trigger != null) {
                  await trigger.save();
                }
                await _settingsConverter.saveItemToCloud(
                    POWER_OUTLET_ONE_TRIGGERS,
                    _settingsConverter
                        .getOutletOneTrigger()
                        .map((e) => e.toJson())
                        .toList());
              },
            )
          ],
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: widget.deviceId + POWER_OUTLET_TWO_ON,
          title: 'Outlet two',
          onChange: (value) async {
            await _settingsConverter.saveItem(POWER_OUTLET_TWO_ON, value);
          },
        ),
        SettingsScreen.ExpandableSettingsTile(
          title: 'Power outlet 2 triggers',
          children: [
            OutletTriggerList(
              deviceId: widget.deviceId,
              boxName: HiveBoxes.outletTwoTriggerList,
              onChanged: (trigger) async {
                if (trigger != null) {
                  await trigger.save();
                }
                await _settingsConverter.saveItemToCloud(
                    POWER_OUTLET_TWO_TRIGGERS,
                    _settingsConverter
                        .getOutletTwoTrigger()
                        .map((e) => e.toJson())
                        .toList());
              },
            )
          ],
        ),
      ],
    );
  }

  StreamBuilder<BluetoothDevice> _createDirectSaveButton() {
    return StreamBuilder(
      stream: widget.bluetoothHandler.device(),
      builder: (context, snapshot) {
        //  print("subpage settings - create save button");
        // print(snapshot.data);
        // print(widget.bluetoothHandler.bluetoothDevice);
        if (!snapshot.hasData &&
            widget.bluetoothHandler.bluetoothDevice == null) {
          return SizedBox.shrink();
        }

        return RaisedButton(
            child: Text("Save settings directly"),
            onPressed: () async => sendingToBluetooth
                ? null
                : {
                    sendingToBluetooth = true,
                    await widget.bluetoothHandler.saveToDeviceDirectly(
                        _settingsConverter.settingsToByteArray()),
                    sendingToBluetooth = false
                  });
      },
    );
  }
}
