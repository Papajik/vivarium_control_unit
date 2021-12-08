import 'package:flutter/material.dart';

enum DeviceSize { big, small, smallest }

class ButtonHeight {
  static double get big => 40;

  static double get small => 40;
}

class TextFieldHeight {
  static double get big => 60;

  static double get small => 50;

  static double get smallest => 40;
}

class DeviceWidth {
  static double get big => 600;

  static double get small => 400;
}

class HeaderStyle {
  static TextStyle get big =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);

  static TextStyle get small =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white);

  static TextStyle get smallest =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white);
}

class ErrorStyle {
  static TextStyle get big => TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      backgroundColor: Colors.black.withAlpha(30));

  static TextStyle get small => TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      backgroundColor: Colors.black.withAlpha(30));

  static TextStyle get smallest => TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      backgroundColor: Colors.black.withAlpha(30));
}

InputDecoration inputDecoration(String label,
    {double fontSize = 20, Color color = Colors.cyanAccent}) {
  return InputDecoration(
      labelText: label,
      fillColor: Colors.transparent,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(
          color: color, fontSize: fontSize, fontWeight: FontWeight.bold),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: UnderlineInputBorder());
}
