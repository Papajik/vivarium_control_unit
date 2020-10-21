import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/ledColorDialog.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class LedTriggerTile extends StatefulWidget {
  @required
  final LedTrigger trigger;
  @required
  final ValueChanged<LedTrigger> onChanged;

  const LedTriggerTile({Key key, this.trigger, this.onChanged})
      : super(key: key);

  @override
  _LedTriggerTileState createState() => _LedTriggerTileState();
}

class _LedTriggerTileState extends State<LedTriggerTile> {
//  Color _selectedColor;

  @override
  void initState() {
    //  _selectedColor = Color(widget.trigger.color);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ledTriggerTile build = ${widget.trigger}");
    return Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*
            Time
             */
            SizedBox(
              width: 120,
              child: DateTimePicker(
                  type: DateTimePickerType.time,
                  initialValue: getWidgetTime(),
                  timeLabelText: "Time",
                  onChanged: (val) => {
                        widget.trigger.time = getTimeFromString(val),
                        widget.onChanged(widget.trigger)
                      },
                  icon: Icon(Icons.access_time)),
            ),
            ledOn() ? Text("Turn on") : Text("Turn off"),
            Switch(
              value: widget.trigger.color != 0,
              onChanged: (val) async {
                print(val);
                if (val) {
                  widget.trigger.color = 4294966759;
                } else {
                  widget.trigger.color = 0;
                }
                widget.onChanged(widget.trigger);
              },
            ),
            /*
            Color
             */
            if (ledOn())
              Container(
                width: 56,
                height: 56,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  elevation: 0,
                  child: Icon(Icons.circle, color: Color(widget.trigger.color)),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => LedColorDialog(
                        selectedColor: Color(widget.trigger.color),
                        onChanged: (color) => {
                              widget.trigger.color = color.value,
                              widget.onChanged(widget.trigger),
                              setState(() => {
                                    //_selectedColor = color
                                  })
                            }),
                  ),
                ),
              )
            else
              (SizedBox(
                width: 56,
              )),
            PopupMenuButton(onSelected: (val) {
              handleClick(val, context);
            }, itemBuilder: (BuildContext context) {
              return {'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            })
          ],
        ));
  }

  void handleClick(String value, BuildContext context) async {
    print("handle click");
    print(value);
    switch (value) {
      case 'Delete':
        await widget.trigger.delete();
        print("delete");
        widget.onChanged(null);
        break;
    }
  }

  String getWidgetTime() {
    String lsHour =
        getHourFromTime(widget.trigger.time).toString().padLeft(2, '0');
    String lsMinute =
        getMinuteFromTime(widget.trigger.time).toString().padLeft(2, '0');
    print("widget time = ${lsHour + ":" + lsMinute}");
    return lsHour + ":" + lsMinute;
  }

  bool ledOn() {
    return widget.trigger.color != 0;
  }
}
