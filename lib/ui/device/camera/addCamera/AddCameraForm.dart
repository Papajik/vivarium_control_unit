import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/bluetoothDevice/bluetoothDevice.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/utils/bluetooth/bluetoothConnector.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';

class AddCameraForm extends StatefulWidget {
  final BluetoothDevice? device;
  final TextStyle? headlineStyle;

  const AddCameraForm({Key? key, required this.device, this.headlineStyle})
      : super(key: key);

  @override
  _AddCameraFormState createState() => _AddCameraFormState();
}

class _AddCameraFormState extends State<AddCameraForm> {
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
    _ssidController = TextEditingController()..text = '';
    _passwordController = TextEditingController()..text = '';

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
                return _buildClaimedInfo();
              case ClaimStatus.NOT_CLAIMED:
                return _buildClaimForm();
              case ClaimStatus.UNKNOWN_DEVICE:
              default:
                return _buildUnknownDevice();
            }
          },
        ));
  }

  Widget _buildUnknownDevice() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Text('Unrecognized device. \nThis device can not be claimed',
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
              Navigator.pop(context);
          },
          child: Text('Back'),
        )
      ],
    );
  }

  Widget _buildClaimedInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Text(
          'This device is already claimed. If you want to set new user, please unclaim the device by pushing the reset button on the device.',
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildClaimForm() {
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
                onPressed: () async => await claimDevice(),
                child: Text('Claim'),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _textVisible,
          child: Text("Couldn't claim the device",
              style: Theme.of(context).textTheme.headline5),
        ),
        Visibility(
          visible: _claiming,
          child: CircularProgressIndicator(),
        )
      ],
    );
  }

  Future<void> claimDevice() async {
    setState(() {
      _claiming = true;
      _claimingText = 'Claiming device';
    });
    ///  APP <-> DEVICE
    var claimed = await _connector.claimCamera(
      deviceFirebaseId: widget.device!.firebaseId!,
      name: _nameController!.text,
      userId: Provider.of<VivariumUser>(context, listen: false).userId!,
      password: _passwordController!.text,
      ssid: _ssidController!.text,
    );

    /// APP <-> Firebase
    setState(() {
      _claimingText = 'Uploading to cloud';
    });

    if (claimed) {
      await DatabaseService().saveItem(
          deviceId: widget.device!.firebaseId!, value: true, key: CAMERA_ACTIVE);
      await _connector.disconnect().then((value) => _connector.dispose());
      Navigator.popUntil(context, (route) => route.settings.name == Routes.device);
    } else {
      setState(() {
        _textVisible = true;
        _claiming = false;
      });
      await _connector.unclaimCamera(deviceId: widget.device!.macAddress);
      return;
    }
  }

  @override
  void dispose() {
    _connector.disconnect().then((value) => _connector.dispose());
    super.dispose();
  }
}
