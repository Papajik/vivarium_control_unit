  import 'package:flamingo/flamingo.dart' as Flamingo;
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/ui/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vivarium_control_unit/utils/cacheProvider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Settings.init(cacheProvider: HiveCache());
  await Flamingo.Flamingo.initializeApp();
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
