import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/sign_in.dart';



class HomePage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<HomePage> {
  bool _signed = false;
  String _userName = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vivarium control"),
        actions: <Widget>[
          FlatButton.icon(
            icon: ImageIcon(
             _signed ? AssetImage(""):AssetImage("assets/google_logo.png"),
            ),
            label: Text(_signed ? _userName : Constants.of(context).notSignedText ),
            onPressed: () {
              if (!_signed) {
                signInWithGoogle().whenComplete(() {
                  setState(() {
                    _userName = name + " - " + Constants.of(context).logoutText;
                    _signed = true;
                  });
                });
              } else {
                signOutGoogle();
                setState(() {
                  _signed = false;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),

            ],
          ),
        ),
      ),
    );
  }

}
