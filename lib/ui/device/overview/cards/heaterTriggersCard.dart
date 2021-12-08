import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class HeaterTriggersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceSettings>(
      builder: (context, settings, child) {
        var nextTrigger = settings.heater!.nextTrigger;
        var lastTrigger = settings.heater!.lastTrigger;
        return OverviewCard(
            title: 'Heater',
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next :',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(getTimeStringFromTime(nextTrigger?.time),
                          style: Theme.of(context).textTheme.headline5),
                      if (nextTrigger != null)
                        Text(' ${nextTrigger.goal} °C',
                            style: Theme.of(context).textTheme.headline5),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last :',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        getTimeStringFromTime(lastTrigger?.time),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      if (lastTrigger != null)
                        Text(' ${lastTrigger.goal} °C',
                            style: Theme.of(context).textTheme.headline5),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
