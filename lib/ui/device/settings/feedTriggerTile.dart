import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device/triggers/feedTrigger.dart';
import 'package:vivarium_control_unit/ui/device/settings/feedTriggerDialog.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class SettingsFeedTile extends StatefulWidget {
  @required
  final FeedTrigger trigger;
  @required
  final ValueChanged<String> onChanged;

  const SettingsFeedTile({Key key, this.trigger, this.onChanged})
      : super(key: key);

  @override
  _SettingsFeedTileState createState() => _SettingsFeedTileState();
}

class _SettingsFeedTileState extends State<SettingsFeedTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getWidgetTime(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type',
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        widget.trigger.type.toString().split('.').last,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            PopupMenuButton(onSelected: (val) {
              handleClick(val, context);
            }, itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
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
    print('handle click');
    print(value);
    switch (value) {
      case 'Edit':
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return FeedTriggerDialog(
                  trigger: widget.trigger,
                  deviceId: null,
                  onChanged: widget.onChanged);
            });
        break;
      case 'Delete':
        await widget.trigger.delete();
        print('delete');
        widget.onChanged('');
        break;
    }
  }

  String getWidgetTime() {
    var lsHour =
        getHourFromTime(widget.trigger.time).toString().padLeft(2, '0');
    var lsMinute =
        getMinuteFromTime(widget.trigger.time).toString().padLeft(2, '0');
    return lsHour + ':' + lsMinute;
  }
}
