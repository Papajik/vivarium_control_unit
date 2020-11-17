import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/models/device/triggers/outletTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/triggerDialogContainer.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class OutletTriggerDialog extends StatefulWidget {
  final String boxId;
  final OutletTrigger trigger;
  final String title;
  final ValueChanged<OutletTrigger> onChanged;

  const OutletTriggerDialog(
      {Key key,
      @required this.boxId,
      @required this.trigger,
      @required this.title,
      @required this.onChanged})
      : super(key: key);

  @override
  _OutletTriggerDialogState createState() => _OutletTriggerDialogState();
}

class _OutletTriggerDialogState extends State<OutletTriggerDialog> {
  int _selectedTime;
  bool _isOn;

  @override
  void initState() {
    if (widget.trigger != null) {
      _selectedTime = widget.trigger.time;
      _isOn = widget.trigger.outletOn;
    } else {
      _selectedTime = 0;
      _isOn = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TriggerDialogContainer(
      title: widget.title,
      selectedTime: _selectedTime,
      onTimeChanged: (val) {
        setState(() {
          _selectedTime = getTimeFromString(val);
        });
      },
      onSaved: () async {
        if (widget.trigger == null) {
          var t = OutletTrigger(time: _selectedTime, outletOn: _isOn);
          await Hive.box<OutletTrigger>(widget.boxId).add(t);
          widget.onChanged(t);
        } else {
          widget.trigger.outletOn = _isOn;
          widget.trigger.time = _selectedTime;
          widget.onChanged(widget.trigger);
        }
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Text(_isOn ? 'Turn on' : 'Turn off'),
          Switch(
            onChanged: (val) => setState(() => {_isOn = val}),
            value: _isOn,
          ),
        ],
      ),
    );
  }
}
