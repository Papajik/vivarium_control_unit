import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void testHomePage(Size size) {
  testWidgets('HomePage Without User', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
    TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);


  });

  testWidgets('HomePage With User', (WidgetTester tester) async {

    final TestWidgetsFlutterBinding binding =
    TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);


  });
}
