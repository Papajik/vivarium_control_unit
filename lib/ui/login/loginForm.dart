import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';

class LoginForm extends StatefulWidget {
  final TextStyle? headerStyle;
  final double? textFieldHeight;

  const LoginForm({Key? key, this.headerStyle, this.textFieldHeight})
      : super(key: key);

  @override
  _StateLogin createState() => _StateLogin();
}

class _StateLogin extends State<LoginForm> {
  TextEditingController? _textControllerEmail;
  TextEditingController? _textControllerPassword;

  FocusNode? _focusNodePassword;
  FocusNode? _focusNodeEmail;

  bool _isLogging = false;

  @override
  void initState() {
    _textControllerEmail = TextEditingController();
    _textControllerPassword = TextEditingController();

    _focusNodePassword = FocusNode();
    _focusNodeEmail = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8.0, top: 12.0),
                child: Text('Email address', style: widget.headerStyle),
              ),
              Container(
                height: widget.textFieldHeight,
                child: TextField(
                  focusNode: _focusNodeEmail,
                  autofocus: false,
                  controller: _textControllerEmail,
                  onSubmitted: (_) {
                    _focusNodeEmail!.unfocus();
                    FocusScope.of(context).requestFocus(_focusNodePassword);
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
//              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8.0, top: 8.0),
                child: Text('Password', style: widget.headerStyle),
              ),
              Container(
                height: widget.textFieldHeight,
                child: TextField(
                  focusNode: _focusNodePassword,
                  controller: _textControllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  onSubmitted: (_) async => await _loginWithEmail(context),
                ),
              ),
//              SizedBox(height: 40),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40,
                child: FlatButton(
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  onPressed: () async => _loginWithEmail(context),
                  child:
                      _isLogging ? CircularProgressIndicator() : Text('Log in'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  height: 15,
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Future<void> _loginWithEmail(BuildContext context) async {
    if (_isLogging) return null;
    var toast = FToast();
    toast.init(context);

    if (_textControllerPassword!.text.isEmpty ||
        _textControllerEmail!.text.isEmpty) {
      toast.showToast(
          child: Text(
        "Email and password can't be empty",
        style: TextStyle(fontSize: 14, color: Colors.white),
      ));
      return;
    }

    _focusNodePassword!.unfocus();
    _focusNodeEmail!.unfocus();

    setState(() {
      _isLogging = true;
    });
    await Auth()
        .signInWithEmailAndPassword(
            email: _textControllerEmail!.text,
            password: _textControllerPassword!.text)
        .then((user) async {
      if (user.isSignedIn) {
        await Auth().onUserLoggedIn(user.userId!);
        await Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        _textControllerEmail!.clear();
        _textControllerPassword!.clear();
        toast.showToast(
            child: Text(
          "Couldn't log in. Try to type your credentials again",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ));
        setState(() {
          _isLogging = false;
        });
      }
    });
  }
}
