import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/models/userSettings/userSettings.dart';
import 'package:vivarium_control_unit/ui/userSettings/fcm.dart';
import 'package:vivarium_control_unit/ui/userSettings/trackAlive.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';
import 'package:vivarium_control_unit/utils/platform/platform.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      navigationPage: NavigationPage.SETTINGS,
      appBarTitle: 'Settings',
      body: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Consumer<VivariumUser>(
          builder: (context, user, child) =>
              StreamProvider<UserSettings?>.value(
            initialData: UserSettings(),
            value: DatabaseService().userSettings(user.userId!),
            catchError: (context, error) {
              return null;
            },
            child: Column(
              children: [
                if (!PlatformInfo.isAppOS()) TrackAliveUserSettings(),
                FcmSettings(),
                Center(
                  child: ElevatedButton(
                    onPressed: () => AppSettings.openNotificationSettings(),
                    child: Text('Open notification settings'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
