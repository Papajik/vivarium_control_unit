import 'package:flutter/material.dart';

class Constants extends InheritedWidget {
  static Constants of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType();

  const Constants({Widget child, Key key}) : super(key: key, child: child);

  final String logoutText = "Log out";
  final String notSignedText = "Sign In";
  final String signInWarningText = "You need to sign in first";

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
