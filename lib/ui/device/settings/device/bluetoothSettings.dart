import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/ui/common/styles.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';

class BluetoothSettings extends StatelessWidget {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceConnectionState>(
        builder: (context, connectionState, child) => connectionState ==
                DeviceConnectionState.connected
            ? Card(
                color: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Text(
                        'Wi-Fi Credentials',
                        style:
                            TextStyle(fontSize: 26, color: Colors.cyanAccent),
                      ),
                      Divider(
                        height: 35,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: inputDecoration('WiFi SSID'),
                        controller: ssidController,
                      ),
                      TextFormField(
                        controller: passController,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: inputDecoration('WiFi pass'),
                      ),
                      Divider(
                        height: 20,
                      ),
                      Consumer<BluetoothConnector>(
                        builder: (context, connector, child) => Center(
                          child: ElevatedButton(
                              onPressed: () async {
//
                                await connector.setCredentials(
                                    ssid: ssidController.text,
                                    pass: passController.text);
                              },
                              child: Text('Save New Credentials')),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox.shrink());
  }
}
