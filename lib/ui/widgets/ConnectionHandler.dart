import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';

class ConnectionHandler extends StatefulWidget {
  final Widget? child;

  const ConnectionHandler({Key? key, this.child}) : super(key: key);

  @override
  _ConnectionHandlerState createState() => _ConnectionHandlerState();
}

class _ConnectionHandlerState extends State<ConnectionHandler> {
  late BluetoothConnector _connector;

  @override
  void initState() {
    _connector = Provider.of<BluetoothConnector>(context, listen: false);
    _connector.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DeviceConnectionState>(
      initialData: _connector.isConnected
          ? DeviceConnectionState.connected
          : DeviceConnectionState.disconnected,
      stream: _connector.connectionStateStream,
      builder: (context, snapshot) => snapshot.data ==
              DeviceConnectionState.connected
          ? widget.child!
          : Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    if (snapshot.data == DeviceConnectionState.connecting)
                      CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                          snapshot.data == DeviceConnectionState.connecting
                              ? 'Connecting'
                              : 'Connection failed',
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                    if (snapshot.data == DeviceConnectionState.disconnected)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () async => {
                            await _connector.disconnect(),
                            await _connector.connect()
                          },
                          child: Text('Retry'),
                        ),
                      )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _connector.disconnect().then((value) => _connector.dispose());
    super.dispose();
  }
}
