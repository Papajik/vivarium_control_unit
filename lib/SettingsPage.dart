import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';


class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences Demo'),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          'Message interval',
          'nessage_interval',
          defaultVal: '1 minute',
          values: ['1 minute', '5 minutes', '60 minutes'],
        ),
        PreferenceTitle('Radio placeholder'),
        RadioPreference(
          'First',
          'first',
          'radio_1',
          isDefault: true,
        ),
        RadioPreference(
          'Second',
          'second',
          'radio_1',
        ),
      ]),
    );
  }

}