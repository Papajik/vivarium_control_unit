import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/advancedSettings/advancedArguments.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/device/settings/advanced/fw.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';

class AdvancedSettingsPage extends StatefulWidget {
  final AdvancedSettingsPageArguments arguments;

  const AdvancedSettingsPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  _AdvancedSettingsPageState createState() => _AdvancedSettingsPageState();
}

class _AdvancedSettingsPageState extends State<AdvancedSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<DeviceStreamObject>(
              create: (context) => widget.arguments.deviceProvider
                  .deviceStream(deviceId: widget.arguments.device.info.id),
              initialData: DeviceStreamObject(device: widget.arguments.device)),
        ],
        builder: (context, child) => SkeletonPage(
              appBarTitle:
                  Provider.of<DeviceStreamObject>(context).device.info.name,
              body: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 4, right: 4),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await confirm(
                            context,
                            title: Text('Reset device'),
                            content: Text(
                                'Are you sure you want to reset this device? (Device has to be claimed again)'),
                            textOK: Text('Reset'),
                          )) {
                            var device = Provider.of<DeviceStreamObject>(
                                    context,
                                    listen: false)
                                .device;
                            await widget.arguments.deviceProvider
                                .deleteDevice(device.info.id);
                            if (widget
                                .arguments.bluetoothConnector.isConnected) {
                              await widget.arguments.bluetoothConnector
                                  .unclaimDevice(deviceId: device.info.id);
                            }
                            Navigator.popUntil(
                                context,
                                (route) =>
                                    route.settings.name == Routes.userDevices);
                          }
                        },
                        child: Text('Factory reset'),
                      ),
                      if (Provider.of<DeviceStreamObject>(context)
                          .device
                          .camera
                          .active) ...[
                        Divider(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          onPressed: () {
                            widget.arguments.deviceProvider
                                .saveValue(key: CAMERA_ACTIVE, value: false);
                          },
                          child:
                              Text('Remove camera (restart of camera needed)'),
                        ),
                      ],
                      FirmwareSelector(
                          provider: widget.arguments.deviceProvider)
                    ],
                  )),
            ));
  }
}
