import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class HeaterAutoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverviewCard(
        title: 'Heater',
        body: Center(
            child: Text('Heater is in Automatic mode',
                style: Theme.of(context).textTheme.headline4)));
  }
}
