// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Model/AppData.dart';
// import '../../Model/NotificationModel.dart';
// import '../../Model/RequestNotificationModel.dart';
// import 'notificationservice.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("Handling a background message ${message.messageId}");
//   print("FCM payload ${message.data}|| ${message}");
// }
//
// class PushNotificationSystem {
//   late final FirebaseMessaging _messaging;
//   LocalNotificationService notificationService;
//   bool? dismiss = false;
//   bool? newDismiss = false;
//
//   PushNotificationSystem(this.notificationService) {
//     print('FCM service and LOCAL NOTIFICATION created successfully');
//   }
//
//   void registerNotification(BuildContext context) async {
//     // 1. Initialize the Firebase app
//
//     await FirebaseMessaging.instance.subscribeToTopic("request");
//
//     // 2. Instantiate Firebase Messaging
//     _messaging = FirebaseMessaging.instance;
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // 3. On iOS, this helps to take the user permissions
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       // For handling the received notifications
//       FirebaseMessaging.onMessage.listen((
//         RemoteMessage message,
//       ) {
//         print('FCM Data in notification: ${message.data}');
//         print("THE NOTIF SUBJECT: ${message.notification?.title}");
//         // print('FCM message received: ${message.data["agentId"]}');
//         // var agentID = message.data["agentId"];
//         var requestID = message.data["requestId"];
//         RequestNotificationModel requestNotificationModel = RequestNotificationModel(
//           requestId: requestID,
//           // agentId: agentID,
//         );
//         print("The requestID is:${requestNotificationModel.requestId}");
//
//         // Provider.of<AppData>(context, listen: false).updateAgentID(agentID);
//         // Provider.of<AppData>(context, listen: false)
//         //     .updateRequestNotification(requestNotificationModel);
//
//         // print(
//         //     "THE AGENT ID FROM PROVIDER: ${Provider.of<AppData>(context, listen: false).newAgentID}");
//
//         // Parse the message received
//         NotificationModel notification = NotificationModel(
//           subject: message.notification?.title,
//           content: message.notification?.body,
//         );
//
//         Provider.of<AppData>(context, listen: false).currentRequestStatus(notification.subject!.toString());
//
//         // var notifTitle = message.notification?.title;
//
//         // Provider.of<AppData>(context,listen: false).updateNotification(notifTitle!);
//
//         // print("THE NOTIFICATION FROM PROVIDER: ${Provider.of<AppData>(context, listen: false).notificationTitle}");
//
//         //Handle New Request Notifications
//         if (notification.subject!.contains("Your agent is on the way.")) {
//           notificationService.showNotificationWithPayload(
//               id: 0,
//               title: notification.subject.toString(),
//               body: notification.content.toString(),
//               payload: notification.subject.toString());
//           // showDialog(
//           //     context: context,
//           //     builder: (context) => NotificationDialogBox(
//           //           content: '${notification.subject}',
//           //           subject: '${notification.content}',
//           //           service: message.data["service"],
//           //           address: message.data["address"],
//           //           agentName: message.data["agentName"],
//           //           agentId: message.data["agentId"],
//           //           companyName: message.data["companyName"],
//           //
//           //         ));
//           // showSimpleNotification(
//           //     Text(
//           //       "${notification.subject}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.w400,
//           //       ),
//           //     ),
//           //     subtitle: Text(
//           //       "${notification.content}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 12,
//           //         fontWeight: FontWeight.w300,
//           //       ),
//           //     ),
//           //     leading: const Icon(
//           //       Icons.notification_important,
//           //       color: Colors.white,
//           //     ),
//           //     // trailing: ElevatedButton(
//           //     //     onPressed: () {
//           //     //       dismiss = true;
//           //     //       newDismiss = dismiss;
//           //     //       print("THE DISMISS BUTTON:$newDismiss ");
//           //     //       Navigator.pop(context);
//           //     //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallOutChargeScreen()));
//           //     //
//           //     //     },
//           //     //     child: const Text("Proceed")),
//           //     slideDismissDirection: DismissDirection.up,
//           //     autoDismiss: newDismiss!,
//           //     background: Color(0xFF475254));
//
//           // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallOutChargeScreen()));
//         } else if (notification.subject!.contains("Your agent has arrived.")) {
//           notificationService.showNotificationWithPayload(
//             id: 0,
//             title: notification.subject.toString(),
//             body: notification.content.toString(),
//             payload: notification.subject.toString(),
//           );
//           // showSimpleNotification(
//           //     Text(
//           //       "${notification.subject}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.w400,
//           //       ),
//           //     ),
//           //     subtitle: Text(
//           //       "${notification.content}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 12,
//           //         fontWeight: FontWeight.w300,
//           //       ),
//           //     ),
//           //     leading: const Icon(
//           //       Icons.notification_important,
//           //       color: Colors.white,
//           //     ),
//           //     // trailing: ElevatedButton(
//           //     //     onPressed: () {
//           //     //       dismiss = true;
//           //     //       newDismiss = dismiss;
//           //     //       print("THE DISMISS BUTTON:$newDismiss ");
//           //     //       Navigator.pop(context);
//           //     //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallOutChargeScreen()));
//           //     //
//           //     //     },
//           //     //     child: const Text("Proceed")),
//           //     slideDismissDirection: DismissDirection.up,
//           //     autoDismiss: newDismiss!,
//           //     background: Color(0xFF475254));
//         } else if (notification.subject!.contains("Job started")) {
//           notificationService.showNotificationWithPayload(
//               id: 0,
//               title: notification.subject.toString(),
//               body: notification.content.toString(),
//               payload: notification.subject.toString());
//           // showSimpleNotification(
//           //     Text(
//           //       "${notification.subject}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.w400,
//           //       ),
//           //     ),
//           //     subtitle: Text(
//           //       "${notification.content}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 12,
//           //         fontWeight: FontWeight.w300,
//           //       ),
//           //     ),
//           //     leading: const Icon(
//           //       Icons.notification_important,
//           //       color: Colors.white,
//           //     ),
//           //     // trailing: ElevatedButton(
//           //     //     onPressed: () {
//           //     //       dismiss = true;
//           //     //       newDismiss = dismiss;
//           //     //       print("THE DISMISS BUTTON:$newDismiss ");
//           //     //       Navigator.pop(context);
//           //     //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallOutChargeScreen()));
//           //     //
//           //     //     },
//           //     //     child: const Text("Proceed")),
//           //     slideDismissDirection: DismissDirection.up,
//           //     autoDismiss: newDismiss!,
//           //     background: Color(0xFF475254));
//         } else if (notification.subject!.contains("Job completed.")) {
//           notificationService.showNotificationWithPayload(
//               id: 0,
//               title: "${notification.subject}",
//               body: "${notification.content}",
//               payload: notification.subject.toString());
//           // showSimpleNotification(
//           //     Text(
//           //       "${notification.subject}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 16,
//           //         fontWeight: FontWeight.w400,
//           //       ),
//           //     ),
//           //     subtitle: Text(
//           //       "${notification.content}",
//           //       style: GoogleFonts.raleway(
//           //         fontSize: 12,
//           //         fontWeight: FontWeight.w300,
//           //       ),
//           //     ),
//           //     leading: const Icon(
//           //       Icons.notification_important,
//           //       color: Colors.white,
//           //     ),
//           //     // trailing: ElevatedButton(
//           //     //     onPressed: () {
//           //     //       dismiss = true;
//           //     //       newDismiss = dismiss;
//           //     //       print("THE DISMISS BUTTON:$newDismiss ");
//           //     //       Navigator.pop(context);
//           //     //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>CallOutChargeScreen()));
//           //     //
//           //     //     },
//           //     //     child: const Text("Proceed")),
//           //     slideDismissDirection: DismissDirection.up,
//           //     autoDismiss: newDismiss!,
//           //     background: Color(0xFF475254));
//         } else if (notification.subject!.contains("Payment Request.")) {
//           notificationService.showNotificationWithPayload(
//               id: 0, title: "${notification.subject}", body: "${notification.content}", payload: message.data['requestId']);
//         } else if (notification.subject!.contains("Job Completed.")) {
//           notificationService.showNotificationWithPayload(
//               id: 0, title: "${notification.subject}", body: "${notification.content}", payload: message.data['requestId']);
//         } else if (notification.subject!.contains("Request cancelled.")) {
//           notificationService.showNotificationWithPayload(
//               id: 0, title: "${notification.subject}", body: "${notification.content}", payload: message.data['requestId']);
//         }
//       });
//       // const NotificationDialogBox();
//     } else {
//       print('User declined or has not accepted permission');
//     }
// // For handling notification when the app is in background
//     // but not terminated
//     // FirebaseMessaging.onMessageOpenedApp.listen((
//     //   RemoteMessage message,
//     // ) {
//     //   debugPrint("RemoteMessage background message: $message");
//     // });
//   }
// }
