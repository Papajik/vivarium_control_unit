import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/ledColorDialog.dart';
import 'package:vivarium_control_unit/ui/device/settings/triggerDialogContainer.dart';
import 'package:vivarium_control_unit/utils/converters.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class LedTriggerDialog extends StatefulWidget {
  final String deviceId;
  final LedTrigger trigger;
  final String title;

  @required
  final ValueChanged<LedTrigger> onChanged;

  const LedTriggerDialog(
      {Key key,
      @required this.deviceId,
      @required this.trigger,
      @required this.onChanged,
      @required this.title})
      : super(key: key);

  @override
  _LedTriggerDialogState createState() => _LedTriggerDialogState();
}

class _LedTriggerDialogState extends State<LedTriggerDialog> {
  int _selectedTime;
  Color _selectedColor;

  @override
  void initState() {
    print('ledTriggerDialog - init');
    if (widget.trigger != null) {
      _selectedTime = widget.trigger.time;
      _selectedColor = Color(widget.trigger.color);
    } else {
      print('new trigger');
      _selectedTime = 0;
      _selectedColor = Color(4283510184);
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
        print('saving trigger');
        print('selectedTime = $_selectedTime');
        print('selectedColor = $_selectedColor');
        if (widget.trigger == null) {
          var t =
              LedTrigger(time: _selectedTime, color: _selectedColor.value);
          await Hive.box<LedTrigger>(HiveBoxes.ledTriggerList + widget.deviceId)
              .add(t);
          widget.onChanged(t);
        } else {
          widget.trigger.color = _selectedColor.value;
          widget.trigger.time = _selectedTime;
          widget.onChanged(widget.trigger);
        }
        Navigator.pop(context);
      },
      child: FloatingActionButton(
          backgroundColor: _selectedColor,
          onPressed: () => showDialog(
                context: context,
                builder: (context) => LedColorDialog(
                    selectedColor: _selectedColor,
                    onChanged: (color) => {
                          setState(() => _selectedColor = color),
                          if (widget.trigger != null)
                            {
                              widget.trigger.color = color.value,
                            },
                        }),
              )),
    );
  }
}
