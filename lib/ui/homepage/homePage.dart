import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/homepage/anonymousBig.dart';
import 'package:vivarium_control_unit/ui/homepage/anonymousSmall.dart';
import 'package:vivarium_control_unit/ui/homepage/userOverview/overview.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';

class HomePage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _runFirst();
  }

  Future<void> _runFirst() async {}

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      enableBackButton: false,
      navigationPage: NavigationPage.HOME,
      appBarTitle: 'Vivarium Control',
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Consumer<VivariumUser>(
              builder: (context, user, child) {
                if (!user.isSignedIn) {
                  return (constraints.maxWidth < 600)
                      ? AnonymousSmall(width: constraints.maxWidth)
                      : AnonymousBig();
                } else {
                  return UserSmall();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
