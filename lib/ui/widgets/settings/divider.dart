import 'package:flutter/material.dart';

class SettingsDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  final double? height;
  final double? indent;
  final double? endIndent;
//  final double lineThickness;

  const SettingsDivider({Key? key, this.color, this.thickness, this.height, this.indent, this.endIndent}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height??35,
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,

    );
  }
}
