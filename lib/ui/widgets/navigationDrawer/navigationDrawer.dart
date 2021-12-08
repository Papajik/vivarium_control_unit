import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/drawer_body.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/drawer_header.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/drawer_sign_out.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 240,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.blueGrey.withAlpha(120)),
          child: Drawer(
              child: Container(
            child: Padding(
              padding: EdgeInsets.only(top:60.0, left: 16, right: 16, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DrawerHeaderWidget(),
                  DrawerBodyWidget(),
                  DrawerSignOutWidget()
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
