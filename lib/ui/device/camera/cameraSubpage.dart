import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/cameraImage/cameraImage.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/device/camera/addCamera/addCamera.dart';
import 'package:vivarium_control_unit/ui/device/camera/imageView.dart';
import 'package:vivarium_control_unit/utils/firebase/storageService.dart';

class CameraSubpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Consumer2<DeviceStreamObject, VivariumUser>(
            builder: (context, deviceObj, user, consumerChild) =>
                deviceObj.device.camera.active
                    ? FutureProvider<CameraImage?>.value(
                        value: StorageService()
                            .getImage(
                                deviceId: deviceObj.device.info.id,
                                userId: user.userId!)
                            .then((value) => CameraImage(
                                updated: deviceObj.device.camera.updated,
                                data: value)),
                        catchError: (context, error) {
                          return null;
                        },
                        initialData: null,
                        child: ImageView(),
                      )
                    : AddCameraCard()));
  }
}
