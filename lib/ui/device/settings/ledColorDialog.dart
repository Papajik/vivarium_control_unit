import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class LedColorDialog extends StatefulWidget {
  final ValueChanged<Color> onChanged;
  final Color selectedColor;

  const LedColorDialog({Key key, @required this.onChanged, this.selectedColor})
      : super(key: key);

  @override
  _LedColorDialogState createState() => _LedColorDialogState();
}

class _LedColorDialogState extends State<LedColorDialog> {
  Color selectedColor;

  @override
  void initState() {
    selectedColor = widget.selectedColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(6.0),
        title: Text("Pick a Color"),
        content: MaterialColorPicker(
          selectedColor: selectedColor,
          onColorChange: (color) =>
              {selectedColor = color, widget.onChanged(color)},
          shrinkWrap: true,
        ));
  }
}
