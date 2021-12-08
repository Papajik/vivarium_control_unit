import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/drawer_list_tile.dart';

class DrawerBodyWidget extends StatefulWidget {
  @override
  _DrawerBodyWidgetState createState() => _DrawerBodyWidgetState();
}

class _DrawerBodyWidgetState extends State<DrawerBodyWidget> {
  int currentSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Consumer2<NavigationPage, VivariumUser>(
      builder: (context, navigationPage, user, child) => ListView.separated(
        separatorBuilder: (context, index) => Divider(height: 20),
        itemBuilder: (context, index) => DrawerListTile(
          onTap: () =>
              user.isSignedIn || navigationItems[index].anonymousAccess
                  ? Navigator.of(context).pushNamedAndRemoveUntil(
                      navigationItems[index].route,
                      ModalRoute.withName(Routes.home))
                  : null,
          title: navigationItems[index].title,
          isActive:
              user.isSignedIn|| navigationItems[index].anonymousAccess,
          icon: navigationItems[index].icon,
          isSelected: navigationItems[index].page == navigationPage,
        ),
        itemCount: navigationItems.length,
      ),
    ));
  }
}
