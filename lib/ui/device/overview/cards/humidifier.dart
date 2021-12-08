import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class HumidifierCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverviewCard(
      title: 'Humidity',
      body: CardBody(
        children: [
          Column(
            children: [
              Consumer<DeviceState>(
                builder: (context, state, child) => Text(
                  'Status: ${state.hum?.running ?? false ? 'ON' : 'OFF'} ',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
