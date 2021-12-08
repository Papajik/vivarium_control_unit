import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/modules/feeder/trigger.dart';
import 'package:vivarium_control_unit/utils/converters.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class FeederTriggerTile extends StatelessWidget {
  final String? feederKey;
  final FeedTrigger? trigger;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onChanged;

  const FeederTriggerTile(
      {Key? key, this.feederKey, this.trigger, this.onDelete, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Consumer<DeviceProvider>(
        builder: (context, provider, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 160,
                  child: DateTimePicker(
                      style: Theme.of(context).textTheme.headline4,
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.access_time,
                            color: Colors.white,
                          )),
                      type: DateTimePickerType.time,
                      initialValue: getTimeStringFromTime(trigger!.time),
                      timeLabelText: 'Time',
                      onChanged: (val) => {
                            provider.saveValue(
                                key:
                                    FEEDER_TRIGGERS + '/' + feederKey! + '/time',
                                value: getTimeFromString(val)),
                            onChanged!(getTimeFromString(val))
                          },
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            PopupMenuButton(
              color: Colors.black12,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: (dynamic val) {
                switch (val) {
                  case 'Delete':
                    provider.saveValue(
                        key: FEEDER_TRIGGERS + '/' + feederKey!, value: null);
                    onDelete!();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice,
                        style: Theme.of(context).textTheme.headline4),
                  );
                }).toList();
              },
            )
          ],
        ),
      ),
    );
  }
}
