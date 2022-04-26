import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/device/settings/cameraPanel.dart';
import 'package:vivarium_control_unit/ui/device/settings/devicePanel.dart';
import 'package:vivarium_control_unit/ui/device/settings/modulePanel.dart';

class SettingsSubpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 4, right: 4),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [DevicePanel(), CameraPanel(), ModulePanel()],
            ),
          ),
        ),
      ),
    );

    // return _listView();
    // return _ssv();
  }
}
