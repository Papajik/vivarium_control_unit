import 'package:date_time_picker/date_time_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/device/modules/led/trigger.dart';
import 'package:vivarium_control_unit/utils/converters.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceKeys.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class LedTriggerTile extends StatefulWidget {
  final String ledKey;
  final LedTrigger trigger;
  final VoidCallback onDelete;
  final ValueChanged<int> onTimeChanged;
  final ValueChanged<int?> onColorChanged;

  const LedTriggerTile(
      {Key? key,
      required this.ledKey,
      required this.trigger,
      required this.onDelete,
      required this.onTimeChanged,
      required this.onColorChanged})
      : super(key: key);

  @override
  _LedTriggerTileState createState() => _LedTriggerTileState();
}

class _LedTriggerTileState extends State<LedTriggerTile> {
  int? selectedColor;

  @override
  void initState() {
    selectedColor = widget.trigger.color;
    super.initState();
  }

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
                      initialValue: getTimeStringFromTime(widget.trigger.time),
                      timeLabelText: 'Time',
                      onChanged: (val) => {
                            provider.saveValue(
                                key: LED_TRIGGERS +
                                    '/' +
                                    widget.ledKey +
                                    '/time',
                                value: getTimeFromString(val)),
                            widget.onTimeChanged(getTimeFromString(val))
                          },
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                ColorIndicator(
                  width: 30,
                  height: 30,
                  borderRadius: 4,
                  color: getColorFromInt(selectedColor!),
                  onSelect: () async {
                    final color = selectedColor;
                    if (!(await colorPickerDialog())) {
                      setState(() {
                        selectedColor = color;
                      });
                    } else {
                      await provider.saveValue(
                          key: LED_TRIGGERS + '/' + widget.ledKey + '/color',
                          value: selectedColor);
                      widget.onColorChanged(selectedColor);
                    }
                  },
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
                        key: LED_TRIGGERS + '/' + widget.ledKey,
                        value: null);
                    widget.onDelete();
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

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: getColorFromInt(selectedColor!),
      onColorChanged: (Color color) {
        setState(() => selectedColor = getIntFromColor(color));
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 250,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,

      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      // Showing color code prefix and text styled differently in the dialog.
      colorCodeTextStyle: Theme.of(context).textTheme.bodyText2,
      colorCodePrefixStyle: Theme.of(context).textTheme.caption,
      // Showing the new thumb color property option in dialog version
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.wheel: true,
        ColorPickerType.custom: false,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
}
