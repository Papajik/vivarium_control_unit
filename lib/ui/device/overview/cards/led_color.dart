import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/deviceState.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewCard.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class LedColorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceState?>(
      builder: (context, state, child) {
        if (state == null) {
          return CircularProgressIndicator();
        }
        return OverviewCard(
          title: 'LED Color',
          body: CardBody(
            icon: FaIcon(
              FontAwesomeIcons.lightbulb,
              color: Colors.white,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: state.led!.color == 0
                    ? Text('OFF', style: Theme.of(context).textTheme.headline4)
                    : Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                            color: getColorFromInt(state.led!.color),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
