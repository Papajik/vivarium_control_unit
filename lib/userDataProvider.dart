

import 'package:flutter/material.dart';

class UserDataProvider extends InheritedWidget {
  final String userID;
  final String photonSecret;



  UserDataProvider({
    Widget child,
    this.userID,
    this.photonSecret,
  }) : super(child: child);
  @override
  bool updateShouldNotify(UserDataProvider oldWidget) => false;
  static UserDataProvider of(BuildContext context) =>         context.inheritFromWidgetOfExactType(UserDataProvider);
}