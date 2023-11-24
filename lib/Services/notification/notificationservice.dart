import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../Model/AppData.dart';


class LocalNotificationService {

  LatLng? currentLocation;

  LocalNotificationService();
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {

    // tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _localNotifications.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<dynamic> onSelectNotification(payload) async {
    // implement logic
    print("onSelectNotification : " + payload);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description', importance: Importance.max, priority: Priority.max, playSound: true);
    const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotifications.show(id, title, body, details);
  }


  Future<void> showNotificationWithPayload(
      {required int id, required String title, required String body, required String payload}) async {
    final details = await _notificationDetails();
    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('id $id');
  }


}
