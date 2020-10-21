import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vivarium_control_unit/Constants.dart';
import 'package:vivarium_control_unit/ui/locations/LocationsPage.dart';
import 'package:vivarium_control_unit/ui/SettingsPage.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class HomePage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<HomePage> {
  bool _signed = false;
  String _userName = "";

  @override
  Widget build(BuildContext context) {
    _showLogInWarning(context) {
      Toast.show(Constants.of(context).signInWarningText, context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    _onTap(int index) {
      switch (index) {
        case 0:
          if (_signed) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new LocationsPage(uid: userId);
            }));
          } else {
            _showLogInWarning(context);
          }
          break;
        case 1:
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new SettingsPage();
          }));
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Vivarium control"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Padding(
              child: Image(
                image:_signed
                    ? Image.network(imageUrl).image
                    : AssetImage("assets/google_logo.png"),
                color:null,
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
              ),padding: EdgeInsets.all(10),
            ),
            label:
                Text(_signed ? _userName : Constants.of(context).notSignedText),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Locations",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
              backgroundColor: Colors.blue),
        ],
        onTap: _onTap,
        iconSize: 30,
        backgroundColor: Colors.blue[100],
        unselectedItemColor: Colors.blueGrey[900],
        selectedItemColor: Colors.blueGrey[900],
      ),
    );
  }
}
