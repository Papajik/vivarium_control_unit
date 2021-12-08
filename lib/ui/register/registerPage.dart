import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/common/styles.dart';
import 'package:vivarium_control_unit/ui/register/registerForm.dart';
import 'package:vivarium_control_unit/ui/register/registerInfo.dart';
import 'package:vivarium_control_unit/ui/widgets/card/bigCard.dart';
import 'package:vivarium_control_unit/ui/widgets/card/smallCard.dart';
import 'package:vivarium_control_unit/ui/widgets/skeletonPage.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      appBarTitle: 'Sign up',
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            var ratio = 2.0;
            if (constraints.maxWidth < 880)
              ratio = (2 * constraints.maxWidth) / 880;
            if (constraints.maxWidth > DeviceWidth.big) {
              return BigCard(
                maxHeight: 500,
                ratio: ratio,
                color: Colors.blueGrey.shade700.withAlpha(220),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: RegisterInfo()),
                    Expanded(
                        flex: 1,
                        child: RegisterForm(
                            errorStyle: ErrorStyle.big,
                            headerStyle: HeaderStyle.big,
                            textFieldHeight: TextFieldHeight.big))
                  ],
                ),
              );
            }

              return SmallCard(
                color: Colors.blueGrey.shade700.withAlpha(220),
                child: Column(
                  children: [
                    Expanded(
                        flex: 60,
                        child: RegisterForm(
                          textFieldHeight: TextFieldHeight.small,
                          errorStyle: ErrorStyle.small,
                          headerStyle: HeaderStyle.small,
                        )),
                    Expanded(flex: constraints.maxWidth>400?40:10, child: RegisterInfo(
                      showImage: constraints.maxWidth>400,
                      textToRow: constraints.maxWidth>300,
                    ))
                  ],
                ),
              );

          },
        ),
      ),
    );
  }
}
