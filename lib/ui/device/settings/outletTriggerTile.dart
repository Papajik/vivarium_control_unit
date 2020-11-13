import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/outletTrigger.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class OutletTriggerTile extends StatefulWidget {
  final OutletTrigger trigger;
  final ValueChanged<OutletTrigger> onChanged;

  const OutletTriggerTile({Key key, this.trigger, this.onChanged})
      : super(key: key);

  @override
  _OutletTriggerTileState createState() => _OutletTriggerTileState();
}

class _OutletTriggerTileState extends State<OutletTriggerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: DateTimePicker(
                type: DateTimePickerType.time,
                initialValue: getTimeStringFromTime(widget.trigger.time),
                timeLabelText: 'Time',
                onChanged: (val) => {
                      widget.trigger.time = getTimeFromString(val),
                      widget.onChanged(widget.trigger)
                    },
                icon: Icon(Icons.access_time)),
          ),
          Switch(
            value:widget.trigger.outletOn,
            onChanged: (val) async{
              widget.trigger.outletOn = val;
              widget.onChanged(widget.trigger);
            },
          ),
          Text(widget.trigger.outletOn ? 'Turn on' : 'Turn off'),
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
      ),
    );
  }

  void handleClick(String value, BuildContext context) async {
    print('handle click');
    print(value);
    switch (value) {
      case 'Delete':
        await widget.trigger.delete();
        print('delete');
        widget.onChanged(null);
        break;
    }
  }
}
