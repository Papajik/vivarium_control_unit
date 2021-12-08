import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/overview/iconRotation.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';

class FanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceStreamObject>(
      builder: (context, deviceObj, child) {
        return OverviewCard(
          title: 'Fan',
          body: CardBody(
            icon: IconRotation(
              icon: FaIcon(
                FontAwesomeIcons.fan,
                color: Colors.white,
              ),
              speed: (deviceObj.device.state.fan?.speed ?? 0) / 255 * 100,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Speed: ${deviceObj.device.state.fan?.speed != null ? (deviceObj.device.state.fan?.speed ?? 0 / 255 * 100) : '--'} %',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
