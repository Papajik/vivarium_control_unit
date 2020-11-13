import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/bluetoothProvider.dart';
import 'package:vivarium_control_unit/utils/firebaseProvider.dart';

class AddBluetoothDeviceDialog extends StatefulWidget {
  final BluetoothProvider provider;

  const AddBluetoothDeviceDialog({Key key, this.provider}) : super(key: key);

  @override
  _AddBluetoothDeviceDialogState createState() =>
      _AddBluetoothDeviceDialogState();
}

class _AddBluetoothDeviceDialogState extends State<AddBluetoothDeviceDialog> {
  TextEditingController _controller;
  bool claimTriggered;

  @override
  void initState() {
    claimTriggered = false;
    try {
      widget.provider
          .connectBluetoothDevice()
          .then((value) => widget.provider.findBluetoothCharacteristic())
          .then((value) => widget.provider.startVerifyLocationJob());
    } catch (e) {
      print('caught error');
      print(e);
    }

    _controller = TextEditingController()..text = widget.provider.deviceName;

    widget.provider.claimingStepStream.listen((event) {
      if (event == ClaimingStep.CLAIMED) {
        sendClaimLocationQuery(
            locationId: widget.provider.deviceIdBuffer,
            name: _controller.text,
            macAddress: widget.provider.deviceMac);
        widget.provider.sendDisconnectedMsg();
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.provider.disconnectBluetoothDevice();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6.0),
      title: Text('Add new location'),
      content: SizedBox(
        width: 200,
        height: 100,
        child: StreamBuilder<ClaimingStep>(
          stream: widget.provider.claimingStepStream,
          builder: buildAlertBodyFromStream,
        ),
      ),
      actions: [
        StreamBuilder<ClaimingStep>(
          stream: widget.provider.claimingStepStream,
          builder: buildActionsFromStream,
        )
      ],
    );
  }

  Widget buildActionsFromStream(
      BuildContext context, AsyncSnapshot<ClaimingStep> snap) {
    var widgets = <Widget>[];
    var step = snap.data;

    if ((step?.index ?? 0) < ClaimingStep.CLAIMING.index) {
      widgets.add(buildAddLocationButton(context, step));
      widgets.add(RaisedButton(
        onPressed: () => Navigator.pop(context, 'canceled'),
        child: Text('Cancel'),
      ));
    }
    return Row(
      children: widgets,
    );
  }

  Widget buildAddLocationButton(BuildContext context, ClaimingStep step) {
    return RaisedButton(
        child: Text('Add location'),
        onPressed:
            (step == ClaimingStep.DEVICE_VERIFIED) ? _addLocation : null);
  }

  void _addLocation() {
    setState(() =>
        {claimTriggered = true, widget.provider.claimDevice(_controller.text)});
  }

  ///Builds a body depending on [ClaimingStep]
  Widget buildAlertBodyFromStream(
      BuildContext context, AsyncSnapshot<ClaimingStep> snap) {
    if (!snap.hasData || (snap.data.index < ClaimingStep.CONNECTED.index)) {
      return Column(
        children: [
          Center(child: CircularProgressIndicator()),
          Text('Connecting...')
        ],
      );
    }
    switch (snap.data) {
      case ClaimingStep.CONNECTED:
      case ClaimingStep.HANDSHAKE:
        return Column(
          children: [
            Center(child: CircularProgressIndicator()),
            Text('Handshake...')
          ],
        );
        break;
      case ClaimingStep.DEVICE_UNKNOWN:
        return SizedBox(
          height: 100,
          child: Text('Unknown device. Please select another device'),
        );
        break;
      case ClaimingStep.DEVICE_VERIFIED:
        return SizedBox(
          height: 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name'),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _controller,
                    ),
                  )
                ],
              )
            ],
          ),
        );
        break;
      case ClaimingStep.CLAIMING:
        return Column(
          children: [
            CircularProgressIndicator(),
            Text('Claiming device...'),
          ],
        );
        break;
      case ClaimingStep.CLAIMED:
        return Text('Device claimed, you may close this dialog');
        break;
      default:
        return Text("Shouldn't happen");
    }
  }
}
