// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/deviceSensorData.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/dht_humidity.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/dht_temp.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/fan.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/feeder.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/heater.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/heaterAutoCard.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/heaterGoal.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/heaterTriggersCard.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/humidifier.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/led_color.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/led_triggers.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/ph.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/waterLevel.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/waterPump.dart';
import 'package:vivarium_control_unit/ui/device/overview/cards/waterTemp.dart';

class OverviewSubpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: _getProviders(),
        child: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: 600),
                child: _buildGrid(context))));
  }

  Widget _buildGrid(context) {
    return Consumer2<DeviceState?, DeviceSettings?>(
      builder: (context, deviceState, deviceSettings, child) {
        return (deviceState == null || deviceSettings == null)
            ? Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return StaggeredGridView.count(
                      physics: BouncingScrollPhysics(),
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      addAutomaticKeepAlives: false,
                      crossAxisCount: 10,
                      staggeredTiles: constraints.maxWidth >= 600
                          ? _getBigTiles(context, deviceState, deviceSettings)
                          : _getSmallTiles(
                              context, deviceState, deviceSettings),
                      children: constraints.maxWidth >= 600
                          ? _getBigWidgets(deviceState, deviceSettings)
                          : _getSmallWidgets(deviceState, deviceSettings));
                },
              );
      },
    );
  }

  List<StatelessWidget> _getSmallWidgets(
      DeviceState deviceState, DeviceSettings deviceSettings) {
    return [
      if (deviceState.ph?.connected ?? false) PhCard(),
      if (deviceState.heater?.connected ?? false)
        if (deviceSettings.heater?.isInternal ?? false) ...[
          if (!(deviceSettings.heater?.isDirect ?? true)) HeaterGoalCard(),
          HeaterCard()
        ] else
          HeaterAutoCard(),
      if (deviceState.waterTemp?.connected ?? false) WaterTempCard(),
      if (deviceState.dht?.connected ?? false) DhtHumidityCard(),
      if (deviceState.dht?.connected ?? false) DhtTempCard(),
      if (deviceState.waterLevel?.connected ?? false) WaterLevelCard(),
      if (deviceState.fan?.connected ?? false) FanCard(),
      if (deviceState.led?.connected ?? false) LedColorCard(),
      if (deviceState.feeder?.connected ?? false) FeederCard(),
      if (deviceState.led?.connected ?? false) LedTriggersCard(),
      if (deviceState.hum?.connected ?? false) HumidifierCard(),
      if (deviceState.pump?.connected ?? false) WaterPumpCard(),
      if (deviceState.heater?.connected ?? false) HeaterTriggersCard()
    ];
  }

  List<StatelessWidget> _getBigWidgets(
      DeviceState deviceState, DeviceSettings deviceSettings) {
    return [
      if (deviceState.ph?.connected ?? false) PhCard(),
      if (deviceState.heater?.connected ?? false)
        if (deviceSettings.heater?.isInternal ?? false) ...[
          if (!(deviceSettings.heater?.isDirect ?? true)) HeaterGoalCard(),
          HeaterCard()
        ] else
          HeaterAutoCard(),
      if (deviceState.waterTemp?.connected ?? false) WaterTempCard(),
      if (deviceState.dht?.connected ?? false) DhtHumidityCard(),
      if (deviceState.dht?.connected ?? false) DhtTempCard(),
      if (deviceState.waterLevel?.connected ?? false) WaterLevelCard(),
      if (deviceState.fan?.connected ?? false) FanCard(),
      if (deviceState.led?.connected ?? false) LedColorCard(),
      if (deviceState.feeder?.connected ?? false) FeederCard(),
      if (deviceState.led?.connected ?? false) LedTriggersCard(),
      if (deviceState.hum?.connected ?? false) HumidifierCard(),
      if (deviceState.pump?.connected ?? false) WaterPumpCard(),
      if (deviceState.heater?.connected ?? false) HeaterTriggersCard()
    ];
  }

  List<StaggeredTile> _getSmallTiles(
      context, DeviceState deviceState, DeviceSettings deviceSettings) {
    return [
      if (deviceState.ph?.connected ?? false)
        StaggeredTile.extent(
            10, Provider.of<PhHistory?>(context)?.hasData ?? false ? 230 : 110),
      if (deviceState.heater?.connected ?? false)
        if ((deviceSettings.heater?.isInternal ?? false) &&
            !(deviceSettings.heater?.isDirect ?? true)) ...[
          StaggeredTile.extent(
              10,
              Provider.of<HeaterGoalHistory?>(context)?.hasData ?? false
                  ? 230
                  : 110),
          StaggeredTile.extent(
              10,
              Provider.of<HeaterPowerHistory?>(context)?.hasData ?? false
                  ? 230
                  : 110),
        ] else
          StaggeredTile.extent(10, 100),
      if (deviceState.waterTemp?.connected ?? false)
        StaggeredTile.extent(
            10,
            Provider.of<WaterTempHistory?>(context)?.hasData ?? false
                ? 230
                : 110),
      if (deviceState.dht?.connected ?? false)
        StaggeredTile.extent(10,
            Provider.of<DhtHumHistory?>(context)?.hasData ?? false ? 230 : 110),
      if (deviceState.dht?.connected ?? false)
        StaggeredTile.extent(
            10,
            Provider.of<DhtTempHistory?>(context)?.hasData ?? false
                ? 230
                : 110),
      if (deviceState.waterLevel?.connected ?? false)
        StaggeredTile.extent(
            10,
            Provider.of<WaterLevelHistory?>(context)?.hasData ?? false
                ? 230
                : 110),
      if (deviceState.fan?.connected ?? false) StaggeredTile.extent(6, 100),
      if (deviceState.led?.connected ?? false) StaggeredTile.extent(4, 100),
      if (deviceState.feeder?.connected ?? false) StaggeredTile.extent(5, 140),
      if (deviceState.led?.connected ?? false) StaggeredTile.extent(5, 140),
      if (deviceState.hum?.connected ?? false) StaggeredTile.extent(4, 100),
      if (deviceState.pump?.connected ?? false) StaggeredTile.extent(4, 100),
      if (deviceState.heater?.connected ?? false)
        StaggeredTile.extent(
            deviceSettings.heater?.triggers.isEmpty ?? false ? 4 : 6, 140)
    ];
  }

  List<StaggeredTile> _getBigTiles(BuildContext context,
      DeviceState deviceState, DeviceSettings deviceSettings) {
    return [
      if (deviceState.ph?.connected ?? false)
        StaggeredTile.extent(
            10, Provider.of<PhHistory?>(context)?.hasData ?? false ? 230 : 110),
      if (deviceState.heater?.connected ?? false)
        if ((deviceSettings.heater?.isInternal ?? false) &&
            !(deviceSettings.heater?.isDirect ?? true)) ...[
          StaggeredTile.extent(
              10,
              Provider.of<HeaterGoalHistory?>(context)?.hasData ?? false
                  ? 230
                  : 110),
          StaggeredTile.extent(
              10,
              Provider.of<HeaterPowerHistory?>(context)?.hasData ?? false
                  ? 230
                  : 110),
        ] else
          StaggeredTile.extent(10, 100),
      if (deviceState.waterTemp?.connected ?? false)
        StaggeredTile.extent(
            10,
            Provider.of<WaterTempHistory?>(context)?.hasData ?? false
                ? 230
                : 110),
      if (deviceState.dht?.connected ?? false)
        StaggeredTile.extent(10,
            Provider.of<DhtHumHistory?>(context)?.hasData ?? false ? 230 : 110),
      if (deviceState.dht?.connected ?? false)
        StaggeredTile.extent(
            10,
            Provider.of<DhtTempHistory?>(context)?.hasData ?? false
                ? 230
                : 110),
      if (deviceState.waterLevel?.connected ?? false)
        StaggeredTile.extent(
            10,
            Provider.of<WaterLevelHistory?>(context)?.hasData ?? false
                ? 230
                : 110),
      if (deviceState.fan?.connected ?? false) StaggeredTile.extent(3, 100),
      if (deviceState.led?.connected ?? false) StaggeredTile.extent(3, 100),
      if (deviceState.feeder?.connected ?? false) StaggeredTile.extent(3, 140),
      if (deviceState.led?.connected ?? false) StaggeredTile.extent(3, 140),
      if (deviceState.hum?.connected ?? false) StaggeredTile.extent(3, 100),
      if (deviceState.pump?.connected ?? false) StaggeredTile.extent(3, 100),
      if (deviceState.heater?.connected ?? false)
        StaggeredTile.extent(
            deviceSettings.heater?.triggers.isEmpty ?? false ? 3 : 4, 140)
    ];
  }

  List<ProxyProvider<Object?, Object?>> _getProviders() {
    return [
      ProxyProvider<DeviceStreamObject, DeviceState?>(
        update: (context, deviceObj, previous) => deviceObj.device.state,
        updateShouldNotify: (previous, current) {
          return previous != current;
        },
      ),
      ProxyProvider<DeviceStreamObject, DeviceSettings?>(
        update: (context, deviceObj, previous) => deviceObj.device.settings,
        updateShouldNotify: (previous, current) => previous != current,
      ),
      ProxyProvider<DeviceStreamObject, DeviceSensorData?>(
        update: (context, deviceObj, previous) => deviceObj.device.sensorData,
        updateShouldNotify: (previous, current) => previous != current,
      ),
      ProxyProvider<SensorDataHistory, DhtTempHistory>(
          update: (context, history, previous) => history.dhtTempHistory,
          updateShouldNotify: (previous, current) =>
              previous.history.lastKey() != current.history.lastKey()),
      ProxyProvider<SensorDataHistory, HeaterGoalHistory?>(
          update: (context, history, previous) => history.heaterGoalHistory,
          updateShouldNotify: (previous, current) =>
              previous?.history.lastKey() != current?.history.lastKey()),
      ProxyProvider<SensorDataHistory, HeaterPowerHistory?>(
          update: (context, history, previous) => history.heaterPowerHistory,
          updateShouldNotify: (previous, current) =>
              previous?.history.lastKey() != current?.history.lastKey()),
      ProxyProvider<SensorDataHistory, WaterTempHistory?>(
          update: (context, history, previous) => history.waterTempHistory,
          updateShouldNotify: (previous, current) =>
              previous?.history.lastKey() != current?.history.lastKey()),
      ProxyProvider<SensorDataHistory, DhtHumHistory?>(
          update: (context, history, previous) => history.dhtHumHistory,
          updateShouldNotify: (previous, current) =>
              previous?.history.lastKey() != current?.history.lastKey()),
      ProxyProvider<SensorDataHistory, WaterLevelHistory?>(
          update: (context, history, previous) => history.waterLevelHistory,
          updateShouldNotify: (previous, current) =>
              previous?.history.lastKey() != current?.history.lastKey()),
      ProxyProvider<SensorDataHistory, PhHistory?>(
          update: (context, history, previous) => history.phHistory,
          updateShouldNotify: (previous, current) =>
              previous?.history.lastKey() != current?.history.lastKey())
    ];
  }
}
