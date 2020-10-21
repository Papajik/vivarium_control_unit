import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vivarium_control_unit/models/ledTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/ledTriggerDialog.dart';
import 'package:vivarium_control_unit/ui/device/settings/ledTriggerTile.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class LedTriggerList extends StatefulWidget {
  @required
  final String deviceId;
  @required
  final ValueChanged<LedTrigger> onChanged;

  const LedTriggerList({Key key, this.deviceId, this.onChanged})
      : super(key: key);

  @override
  _LedTriggerListState createState() => _LedTriggerListState();
}

class _LedTriggerListState extends State<LedTriggerList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("building led trigger list");
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<LedTrigger>(HiveBoxes.ledTriggerList + widget.deviceId)
              .listenable(),
      builder: (context, Box<LedTrigger> box, _) {
        List<Widget> widgets = new List<Widget>();
        List<LedTrigger> list = box.values.toList();
        list.sort((a, b) => a.time.compareTo(b.time));
        print("Sorted list = $list");
        list.forEach((element) {
          widgets.add(LedTriggerTile(
              trigger: element,
              onChanged: (trigger) => {
                    print("LedTriggerList - LedTriggerTile - onChanged"),
                    widget.onChanged(trigger),
                    setState(() => {print("LedTriggerList - setState")})
                  }));
          widgets.add(Divider(
            color: Colors.lightBlue,
            height: 2.0,
            indent: 50,
            endIndent: 20,
            thickness: 2,
          ));
        });

        widgets.add(RaisedButton(
          child: Text("Create new timer"),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return LedTriggerDialog(
                    title: "Add timer",
                    trigger: null,
                    deviceId: widget.deviceId,
                    onChanged: widget.onChanged,
                  );
                });
          },
        ));
        return Column(
          children: widgets,
        );
      },
    );
  }
}
