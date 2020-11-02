import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vivarium_control_unit/models/outletTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/outletTriggerDialog.dart';
import 'package:vivarium_control_unit/ui/device/settings/outletTriggerTile.dart';

class OutletTriggerList extends StatelessWidget {
  final String deviceId;
  final ValueChanged<OutletTrigger> onChanged;
  final String boxName;


  const OutletTriggerList(
      {Key key, this.deviceId, this.onChanged, this.boxName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<OutletTrigger>(boxName+ deviceId)
              .listenable(),
      builder: (context, Box<OutletTrigger> box, _) {
        List<Widget> widgets = new List<Widget>();
        List<OutletTrigger> list = box.values.toList();
        list.sort((a,b)=>a.time.compareTo(b.time));
        list.forEach((element) {
          widgets.add(OutletTriggerTile(
            trigger: element,
            onChanged: onChanged,
          ));
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
                  return OutletTriggerDialog(
                    title: "Add new outlet trigger",
                    trigger: null,
                    boxId: boxName+deviceId,
                    onChanged: onChanged,
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
