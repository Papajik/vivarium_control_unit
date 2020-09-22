import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as SettingsScreen;
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/models/waterHeaterType.dart';
import 'package:vivarium_control_unit/ui/device/settingsFeedList.dart';
import 'package:vivarium_control_unit/utils/bluetoothHandler.dart';
import 'package:vivarium_control_unit/utils/cloudSettingsConverter.dart';

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

  bool _change = false;

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
      builder: (context, snapshot) {
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
        Expanded(
            child: ListView(
          children: [
            _createDirectSaveButton(),
            _createWaterLevelGroup(),
            _createLedGroup(),
            _createFeederGroup(),
            _createWaterTemperatureGroup(),
            _createWaterPHGroup(),
            _createOutletsGroup()
          ],
        )),
        //createButton()
      ],
    );
  }

  Widget createButton() {
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
          onChange: (val) async => await _settingsConverter.saveItemToCloud(
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
            await _settingsConverter.saveItemToCloud(
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
            await _settingsConverter.saveItemToCloud(
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
          settingKey: widget.deviceId + LED_COLOR,
          onChange: (value) async {
            await _settingsConverter.saveItemToCloud(LED_COLOR, value);
          },
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: widget.deviceId + LED_ON,
          title: "Lights on",
          onChange: (value) async {
            await _settingsConverter.saveItemToCloud(LED_ON, value);
          },
        ),
        SettingsScreen.ExpandableSettingsTile(
          title: "LED Triggers",
          children: [], //TODO add led triggers list with custom tiles
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
    print(HeaterType.values.map((e) => e.toString()).toList());
    print(_settingsConverter
        .getValueFromBox(widget.deviceId + WATER_HEATER_TYPE));
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
          onChangeEnd: (val) async => await _settingsConverter.saveItemToCloud(
              WATER_OPTIMAL_TEMPERATURE, val),
        ),
        SettingsScreen.SimpleRadioSettingsTile(
            title: "Heater mode",
            settingKey: widget.deviceId + WATER_HEATER_TYPE,
            selected: _settingsConverter
                .getValueFromBox(widget.deviceId + WATER_HEATER_TYPE),
            values: HeaterType.values.map((e) => e.toString()).toList(),
            onChange: (val) async => await _settingsConverter.saveItemToCloud(
                WATER_HEATER_TYPE, val)),
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
          onChangeEnd: (val) async => await _settingsConverter.saveItemToCloud(
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
              await _settingsConverter.saveItemToCloud(WATER_MIN_PH, val),
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
    return SettingsScreen.SettingsGroup(
      title: 'Power outlets',
      children: [
        SettingsScreen.SwitchSettingsTile(
          settingKey: widget.deviceId + POWER_OUTLET_ONE_ON,
          title: 'Outlet one:',
          onChange: (value) async {
            await _settingsConverter.saveItemToCloud(
                POWER_OUTLET_ONE_ON, value);
          },
        ),
        SettingsScreen.SwitchSettingsTile(
          settingKey: widget.deviceId + POWER_OUTLET_TWO_ON,
          title: 'Outlet two',
          onChange: (value) async {
            await _settingsConverter.saveItemToCloud(
                POWER_OUTLET_TWO_ON, value);
          },
        ),
        //TODO add outlets triggers
      ],
    );
  }

  _createDirectSaveButton() {
    return StreamBuilder(
      stream: widget.bluetoothHandler.device(),
      builder: (context, snapshot) {
        print("subpage settings - create save button");
        print(snapshot.data);
        print(widget.bluetoothHandler.bluetoothDevice);
        if (!snapshot.hasData && widget.bluetoothHandler.bluetoothDevice == null) {
          return SizedBox.shrink();
        }

        return RaisedButton(
          child: Text("Save settings directly"),
          onPressed: () async =>
              await widget.bluetoothHandler.saveToDeviceDirectly(_settingsConverter.settingsToByteArray()),
        );
      },
    );
  }
}
