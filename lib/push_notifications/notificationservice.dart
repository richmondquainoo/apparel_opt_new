// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../../Model/AppData.dart';
// import '../../Model/RequestModel.dart';
// import '../../main.dart';
// import '../SelectCar/PreTrackingScreen.dart';
// import '../SelectCar/ProfessionalPaymentScreen.dart';
//
// class LocalNotificationService {
//   RequestModel? jobDetailsModel;
//   LatLng? currentLocation;
//
//   LocalNotificationService();
//   final _localNotificationService = FlutterLocalNotificationsPlugin();
//   final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();
//   Future<void> intialize() async {
//     // tz.initializeTimeZones();
//     const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('mipmap/ic_launcher');
//     DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     final InitializationSettings settings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );
//     await _localNotificationService.initialize(
//       settings,
//       onDidReceiveNotificationResponse: onSelectNotification,
//     );
//   }
//
//   Future<NotificationDetails> _notificationDetails() async {
//     const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'channel_name',
//         channelDescription: 'description', importance: Importance.max, priority: Priority.max, playSound: true);
//     const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();
//     return const NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );
//   }
//
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     final details = await _notificationDetails();
//     await _localNotificationService.show(id, title, body, details);
//   }
//
//   // Future<void> showScheduledNotification(
//   //     {required int id,
//   //       required String title,
//   //       required String body,
//   //       required int seconds}) async {
//   //   final details = await _notificationDetails();
//   //   await _localNotificationService.zonedSchedule(
//   //     id,
//   //     title,
//   //     body,
//   //     tz.TZDateTime.from(
//   //       DateTime.now().add(Duration(seconds: seconds)),
//   //       tz.local,
//   //     ),
//   //     details,
//   //     androidAllowWhileIdle: true,
//   //     uiLocalNotificationDateInterpretation:
//   //     UILocalNotificationDateInterpretation.absoluteTime,
//   //   );
//   // }
//   Future<void> showNotificationWithPayload(
//       {required int id, required String title, required String body, required String payload}) async {
//     final details = await _notificationDetails();
//     await _localNotificationService.show(id, title, body, details, payload: payload);
//   }
//
//   void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
//     print('id $id');
//   }
// //  void onSelectNotification(String? payload) {
// //     //  print('payload $payload');
// //     // if (payload != null && payload.isNotEmpty) {
// //     //   onNotificationClick.add(payload);
// //     // }
//
// //     print('payload $payload');
// //     onNotificationClick.add(payload);
// //     var context = navigatorKey.currentContext;
// //     // var updatedRequestData = context?.read<AppInfo>().updateRequestWithCalloutCharge(int.parse(payload!));
// //     // Navigator.push(
// //     //     context!,
// //     //     MaterialPageRoute(
// //     //         builder: (context) => StatusScreen(
// //     //               requestModel: newModel,
// //     //             currentLocation: trackingCord,
// //     //             )));dsdsdsd
//
// // //Start Trip-->
// // //Tracking Screen --->
// // //Start job-->Request Details Screen
// // //Payment To move to payment Screen
// //     return;
// //     // navigatorKey.currentState?.pushNamed('job');
// //     // return;
// //   }
//
//   Future<dynamic> onSelectNotification(payload) async {
//     var context = navigatorKey.currentContext;
//     jobDetailsModel = Provider.of<AppData>(context!, listen: false).requestModel!;
// // navigate to booking screen if the payload equal BOOKING
//     if (payload.toString().contains("Your agent is on the way.")) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => PreTrackingScreen(
//                     requestModel: jobDetailsModel,
//                   )));
//     }   else if (payload.toString().contains("Your agent has arrived.")) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => PreTrackingScreen(
//                 requestModel: jobDetailsModel,
//               )));
//     }
//     else if (payload.toString().contains("Payment Request.")) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ProfessionalPaymentScreen(
//                     requestId: jobDetailsModel!.requestId.toString(),
//                   )));
//     } else if (payload.toString().contains("Job started.")) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => PreTrackingScreen(
//                     requestModel: jobDetailsModel,
//                   )));
//     }
//     if (payload.toString().contains("Job completed.")) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => PreTrackingScreen(
//                 requestModel: jobDetailsModel,
//               )));
//     }
//   }
// }
