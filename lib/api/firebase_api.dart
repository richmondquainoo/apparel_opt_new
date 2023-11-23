

import 'dart:convert';

import 'package:apparel_options/Screens/LandingPage/NotificationScreen.dart';
import 'package:apparel_options/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: "This channel is used for important notification",
    importance: Importance.defaultImportance,

  );

  final _localNotifications = FlutterLocalNotificationsPlugin();


  Future<void> handleBackgroundMessage(RemoteMessage message)async {
    await Firebase.initializeApp();
    print("Title: ${message.notification!.title}");
    print("Body: ${message.notification!.body}");
    print("Payload: ${message.data}");
  }

  Future<void> initNotifications()async{
   await _firebaseMessaging.requestPermission();
   final fcmToken = await _firebaseMessaging.getToken();
   print("Token: ${fcmToken}");
   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
   initPushNotifications();
   initLocalNotifications();

  }

  void handleMessage(RemoteMessage? message){
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

  Future initPushNotifications() async{
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null)return;
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap-hdpi/ic_launcher.png'
            ),
          ),
          payload: jsonEncode(message.toMap())
            );
    });
  }



  Future initLocalNotifications()async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onSelectNotification: (payload){
        final message = RemoteMessage.fromMap(jsonDecode(payload!));
        handleMessage(message);
      }
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }
}