import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceSettings.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class LedTriggersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceSettings>(
      builder: (context, settings, child) {
        var nextTrigger = settings.led!.nextTrigger;
        var lastTrigger = settings.led!.lastTrigger;
        return OverviewCard(
            titleBackground: Color(Provider.of<DeviceState>(context).led?.color ?? 0),
            title: 'LED',
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
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          /// variable is null if no trigger is set so
                          /// we provide 0 on null value
                          color: Color(nextTrigger?.color ?? 0).withAlpha(255),
                          shape: BoxShape.circle,
                        ),
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
                        'Last :',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        getTimeStringFromTime(lastTrigger?.time),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          /// variable is null if no trigger is set so
                          /// 0 is provided if null occurs
                          color: Color(lastTrigger?.color ?? 0).withAlpha(255),
                          shape: BoxShape.circle,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
