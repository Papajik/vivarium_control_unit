import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';
import 'package:vivarium_control_unit/utils/forms/formValidator.dart';

class RegisterForm extends StatefulWidget {
  final TextStyle? headerStyle;
  final TextStyle? errorStyle;
  final double? textFieldHeight;

  const RegisterForm(
      {Key? key, this.headerStyle, this.errorStyle, this.textFieldHeight})
      : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final double errorTextHeight = 20;

  TextEditingController? _textControllerEmail;
  TextEditingController? _textControllerPassword;
  TextEditingController? _textControllerPassword2;

  FocusNode? _focusNodePassword;
  FocusNode? _focusNodePassword2;
  FocusNode? _focusNodeEmail;

  bool _isEditingEmail = false;
  bool _isEditingPassword = false;
  bool _isEditingPassword2 = false;

  bool _iSProcessRunning = false;

  @override
  void initState() {
    _textControllerEmail = TextEditingController();
    _textControllerPassword = TextEditingController();
    _textControllerPassword2 = TextEditingController();

    _focusNodePassword = FocusNode();
    _focusNodePassword2 = FocusNode();
    _focusNodeEmail = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8.0, top: 16.0),
            child: Text('Email address', style: widget.headerStyle),
          ),
          Container(
            height: widget.textFieldHeight! + errorTextHeight,
            child: TextField(
              focusNode: _focusNodeEmail,
              autofocus: false,
              onChanged: (value) => setState(() => _isEditingEmail = true),
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
                  ),
                  errorText: _isEditingEmail
                      ? validateEmail(_textControllerEmail!.text)
                      : ' ',
                  errorStyle: widget.errorStyle),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8.0, top: 8.0),
            child: Text('Password', style: widget.headerStyle),
          ),
          Container(
            height: widget.textFieldHeight! + errorTextHeight,
            child: TextField(
              focusNode: _focusNodePassword,
              controller: _textControllerPassword,
              onChanged: (value) =>
                  setState(() => _isEditingPassword = true),
              obscureText: true,
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _isEditingPassword
                      ? validatePassword(_textControllerPassword!.text)
                      : ' ',
                  errorStyle: widget.errorStyle),
              onSubmitted: (_) {
                _focusNodePassword!.unfocus();
                FocusScope.of(context).requestFocus(_focusNodePassword2);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8.0, top: 8.0),
            child: Text('Password again', style: widget.headerStyle),
          ),
          Container(
            height: widget.textFieldHeight! + errorTextHeight,
            child: TextField(
              focusNode: _focusNodePassword2,
              controller: _textControllerPassword2,
              onChanged: (value) =>
                  setState(() => _isEditingPassword2 = true),
              obscureText: true,
              decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _isEditingPassword2
                      ? validateSecondPassword(
                          _textControllerPassword?.text,
                          _textControllerPassword2!.text)
                      : ' ',
                  errorStyle: widget.errorStyle),
              onSubmitted: (_) {
                _focusNodePassword2!.unfocus();
                _registerWithEmail();
              },
            ),
          ),
          Container(
              height: 40,
              child: FlatButton(
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  onPressed: _registerWithEmail,
                  child: _iSProcessRunning
                      ? CircularProgressIndicator()
                      : Text('Sign up'))),
        ],
      ),
    );
  }

  Future<void> _registerWithEmail() async {
    var toast = FToast();
    toast.init(context);

    _focusNodePassword!.unfocus();
    _focusNodePassword2!.unfocus();
    _focusNodeEmail!.unfocus();

    if (validateEmail(_textControllerEmail!.text).isEmpty &&
        validatePassword(_textControllerPassword!.text).isEmpty &&
        validateSecondPassword(
                _textControllerPassword!.text, _textControllerPassword2!.text)
            .isEmpty) {
      setState(() {
        _iSProcessRunning = true;
      });
      await Auth()
          .registerWithEmailPassword(
              email: _textControllerEmail!.text,
              password: _textControllerPassword!.text)
          .then((user) async {
        if (user.isSignedIn) {
          await Auth().onUserLoggedIn(user.userId!);
          await Navigator.pushReplacementNamed(context, Routes.home);
        } else {
          toast.showToast(
              child: Text(
            'Register failed, please try again',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ));
          _textControllerEmail!.clear();
          _textControllerPassword!.clear();
          _textControllerPassword2!.clear();
        }
      });
    } else {
      toast.showToast(
          child: Text(
        'Entry valid credentials',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ));
    }
  }
}
