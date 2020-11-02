import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class TriggerDialogContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final ValueChanged<String> onTimeChanged;
  final VoidCallback onSaved;
  final int selectedTime;

  const TriggerDialogContainer(
      {Key key,
      @required this.child,
      @required this.onTimeChanged,
      @required this.selectedTime,
      @required this.title,
      @required this.onSaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("triggerDialogContainer");
    return AlertDialog(
      title: Text("New timer"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 100,
            child: DateTimePicker(
                type: DateTimePickerType.time,
                initialValue: getTimeStringFromTime(selectedTime),
                timeLabelText: "Time",
                onChanged: onTimeChanged,
                icon: Icon(Icons.access_time)),
          ),
          child
        ],
      ),
      actions: [
        RaisedButton(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: onSaved,
        ),
      ],
    );
  }
}
