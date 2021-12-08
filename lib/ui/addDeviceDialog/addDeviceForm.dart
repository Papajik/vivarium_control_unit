import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';

class AddDeviceForm extends StatefulWidget {
  final BluetoothDevice? device;
  final TextStyle? headlineStyle;

  const AddDeviceForm({Key? key, required this.device, this.headlineStyle})
      : super(key: key);

  @override
  _AddDeviceFormState createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  late BluetoothConnector _connector;

  TextEditingController? _nameController;
  TextEditingController? _ssidController;
  TextEditingController? _passwordController;

  FocusNode? _nameNode;
  FocusNode? _ssidNode;
  FocusNode? _passwordNode;

  late bool _textVisible;
  late bool _claiming;
  late String _claimingText;

  @override
  void initState() {
    _connector = Provider.of<BluetoothConnector>(context, listen: false);

    _claimingText = '';
    _textVisible = false;
    _claiming = false;

    _nameController = TextEditingController()..text = widget.device!.name;
    _ssidController = TextEditingController()..text = 'Papajik_2.4';
    _passwordController = TextEditingController()..text = '1477899633';

    _nameNode = FocusNode();
    _ssidNode = FocusNode();
    _passwordNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_claiming) {
      return Center(
          child: Column(
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(_claimingText,
                style: TextStyle(color: Colors.white, fontSize: 24)),
          )
        ],
      ));
    }

    return Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: FutureBuilder<ClaimStatus>(
          initialData: null,
          future: _connector.getClaimedStatus(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            switch (snapshot.data) {
              case ClaimStatus.CLAIMED:
                return _buildClaimedInfo(context);
              case ClaimStatus.NOT_CLAIMED:
                return _buildClaimForm(context);
              case ClaimStatus.UNKNOWN_DEVICE:
              default:
                return _buildUnknownDevice(context);
            }
          },
        ));
  }

  Widget _buildClaimedInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Text(
          'This device is already claimed. If you want to set new user, please unclaim the device by pressing factory reset button from vivarium settings.',
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildClaimForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: widget.headlineStyle),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            focusNode: _nameNode,
            controller: _nameController,
            onSubmitted: (_) {
              _nameNode!.unfocus();
              FocusScope.of(context).requestFocus(_ssidNode);
            },
          ),
        ),
        SizedBox(height: 20),
        Text('WiFi SSID', style: widget.headlineStyle),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            focusNode: _ssidNode,
            controller: _ssidController,
            onSubmitted: (_) {
              _ssidNode!.unfocus();
              FocusScope.of(context).requestFocus(_passwordNode);
            },
          ),
        ),
        SizedBox(height: 20),
        Text('WiFi password', style: widget.headlineStyle),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            focusNode: _passwordNode,
            controller: _passwordController,
            onSubmitted: (_) {
              _passwordNode!.unfocus();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: claimDevice,
                child: Text('Claim'),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _textVisible,
          child: Center(
              child: Text("Couldn't claim the device",
                  style: TextStyle(color: Colors.redAccent, fontSize: 14))),
        ),
        Visibility(
          visible: _claiming,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  /// Claiming process
  Future<void> claimDevice() async {
    if (_claiming) return;
    setState(() {
      _claiming = true;
      _claimingText = 'Claiming device';
    });

    /// First claim APP <-> DEVICE
    var deviceFirebaseId = await _connector.claimDevice(
        deviceId: widget.device!.macAddress,
        name: _nameController!.text,
        userId: Provider.of<VivariumUser>(context, listen: false).userId!,
        password: _passwordController!.text,
        ssid: _ssidController!.text);

    if (deviceFirebaseId == null) {
      setState(() {
        _textVisible = true;
        _claiming = false;
      });
      await _connector.unclaimDevice(deviceId: widget.device!.macAddress);
      return;
    }

    setState(() {
      _claimingText = 'Uploading to cloud';
    });

    /// Second claim APP <-> Database
    var device = await DatabaseService().addDevice(
        deviceId: deviceFirebaseId,
        name: _nameController!.text,
        deviceMac: widget.device!.macAddress,
        modules: _connector.modules ?? await _connector.getModules(),
        userId: Auth.user.userId!);
    if (device == null) {
      setState(() {
        _claimingText = 'Uploading Failed, reverting change';
      });
      await _connector.unclaimDevice(deviceId: widget.device!.macAddress);
      setState(() {
        _claiming = false;
        _textVisible = true;
      });
      return;
    } else {
      await _connector.disconnect();
      await Navigator.pushNamedAndRemoveUntil(
          context, Routes.device, ModalRoute.withName(Routes.userDevices),
          arguments: BluetoothDevice(
              name: device.info.name,
              macAddress: device.info.macAddress,
              firebaseId: device.info.id));
    }
  }

  Widget _buildUnknownDevice(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Text('Unrecognized device. \nThis device can not be claimed',
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
