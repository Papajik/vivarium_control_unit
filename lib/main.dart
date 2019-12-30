import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/ui/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
