import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/router.dart' as c_router;
import 'package:vivarium_control_unit/utils/backgroundService/service.dart';
import 'package:vivarium_control_unit/utils/firebase/auth.dart';
import 'package:vivarium_control_unit/utils/firebase/databaseService.dart';
import 'package:vivarium_control_unit/utils/firebase/messagingService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize firebase
  await Firebase.initializeApp();

  /// Offline persistence
  await DatabaseService.setPersistence();

  /// Initialize FCM
  MessagingService.initMessagingService();

  /// Refreshing FCM Token
  MessagingService.onTokenRefresh().listen((token) {
    if (Auth.user.isSignedIn)
      DatabaseService().setFCMToken(userId: Auth.user.userId!, token: token);
  });

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await BackgroundService.start();

  runApp(VivariumApp());
}

class VivariumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<VivariumUser?>.value(
              value: Auth.userStream, initialData: Auth.user),
        ],
        builder: (context, child) => child ?? SizedBox.shrink(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Vivarium Control Unit',
            theme: _theme(),
            initialRoute: c_router.Routes.home,
            onGenerateRoute: c_router.Router.generateRoute,
            routes: c_router.defaultRoutes()));
  }

  ThemeData _theme() {
    return ThemeData(
        toggleableActiveColor: Colors.cyan,
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue.shade600,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: Colors.grey.withOpacity(0.8),
                onPrimary: Colors.white,
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                minimumSize: Size(100, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))))),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        accentColor: Colors.grey.shade800,
        backgroundColor: Colors.grey.shade100,
        fontFamily: 'Georgia',
        bottomAppBarColor: Colors.blue.shade100,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black26,
          unselectedItemColor: Colors.white.withOpacity(0.8),
          selectedIconTheme: IconThemeData(size: 30),
          selectedItemColor: Colors.white,
          elevation: 3,
        ),
        textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 14),
            headline4: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            headline5: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
            headline6: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
            button: TextStyle(color: Colors.red)));
  }
}
