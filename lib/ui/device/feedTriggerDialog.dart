import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class FeedTriggerDialog extends StatefulWidget {
  final String deviceId;
  final FeedTrigger trigger;
  @required
  final ValueChanged<String> onChanged;

  const FeedTriggerDialog({Key key, this.deviceId, this.trigger, this.onChanged})
      : super(key: key);

  @override
  _FeedTriggerDialogState createState() => _FeedTriggerDialogState();
}

class _FeedTriggerDialogState extends State<FeedTriggerDialog> {
  FeedType newFeederType = FeedType.BOX;
  String newFeederTime = "00:00";

  @override
  void initState() {
    if (widget.trigger != null) {
      newFeederType = widget.trigger.type;
      newFeederTime = widget.trigger.dateTime.hour.toString() +
          ":" +
          widget.trigger.dateTime.minute.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New timer"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DateTimePicker(
              type: DateTimePickerType.time,
              initialValue: newFeederTime,
              timeLabelText: "Time",
              onChanged: (val) {
                setState(() {
                  newFeederTime = val;
                });
              },
              icon: Icon(Icons.access_time)),
          DropdownButton<FeedType>(
            //TODO parse enums to readable strings
            value: newFeederType,
            items: FeedType.values.map((FeedType feedType) {
              return DropdownMenuItem<FeedType>(
                  value: feedType, child: Text(feedType.toString()));
            }).toList(),
            onChanged: (value) {
              setState(() {
                newFeederType = value;
              });
            },
          ),
        ],
      ),
      actions: [
        RaisedButton(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text(
            widget.trigger == null ? "Add timer" : "Save changes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            print("saving trigger");
            var t = newFeederTime.split(":");

            if (widget.trigger != null) {
              widget.trigger.dateTime =
                  DateTime(2000, 1, 1, int.parse(t[0]), int.parse(t[1]));
              widget.trigger.type = newFeederType;
              await widget.trigger.save();
              print("saved");
              widget.onChanged("");
              Navigator.pop(context);
              return;
            } else {
              Box<FeedTrigger> box =
              Hive.box(HiveBoxes.feedTriggerList + widget.deviceId);
              await box.add(FeedTrigger(
                  type: newFeederType,
                  dateTime:
                  DateTime(2000, 1, 1, int.parse(t[0]), int.parse(t[1]))));
            }
            widget.onChanged("");
            Navigator.pop(context);
            return;
          },
        ),
      ],
    );
  }
}
