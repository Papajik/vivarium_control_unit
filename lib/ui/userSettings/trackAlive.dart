import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/models/userSettings/userSettings.dart';
import 'package:vivarium_control_unit/utils/backgroundService/service.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';

class TrackAliveUserSettings extends StatefulWidget {
  @override
  _TrackAliveUserSettingsState createState() => _TrackAliveUserSettingsState();
}

class _TrackAliveUserSettingsState extends State<TrackAliveUserSettings> {
  late DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserSettings?, VivariumUser>(
        builder: (context, settings, user, child) => settings == null
            ? Container()
            : Column(children: [
                Card(
                  color: Colors.black26,
                  child: SwitchListTile(
                    title: Text('Track online devices',
                        style: Theme.of(context).textTheme.headline5),
                    subtitle: Text(settings.trackDevicesAlive! ? 'ON' : 'OFF',
                        style: Theme.of(context).textTheme.headline6),
                    value: settings.trackDevicesAlive!,
                    onChanged: (value) {
                      if (value) {
                        BackgroundService.start();
                      } else {
                        BackgroundService.stop();
                      }

                      _databaseService.saveSettings(
                          userId: user.userId!, value: value, key: 'tAlive');
                    },
                  ),
                )
              ]));
  }
}
