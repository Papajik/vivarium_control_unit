import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/drawer/navigationModel.dart';
import 'package:vivarium_control_unit/ui/widgets/navigationDrawer/navigationDrawer.dart';

/// Base representation of application page
/// Should be root of every page
/// Handles navigation
class SkeletonPage extends StatelessWidget {
  final bool hideOverlay;
  final Widget? body;
  final Widget? floatingActionButton;
  final bool useBackground;
  final String appBarTitle;
  final NavigationPage? navigationPage;
  final Widget? bottomNavigationBar;
  final Widget? action;
  final bool enableBackButton;

  SkeletonPage(
      {Key? key,
      this.body,
      this.appBarTitle = '',
      this.useBackground = true,
      this.navigationPage,
      this.floatingActionButton,
      this.bottomNavigationBar,
      this.action,
      this.enableBackButton = true,
      this.hideOverlay = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          floatingActionButton: floatingActionButton,
          appBar: hideOverlay
              ? null
              : AppBar(
                  toolbarHeight: 60,
                  shadowColor: Colors.black,
                  backgroundColor: Colors.black.withAlpha(80),
                  elevation: 0,
                  title: Text(
                    appBarTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w700),
                  ),
                  actions: <Widget>[if (action != null) action!],
                ),
          bottomNavigationBar: hideOverlay ? null : bottomNavigationBar,
          drawer: Provider<NavigationPage?>.value(
              value: navigationPage, child: NavigationDrawer()),
          drawerEnableOpenDragGesture: true,
          body: Container(
              //    color: Colors.red,
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background/main_full.jpg'),
                      fit: BoxFit.cover)),
              child: Padding(
                  padding: const EdgeInsets.only(top: 0), child: body))),
    );
  }

  Future<bool> _onWillPop() async {
    return enableBackButton;
  }
}
//
