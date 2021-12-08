import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class CameraPanel extends StatelessWidget {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text('Camera',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Consumer2<DeviceStreamObject, DeviceProvider>(
                  builder: (context, deviceObject, provider, child) =>
                      deviceObject.device.camera.active
                          ? ElevatedButton(
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
                              onPressed: () {
                                provider.saveValue(
                                    key: CAMERA_ACTIVE, value: false);
                              },
                              child: Text('Manual remove of camera'))
                          : ElevatedButton(
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.addCameraList,
                                    arguments: deviceObject.device.info.id);
                              },
                              child: Text('Add new Camera'))),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
