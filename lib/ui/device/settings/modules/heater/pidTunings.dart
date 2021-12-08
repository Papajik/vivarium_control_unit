import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/advancedSettings/advancedArguments.dart';
import 'package:vivarium_control_unit/models/device/modules/heater/settings.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsButton.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsDropdown.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsNumberInput.dart';
import 'package:vivarium_control_unit/ui/widgets/settings/SettingsSlider.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class PidTunings extends StatefulWidget {
  final AdvancedSettingsPageArguments arguments;

  const PidTunings({Key? key, required this.arguments}) : super(key: key);

  @override
  State<PidTunings> createState() => _PidTuningsState();
}

class _PidTuningsState extends State<PidTunings> {
  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      appBarTitle: 'PID Tunings',
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 4, right: 4),
        child: Provider<DeviceProvider>.value(
            value: widget.arguments.deviceProvider,
            builder: (context, child) => Column(
                  children: [
                    Card(
                      color: Colors.black26,
                      child: Column(
                        children: [
                          SettingsDropdown(
                              title: 'Learning mode',
                              items: SettingsHeater.tuneModeValues,
                              value: 0,
                              providerKey: HEATER_TUNE_MODE),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SettingsButton(
                                title: 'START',
                                value: true,
                                providerKey: HEATER_TUNE,
                                icon: Icon(Icons.play_circle_outline_sharp),
                              ),
                              SettingsButton(
                                title: 'STOP',
                                value: true,
                                providerKey: HEATER_TUNE,
                                icon: Icon(Icons.stop_circle_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(children: [
                          SettingsNumberInput(
                            providerKey: HEATER_STATE_KP,
                            title: 'Kp',
                            initValue: widget.arguments.device.state.heater!.kp,
                          ),
                          Divider(
                            height: 20,
                          ),
                          SettingsNumberInput(
                            providerKey: HEATER_STATE_KI,
                            title: 'Ki',
                            initValue: widget.arguments.device.state.heater!.ki,
                          ),
                          Divider(
                            height: 20,
                          ),
                          SettingsNumberInput(
                            providerKey: HEATER_STATE_KD,
                            title: 'Kd',
                            initValue: widget.arguments.device.state.heater!.kd,
                          )
                        ]),
                      ),
                    ),
                    Card(
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SettingsSlider(
                            providerKey: (HEATER_STATE_PON),
                            title: 'POn',
                            value: widget.arguments.device.state.heater!.pOn,
                            max: 1,
                            min: 0,
                            precision: 2,
                            division: 100,
                            upLimit: 1,
                            lowLimit: 0),
                      ),
                    )
                  ],
                )),
      ),
    );
  }
}
