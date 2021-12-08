import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/drawer_list_tile.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';

class DrawerSignOutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VivariumUser>(
      builder: (context, user, child) => (user.isSignedIn)
          ? DrawerListTile(
              title: 'Sign out',
              onTap: () async {
                await Auth().signOut();
                await Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (Route<dynamic> route) => false);
              },
              isSelected: false,
              icon: Icons.logout,
            )
          : Container(),
    );
  }
}
