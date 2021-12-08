import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/homepage/homePage.dart';

void testHomePage(Size? size) {
  testWidgets('HomePage Without User', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);

    await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home:
                Provider<VivariumUser?>.value(value: null, child: HomePage()))));

    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Devices'), findsNothing);
  });

  testWidgets('HomePage With User', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);

    await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Provider<VivariumUser>.value(
                value: VivariumUser(userEmail: 'user@email.cz'),
                child: HomePage()))));

    expect(find.text('Sign in with Google'), findsNothing);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('user@email.cz'), findsOneWidget);
  });
}
