import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/ui/homePage.dart';

void main() async {
  await PrefService.init(prefix: 'pref_');
  runApp(Constants(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivarium control unit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
