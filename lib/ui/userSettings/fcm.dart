import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/models/userSettings/userSettings.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';

class FcmSettings extends StatefulWidget {
  @override
  _FcmSettingsState createState() => _FcmSettingsState();
}

class _FcmSettingsState extends State<FcmSettings> {
  late DatabaseService _databaseService;

  @override
  void initState() {
    _databaseService = DatabaseService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserSettings, VivariumUser>(
        builder: (context, settings, user, child) => Column(
                children: [
                  Card(
                    color: Colors.black26,
                    child: SwitchListTile(
                      title: Text(
                        'Distinct notification',
                        style:
                        Theme.of(context).textTheme.headline5
                      ),
                      subtitle: Text(
                          settings.distinctNotification! ? 'ON' : 'OFF',
                          style: Theme.of(context).textTheme.headline6),
                      value: settings.distinctNotification!,
                      onChanged: (value) => _databaseService.saveSettings(
                          userId: user.userId!, value: value, key: 'nDist'),
                    ),
                  ),
                  Card(
                    color: Colors.black26,
                    child: SwitchListTile(
                      title: Text(
                        'Notify on cross limit',
                        style:
                        Theme.of(context).textTheme.headline5
                      ),
                      subtitle: Text(settings.notifyOnCrossLimit! ? 'ON' : 'OFF',
                          style: Theme.of(context).textTheme.headline6),
                      value: settings.notifyOnCrossLimit!,
                      onChanged: (value) => _databaseService.saveSettings(
                          userId: user.userId!, value: value, key: 'nLimit'),
                    ),
                  ),
                  Card(
                    color: Colors.black26,
                    child: SwitchListTile(
                      title: Text(
                        'Notify on connection',
                        style:
                        Theme.of(context).textTheme.headline5
                      ),
                      subtitle: Text(
                          settings.notifyOnConnectionUpdate! ? 'ON' : 'OFF',
                          style: Theme.of(context).textTheme.headline6),
                      value: settings.notifyOnConnectionUpdate!,
                      onChanged: (value) => _databaseService.saveSettings(
                          userId: user.userId!, value: value, key: 'nConn'),
                    ),
                  ),
                  Card(
                    color: Colors.black26,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24.0, right: 24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Notification delay',
                                    style: Theme.of(context).textTheme.headline5),
                                Text(
                                  _parseDelay(settings.notificationDelay!),
                                    style: Theme.of(context).textTheme.headline5),
                              ],
                            ),
                          ),
                          Slider(
                            min: 0,
                            max: 1800,
                            divisions: 180,
                            onChanged: (value) => _databaseService.saveSettings(
                                userId: user.userId!, value: value*1000, key: 'nDelay'),
                            value: settings.notificationDelay! / 1000,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }

  String _parseDelay(int notificationDelay) {
    var sec = notificationDelay/1000;
    if (sec<60) {
      return '${sec.round()} s';
    }
    return '${(sec / 60).round()} m';


  }
}
