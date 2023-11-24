

import 'dart:convert';

import 'package:apparel_options/Screens/LandingPage/NotificationScreen.dart';
import 'package:apparel_options/Services/notification/notificationservice.dart';
import 'package:apparel_options/main.dart';
import 'package:apparel_options/push_notifications/push_notification_system.dart';
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
    print("BACK_GROUND");
    LocalNotificationService().showNotification(id: 1, title: "${message.notification!.title}", body: "${message.notification!.body}");


  }

  Future<void> initNotifications()async{
   await _firebaseMessaging.requestPermission();
   final fcmToken = await _firebaseMessaging.getToken();
   print("Token: ${fcmToken}");
   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
   initPushNotifications();
   initLocalNotifications();
   PushNotificationSystem;

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
              icon: '@drawable/ic_launcher'
            ),
          ),
          payload: jsonEncode(message.toMap())
            );
      LocalNotificationService().showNotification(id: 1, title: "${notification.title}", body: "${notification.body}");
    });
  }



  Future initLocalNotifications()async {
    print("LOCAL NOTIFICATION");
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: iOS);
    await LocalNotificationService().initialize();
    print("LOCAL NOTIFICATION NEW");

    // await _localNotifications.initialize(
    //   settings,
    //   onSelectNotification: (payload){
    //     print("LOCAL NOTIFICATION NEW");
    //     final message = RemoteMessage.fromMap(jsonDecode(payload!));
    //     handleMessage(message);
    //   }
    // );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }


}