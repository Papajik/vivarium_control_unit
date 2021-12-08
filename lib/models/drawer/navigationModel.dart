import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vivarium_control_unit/ui/router.dart';

class NavigationModel {
  final String title;
  final IconData icon;
  final NavigationPage page;
  final String route;
  final bool anonymousAccess;

  NavigationModel(
      {required this.anonymousAccess,
      required this.page,
      required this.title,
      required this.icon,
      required this.route});
}

/// Definition of all navigation pages to which drawer can lead
enum NavigationPage { HOME, DEVICES, SETTINGS, SIGN_IN, REGISTER }

List<NavigationModel> navigationItems = [
  NavigationModel(
      page: NavigationPage.HOME,
      title: 'Home',
      anonymousAccess: true,
      icon: Icons.home,
      route: Routes.home),
  NavigationModel(
      anonymousAccess: false,
      page: NavigationPage.DEVICES,
      title: 'Devices',
      icon: FontAwesomeIcons.fish,
      route: Routes.userDevices),
  NavigationModel(
      page: NavigationPage.SETTINGS,
      anonymousAccess: false,
      title: 'Settings',
      icon: Icons.settings,
      route: Routes.settings),
];
