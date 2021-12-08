import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class WaterPumpCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceState>(
        builder: (context, state, child) => OverviewCard(
              title: 'W. Pump',
              body: CardBody(
                children: [
                  Column(
                    children: [
                      Text(
                        'Status: ${state.pump?.running ?? false ? 'ON' : 'OFF'} ',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  )
                ],
              ),
            ));
  }
}
