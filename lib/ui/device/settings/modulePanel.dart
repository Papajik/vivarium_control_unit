import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/dht.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/fan.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/feeder.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/heater/heater.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/humidifier.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/led.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/outlet.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/ph.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/waterLevel.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/waterPump.dart';
import 'package:vivarium_control_unit/ui/device/settings/modules/waterTemp.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/divider.dart';

class ModulePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var device = Provider.of<DeviceStreamObject>(context, listen: false).device;
    return Column(
      children: [
        if (device.state.outlet != null) OutletSettings(),
        if (device.state.dht?.connected != null) DhtModuleSettings(),
        if (device.state.waterTemp?.connected != null)
          WaterTempModuleSettings(),
        if (device.state.waterLevel?.connected != null)
          WaterLevelModuleSettings(),
        if (device.state.ph?.connected != null) PhModuleSettings(),
        if (device.state.heater?.connected != null) HeaterModuleSettings(),
        if (device.state.fan?.connected != null) FanModuleSettings(),
        if (device.state.feeder?.connected != null) FeederModuleSettings(),
        if (device.state.led?.connected != null) LedModuleSettings(),
        if (device.state.hum?.connected != null) HumidifierModuleSettings(),
        if (device.state.pump?.connected != null) WaterPumpModuleSettings(),
        SettingsDivider(),
        SettingsDivider()
      ],
    );
  }
}
