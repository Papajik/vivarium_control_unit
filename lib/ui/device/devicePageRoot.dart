import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/sensorDataHistory/sensorDataHistory.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/device/camera/cameraSubpage.dart';
import 'package:vivarium_control_unit/ui/device/connectionButton.dart';
import 'package:vivarium_control_unit/ui/device/overview/overviewSubpage.dart';
import 'package:vivarium_control_unit/ui/device/settings/settingsSubpage.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';
import 'package:vivarium_control_unit/utils/platform/platform.dart';

class DevicePageRoot extends StatefulWidget {
  final Device device;

  const DevicePageRoot({Key? key, required this.device}) : super(key: key);

  @override
  _DevicePageRootState createState() => _DevicePageRootState();
}

class _DevicePageRootState extends State<DevicePageRoot>
    with SingleTickerProviderStateMixin {
  /// Connector only on AppOS
  BluetoothConnector? _connector = null;

  late DeviceProvider _deviceProvider;
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndex = 0;

    if (PlatformInfo.isAppOS()) {
      _connector = BluetoothConnector(deviceId: widget.device.info.macAddress);
    }
    _deviceProvider =
        DeviceProvider(bluetoothConnector: _connector, device: widget.device);
  }

  @override
  void dispose() async {
    super.dispose();
    _pageController.dispose();
    _deviceProvider.dispose();
    await _connector?.disconnect();
    await _connector?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VivariumUser>(builder: (context, user, child) {
      if (!user.isSignedIn) {
        return SkeletonPage(
          appBarTitle: 'Device',
          body: Text('Sign in first'),
        );
      }

      /// Should always happen
      return MultiProvider(
          providers: [
            StreamProvider<DeviceStreamObject>(
                create: (context) => _deviceProvider.deviceStream(
                    deviceId: widget.device.info.id),
                lazy: false,
                updateShouldNotify: (previous, current) {
                  return previous != current;
                },
                initialData: DeviceStreamObject(device: widget.device)),
            StreamProvider<SensorDataHistory>(
              create: (context) =>
                  _deviceProvider.deviceSensorDataHistoryStream(
                      userId: user.userId, deviceId: widget.device.info.id),
              initialData: SensorDataHistory(),
              catchError: (context, error) {
                return SensorDataHistory();
              },
            ),
            Provider<DeviceProvider>.value(value: _deviceProvider),
            Provider<BluetoothConnector?>.value(value: _connector),

            /// Provides null on web app
            StreamProvider<DeviceConnectionState?>(
                create: (context) => _connector?.connectionStateStream,

                /// Is null on web app
                initialData: DeviceConnectionState.disconnected,
                catchError: (context, error) {
                  return DeviceConnectionState.disconnected;
                }),
          ],
          builder: (context, child) {
            return OrientationBuilder(
              builder: (context, orientation) => SkeletonPage(
                  hideOverlay: orientation == Orientation.landscape &&
                      PlatformInfo.isAppOS(),
                  appBarTitle:
                      Provider.of<DeviceProvider>(context).device.info.name,
                  bottomNavigationBar: BottomNavyBar(
                    backgroundColor: Colors.black.withAlpha(80),
                    iconSize: 30,
                    selectedIndex: _currentIndex,
                    onItemSelected: (index) => setState(() => {
                          _currentIndex = index,
                          _pageController.animateToPage(index,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeInOutCirc)
                        }),
                    items: [
                      BottomNavyBarItem(
                          icon: Icon(Icons.perm_device_information),
                          title: Text('Overview'),
                          activeColor: Colors.white),
                      BottomNavyBarItem(
                          icon: Icon(Icons.videocam_outlined),
                          title: Text('Camera'),
                          activeColor: Colors.white),
                      BottomNavyBarItem(
                          icon: Icon(Icons.settings),
                          title: Text('Settings'),
                          activeColor: Colors.white)
                    ],
                  ),
                  action: PlatformInfo.isAppOS()
                      ? BluetoothConnectionButton()
                      : null,
                  body: child),
            );
          },
          child: PageView(
            controller: _pageController,
            onPageChanged: (value) => setState(() => {_currentIndex = value}),
            children: [OverviewSubpage(), CameraSubpage(), SettingsSubpage()],
          ));
    });
  }
}
