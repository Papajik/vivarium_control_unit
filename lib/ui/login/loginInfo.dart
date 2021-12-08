import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/router.dart';

class LoginInfo extends StatelessWidget {
  final bool showImage;
  final bool textToRow;

  const LoginInfo({Key? key, this.showImage = true, this.textToRow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    if (showImage) {
      widgets.addAll([
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: 200,
            child: Image.asset('assets/icons/circle/aquarium_512.png'),
          ),
        ),
        SizedBox(height: 20)
      ]);
    }

    var loginInfo = <Widget>[];
    loginInfo.addAll([
      Text("Don't have an account?",
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 18)),
      Container(
        height: 30,
        child: TextButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, Routes.register),
          child: Text(
            'Sign up',
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
      )
    ]);

    if (textToRow) {
      widgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: loginInfo,
      ));
    } else {
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: loginInfo,
      ));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: widgets);
  }
}
