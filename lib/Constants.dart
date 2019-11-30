import 'package:flutter/material.dart';

class Constants extends InheritedWidget {
  static Constants of(BuildContext context) => context.inheritFromWidgetOfExactType(Constants);

  const Constants({Widget child, Key key}): super(key: key, child: child);

  final String logoutText = "Log out";
  final String notSignedText = "Sign in with google";

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }


}