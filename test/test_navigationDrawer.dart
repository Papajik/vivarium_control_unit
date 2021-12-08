import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/navigationDrawer.dart';

void testNavigationDrawer(Size? size) {
  testWidgets('NavigationDrawer - no user', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);

    await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: MultiProvider(providers: [
          Provider<VivariumUser?>.value(value: null),
          Provider<NavigationPage>.value(value: NavigationPage.values[0])
        ], child: NavigationDrawer()))));

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);
    expect(
        (tester
                .element(find.text(navigationItems[0].title))
                .findAncestorWidgetOfExactType<Container>()!
                .decoration as BoxDecoration)
            .color,
        Colors.transparent.withOpacity(0.3));
    expect(
        (tester
                .element(find.text(navigationItems[1].title))
                .findAncestorWidgetOfExactType<Container>()!
                .decoration as BoxDecoration)
            .color,
        Colors.transparent);

    expect(
        (tester.firstWidget(find.text(navigationItems[1].title)) as Text)
            .style!
            .color,
        Colors.grey.shade500);
    expect(
        (tester.firstWidget(find.text(navigationItems[2].title)) as Text)
            .style!
            .color,
        Colors.grey.shade500);
  });

  testWidgets('NavigationDrawer - with user', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding =
        TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(size);

    await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: MultiProvider(providers: [
          Provider<VivariumUser>.value(
              value: VivariumUser(userEmail: 'user@email.cz', imageUrl: '')),
          Provider<NavigationPage>.value(value: NavigationPage.values[1])
        ], child: NavigationDrawer()))));

    expect(
        (tester
                .element(find.text(navigationItems[0].title))
                .findAncestorWidgetOfExactType<Container>()!
                .decoration as BoxDecoration)
            .color,
        Colors.transparent);
    expect(
        (tester
                .element(find.text(navigationItems[1].title))
                .findAncestorWidgetOfExactType<Container>()!
                .decoration as BoxDecoration)
            .color,
        Colors.transparent.withOpacity(0.3));
    expect(find.text('Sign In'), findsNothing);
    expect(find.text('Sign out'), findsOneWidget);
    expect(
        (tester.firstWidget(find.text(navigationItems[1].title)) as Text)
            .style!
            .color,
        Colors.white);
    expect(
        (tester.firstWidget(find.text(navigationItems[2].title)) as Text)
            .style!
            .color,
        Colors.white);
  });
}
