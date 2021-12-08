import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/ui/common/styles.dart';
import 'package:vivarium_control_unit/ui/login/loginForm.dart';
import 'package:vivarium_control_unit/ui/login/loginInfo.dart';
import 'package:vivarium_control_unit/ui/widgets/card/bigCard.dart';
import 'package:vivarium_control_unit/ui/widgets/card/smallCard.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
        navigationPage: NavigationPage.SIGN_IN,
        appBarTitle: 'Login',
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > DeviceWidth.big) {
                return BigCard(
                    color: Colors.blueGrey.shade700.withAlpha(220),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: LoginInfo(),
                        ),
                        Expanded(
                          flex: 1,
                          child: LoginForm(
                              headerStyle: HeaderStyle.big,
                              textFieldHeight: TextFieldHeight.big),
                        )
                      ],
                    ));
              }
              return SmallCard(
                color: Colors.blueGrey.shade700.withAlpha(220),
                child: Column(
                  children: [
                    Expanded(
                      flex: constraints.maxWidth > 300 ? 65 : 130,
                      child: LoginForm(
                          headerStyle: HeaderStyle.small,
                          textFieldHeight: TextFieldHeight.small),
                    ),
                    Expanded(
                      flex: 35,
                      child: LoginInfo(
                          showImage: false,
                          textToRow: constraints.maxWidth > 280),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
