import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/devices/deviceList.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';
import 'package:vivarium_control_unit/utils/platform/platform.dart';

class DevicesPage extends StatefulWidget {
  final String? uid;

  DevicesPage({Key? key, this.uid}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      navigationPage: NavigationPage.DEVICES,
      floatingActionButton: (PlatformInfo.isAppOS())
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.addDeviceList),
              child: Icon(Icons.add),
            )
          : null,
      appBarTitle: 'Devices',
      body: Consumer<VivariumUser>(
        builder: (context, user, child) {
          if (!user.isSignedIn) return Container();
          return StreamProvider<List<Device>>.value(
              initialData: [],
              catchError: (context, error) {
                return <Device>[];
              },
              value: DatabaseService().devices(user.userId!),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return DeviceList();
                },
              ));
        },
      ),
    );
  }
}
