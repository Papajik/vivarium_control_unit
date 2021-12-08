import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vivarium_control_unit/ui/login/loginForm.dart';
import 'package:vivarium_control_unit/ui/login/loginInfo.dart';


void testLogin(Size? size) {
  testWidgets('Login form', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
    TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);

    await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Scaffold(body: LoginForm()))));

    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('Login Info', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
    TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);

    await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Scaffold(body: LoginInfo(textToRow: false,)))));

    expect(find.text("Don't have an account?"), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

  });


}
