import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/drawer_list_tile.dart';

class DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Consumer2<VivariumUser, NavigationPage>(
        builder: (context, user, page, child) {
          if (user.isSignedIn) {
            return _buildUserHeader(user);
          } else {
            return _buildAnonymousHeader(page, context);
          }
        },
      ),
    );
  }

  Widget _buildUserHeader(VivariumUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.imageUrl != null)
          Container(
              height: 50,
              child: Image.network(
                user.imageUrl!,
                errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
              )),
        Container(height: 15),
        Text(
            (user.userName ?? '') == ''
                ? user.userEmail!.split('@').first
                : user.userName!,
            style: TextStyle(color: Colors.white, fontSize: 20)),
        Container(height: 15),
        SizedBox(
            height: 10,
            child: Center(
                child: Container(
                    margin: EdgeInsetsDirectional.only(end: 20),
                    height: 2,
                    color: Colors.white))),
        Container(height: 5)
      ],
    );
  }

  Widget _buildAnonymousHeader(NavigationPage page, context) {
    return DrawerListTile(
        isSelected: page == NavigationPage.SIGN_IN,
        title: 'Sign In',
        icon: Icons.login,
        onTap: () async => Navigator.pushNamed(context, Routes.login));
  }
}
