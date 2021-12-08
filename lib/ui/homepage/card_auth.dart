import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';
import 'package:vivarium_control_unit/utils/firebase/googleAuth/googleAuth.dart';

class CardAuth extends StatelessWidget {

  final double width;

  const CardAuth({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 35,
          child: Center(
              child: Image.asset('assets/icons/circle/aquarium_512.png')),
        ),
        Expanded(
          flex: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, Routes.login),
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: Center(
                    child: Text('Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, Routes.register),
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: Center(
                    child: Text('Sign up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: SizedBox(
                height: 40,
                child: OutlinedButton(
                    onPressed: () async => Auth()
                            .signInWithCredentialObj(await googleAuth.signIn())
                            .then((user) async {
                          if (user.isSignedIn) {
                            await Auth().onUserLoggedIn(user.userId!);
                          }
                        }),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.white),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image(
                            image: AssetImage('assets/google_logo.png'),
                            height: 30),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              width > 250
                                  ? 'Sign in with Google'
                                  : 'Google',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )),
                      ],
                    )),
              ))
            ],
          ),
        )
      ],
    );
  }
}
