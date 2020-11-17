import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as settings_screen;
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/triggers/waterHeaterType.dart';
import 'package:vivarium_control_unit/ui/device/settings/feedTriggerList.dart';
import 'package:vivarium_control_unit/ui/device/settings/ledTriggerList.dart';
import 'package:vivarium_control_unit/ui/device/settings/outletTriggerList.dart';
import 'package:vivarium_control_unit/utils/bluetoothProvider.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';
import 'package:vivarium_control_unit/utils/settingsConverter.dart';

class DeviceSettingsSubpage extends StatefulWidget {
  final Device device;
  final BluetoothProvider bluetoothProvider;
  final SettingsConverter settingsConverter;

  DeviceSettingsSubpage({
    Key key,
    this.device,
    this.bluetoothProvider,
    this.settingsConverter,
  }) : super(key: key);

  @override
  _DeviceSettingsSubpageState createState() => _DeviceSettingsSubpageState();
}

class _DeviceSettingsSubpageState extends State<DeviceSettingsSubpage> {
  bool sendingToBluetooth = false;
  SettingsConverter _settingsConverter;

  @override
  void initState() {
    print('_DeviceSettingsSubpageState init');
    _settingsConverter = widget.settingsConverter;
    _cacheDeviceSettings();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _cacheDeviceSettings();
  }

  @override
  Widget build(BuildContext context) {
    print('DeviceSettingsSubpage build');
    print('Building from this device: ${widget.device.toString()}');
    print(widget.device.toString());
    print(widget.device.info.toString());
    if (_settingsConverter.initialized) {
      return _createSettingList();
    } else {
      return StreamBuilder(
        stream: _settingsConverter.initializedStream,
        builder: (context, snapshot) {
          print('... stream');
          if (!snapshot.hasData || !snapshot.data) {
            print('data= ${snapshot.data}');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _createSettingList();
          }
        },
      );
    }
  }

  //TODO
  Widget _createSettingList() {
    return createColumns();

    //No need for futurebuilder - device is already loaded from cloud
    return FutureBuilder(
      future: _settingsConverter.loadSettingsFromCloud(),
      builder: (context, snapshot) {
        print('Settings Subpage - builder = Has data = ' +
            snapshot.hasData.toString());
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return createColumns();
      },
    );
  }

  Widget createColumns() {
    print('create columns');
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

  settings_screen.SettingsGroup _createWaterLevelGroup() {
    print('Create water level ');
    return settings_screen.SettingsGroup(
      title: Constants.of(context).settingsWaterLevelTitle,
      children: [
        settings_screen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelSensorHeight,
          initialValue: widget.device.settings.waterSensorHeight.toString(),
          settingKey: widget.device.info.id + WATER_LEVEL_SENSOR_HEIGHT,
          obscureText: false,
          validator: (String height) {
            return int.tryParse(height) != null ? null : 'Input must be number';
          },
          borderColor: Colors.lightBlueAccent,
          errorColor: Colors.orangeAccent,
          onChange: (val) async => await _settingsConverter.saveItem(
              WATER_LEVEL_SENSOR_HEIGHT, int.parse(val)),
        ),
        settings_screen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelMaxHeight,
          initialValue: widget.device.settings.maxWaterHeight.toString(),
          settingKey: widget.device.info.id + WATER_LEVEL_MAX_HEIGHT,
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
        settings_screen.TextInputSettingsTile(
          title: Constants.of(context).settingsWaterLevelMinHeight,
          initialValue: widget.device.settings.minWaterHeight.toString(),
          settingKey: widget.device.info.id + WATER_LEVEL_MIN_HEIGHT,
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

  settings_screen.SettingsGroup _createLedGroup() {
    return settings_screen.SettingsGroup(
      title: 'LED',
      children: [
        settings_screen.ColorPickerSettingsTile(
          title: 'Current color',
          settingKey: widget.device.info.id + LED_COLOR + 'string',
          onChange: (Color value) async {
            print('deviceSettingsSubpage - color changed');
            await _settingsConverter.saveItem(LED_COLOR, value.value);
          },
        ),
        settings_screen.SwitchSettingsTile(
          settingKey: widget.device.info.id + LED_ON,
          title: 'Lights on',
          onChange: (value) async {
            await _settingsConverter.saveItem(LED_ON, value);
          },
        ),
        settings_screen.ExpandableSettingsTile(
          title: 'LED Triggers',
          children: [
            LedTriggerList(
              deviceId: widget.device.info.id,
              onChanged: (trigger) async {
                if (trigger != null) {
                  print(
                      'deviceSettingsSubpage - ledTriggerList, saving trigger = $trigger');
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

  settings_screen.SettingsGroup _createFeederGroup() {
    return settings_screen.SettingsGroup(
      title: 'Feeder',
      children: [
        settings_screen.ExpandableSettingsTile(
          title: 'Feeding times',
          children: [
            SettingsFeedList(
              deviceId: widget.device.info.id,
              onChanged: (val) async {
                await _settingsConverter.saveItemToCloud(
                    FEED_TRIGGERS,
                    _settingsConverter
                        .getFeedTriggers()
                        .map((e) => e.toJson())
                        .toList());
                setState(() {
                  print('deviceSettingsSubpage - changing state');
                });
              },
            ),
          ],
        )
      ],
    );
  }

  settings_screen.SettingsGroup _createWaterTemperatureGroup() {
    return settings_screen.SettingsGroup(
      title: 'Water temperature',
      children: [
        settings_screen.SliderSettingsTile(
          title: 'Optimal temperature',
          settingKey: widget.device.info.id + WATER_OPTIMAL_TEMPERATURE,
          min: 15,
          max: 35,
          defaultValue: 15,
          step: 0.1,
          onChangeEnd: (val) async =>
              await _settingsConverter.saveItem(WATER_OPTIMAL_TEMPERATURE, val),
        ),
        settings_screen.SimpleRadioSettingsTile(
            title: 'Heater mode',
            //   subtitle: _settingsConverter.getValueFromBox(widget.deviceId + WATER_HEATER_TYPE).toString(),
            settingKey: widget.device.info.id + WATER_HEATER_TYPE,
            selected: widget.device.settings.waterHeaterType.text,
            values: HeaterType.values.map((e) => e.text).toList(),
            onChange: (val) async => {
                  print('Saving in SimpleRadioSettingsTile, val = $val'),
                  await _settingsConverter.saveToCache(WATER_HEATER_TYPE, val),
                  await _settingsConverter.saveItemToCloud(
                      WATER_HEATER_TYPE, getIndexOfHeaterTypeFromString(val))
                }),
      ],
    );
  }

  settings_screen.SettingsGroup _createWaterPHGroup() {
    return settings_screen.SettingsGroup(
      title: 'Water PH ',
      children: [
        settings_screen.SliderSettingsTile(
          min: 0,
          max: 14,
          step: 0.1,
          defaultValue: 7,
          title: 'Max PH',
          settingKey: widget.device.info.id + WATER_MAX_PH,
          onChangeEnd: (val) async => await _settingsConverter.saveItem(
              WATER_MAX_PH,
              val), //TODO add bounding between min-max sliders - states
        ),
        settings_screen.SliderSettingsTile(
          min: 0,
          max: 14,
          step: 0.1,
          defaultValue: 7,
          title: 'Min PH',
          settingKey: widget.device.info.id + WATER_MIN_PH,
          onChangeEnd: (val) async =>
              await _settingsConverter.saveItem(WATER_MIN_PH, val),
        )
      ],
    );
  }

  String validateMaxWaterLevel(String height) {
    if (int.tryParse(height) == null) return 'Input must be number';
    var max = int.parse(height);
    var min = settings_screen.Settings.getValue(
        widget.device.info.id + WATER_LEVEL_MIN_HEIGHT, height);
    if (min == null || min.isEmpty) return null;
    if (int.parse(min) > max) {
      return 'Maximum < minimum ($min)';
    }
    var sensorHeight = settings_screen.Settings.getValue(
        widget.device.info.id + WATER_LEVEL_SENSOR_HEIGHT, height);
    if (int.parse(sensorHeight) < max) {
      return 'Maximum > Height ($height)';
    }
    return null;
  }

  String validateMinWaterLevel(String height) {
    if (int.tryParse(height) == null) return 'Input must be number';
    var min = int.parse(height);
    var max = settings_screen.Settings.getValue(
        widget.device.info.id + WATER_LEVEL_MAX_HEIGHT, height);
    if (max == null || max.isEmpty) return null;
    if (int.parse(max) < min) {
      return 'Minimum > maximum ($max)';
    }
    return null;
  }

  settings_screen.SettingsGroup _createOutletsGroup() {
    // print("_createOutletsGroup");
    return settings_screen.SettingsGroup(
      title: 'Power outlets',
      children: [
        settings_screen.SwitchSettingsTile(
          settingKey: widget.device.info.id + POWER_OUTLET_ONE_ON,
          title: 'Outlet one:',
          onChange: (value) async {
            await _settingsConverter.saveItem(POWER_OUTLET_ONE_ON, value);
          },
        ),
        settings_screen.ExpandableSettingsTile(
          title: 'Power outlet 1 triggers',
          children: [
            OutletTriggerList(
              deviceId: widget.device.info.id,
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
        settings_screen.SwitchSettingsTile(
          settingKey: widget.device.info.id + POWER_OUTLET_TWO_ON,
          title: 'Outlet two',
          onChange: (value) async {
            await _settingsConverter.saveItem(POWER_OUTLET_TWO_ON, value);
          },
        ),
        settings_screen.ExpandableSettingsTile(
          title: 'Power outlet 2 triggers',
          children: [
            OutletTriggerList(
              deviceId: widget.device.info.id,
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

  StreamBuilder<BluetoothDeviceState> _createDirectSaveButton() {
    return StreamBuilder(
      stream: widget.bluetoothProvider.deviceStateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data != BluetoothDeviceState.connected) {
          return SizedBox.shrink();
        } else {
          return RaisedButton(
              child: Text('Save settings directly'),
              onPressed: () async => sendingToBluetooth
                  ? null
                  : {
                      sendingToBluetooth = true,
                      await widget.bluetoothProvider
                          .writeByteArrayToBluetoothCharacteristic(
                              _settingsConverter.settingsToByteArray()),
                      sendingToBluetooth = false
                    });
        }
      },
    );

//    return StreamBuilder(
//      stream: widget.bluetoothProvider.device(),
//      builder: (context, snapshot) {
//        //  print("subpage settings - create save button");
//        // print(snapshot.data);
//        // print(widget.bluetoothHandler.bluetoothDevice);
//        if (!snapshot.hasData &&
//            widget.bluetoothProvider.bluetoothDevice == null) {
//          return SizedBox.shrink();
//        }
//
//        return RaisedButton(
//            child: Text("Save settings directly"),
//            onPressed: () async => sendingToBluetooth
//                ? null
//                : {
//                    sendingToBluetooth = true,
//                    await widget.bluetoothProvider.saveToDeviceDirectly(
//                        _settingsConverter.settingsToByteArray()),
//                    sendingToBluetooth = false
//                  });
//      },
//    );
  }

  void _cacheDeviceSettings(){
    if (_settingsConverter.initialized) {
      _settingsConverter.updateCache(widget.device.settings);
    } else {
      var subscription;
      subscription = _settingsConverter.initializedStream.listen((initialized) {
        if (initialized) {
          _settingsConverter.updateCache(widget.device.settings);
          subscription.cancel();
        }
      });
    }
  }
}
