import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vivarium_control_unit/models/feedTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/feedTriggerDialog.dart';
import 'package:vivarium_control_unit/ui/device/settings/feedTriggerTile.dart';
import 'package:vivarium_control_unit/utils/hiveBoxes.dart';

class SettingsFeedList extends StatefulWidget {
  @required
  final String deviceId;
  @required
  final ValueChanged<String> onChanged;

  const SettingsFeedList({Key key, this.deviceId, this.onChanged})
      : super(key: key);

  @override
  _SettingsFeedListState createState() => _SettingsFeedListState();
}

class _SettingsFeedListState extends State<SettingsFeedList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("feedTriggerList - build");
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<FeedTrigger>(HiveBoxes.feedTriggerList + widget.deviceId)
              .listenable(),
      builder: (context, Box<FeedTrigger> box, _) {
        print("feedTriggerList - builder");
        List<Widget> widgets = new List<Widget>();
        List<FeedTrigger> list = box.values.toList();
        list.sort((a, b) => a.time.compareTo(b.time));

        list.forEach((element) {
          widgets.add(SettingsFeedTile(
            trigger: element,
            onChanged: (val) => {widget.onChanged("")},
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
                  return FeedTriggerDialog(
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
