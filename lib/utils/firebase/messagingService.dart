import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'vivarium_channel', // id
    'Vivarium Module Notifications', // title
    description:
        'This channel is used for notifications from vivarium modules.',
    importance: Importance.high,
  );

  static final AndroidNotificationChannel _silentChannel =
      AndroidNotificationChannel(
          'vivarium_silent', 'Vivarium Silent Notifications',
          description:
              'This channel is used for silent notifications from vivarium modules.',
          playSound: false,
          enableVibration: false);

  static void initMessagingService() async {
    /// Foreground iOS
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,

      /// Required to display a heads up notification
      badge: true,
      sound: true,
    );

    /// Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_silentChannel);

    /// Set background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Set foreground handler
    MessagingService.listenForegroundMessages();
  }

  static Stream<String> onTokenRefresh() => _messaging.onTokenRefresh;

  /// Nothing much to do as notification is already displayed without any inconvenience
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  static Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Fluttertoast.showToast(
            msg: message.notification!.title! +
                '\n' +
                message.notification!.body!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade700,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
