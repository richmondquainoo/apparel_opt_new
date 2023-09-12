// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.orderNumber,
    this.orderStatus,
    this.title,
    this.message,
    this.dateSent,
    this.email,
  });

  String? orderNumber;
  String? orderStatus;
  String? title;
  String? message;
  String? dateSent;
  String? email;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        orderNumber: json["orderNumber"],
        orderStatus: json["orderStatus"],
        title: json["title"],
        message: json["message"],
        dateSent: json["dateSent"],
        email: json["email"],
      );

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        orderNumber: json["orderNumber"],
        orderStatus: json["orderStatus"],
        title: json["title"],
        message: json["message"],
        dateSent: json["dateSent"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "orderNumber": orderNumber,
    "orderStatus": orderStatus,
    "title": title,
    "message": message,
    "dateSent": dateSent,
    "email": email,
  };

  Map<String, dynamic> toMap() => {
    "orderNumber": orderNumber,
    "orderStatus": orderStatus,
    "title": title,
    "message": message,
    "dateSent": dateSent,
    "email": email,
  };

  @override
  String toString() {
    return 'NotificationModel{orderNumber: $orderNumber, orderStatus: $orderStatus, title: $title, message: $message, dateSent: $dateSent, email: $email}';
  }
}
