import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class FeederCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverviewCard(
        title: 'Feeder',
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next feed:',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Consumer<DeviceSettings>(
                    builder: (context, settings, child) => Text(
                        getTimeStringFromTime(
                            settings.feeder!.nextTrigger?.time),
                        style: Theme.of(context).textTheme.headline5),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Last feed:',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Consumer<DeviceSettings>(
                    builder: (context, settings, child) => Text(
                            getTimeStringFromTime(
                                settings.feeder!.lastTrigger?.time),
                            style: Theme.of(context).textTheme.headline5),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
