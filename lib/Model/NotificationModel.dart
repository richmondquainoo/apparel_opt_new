// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({this.subject, this.content, this.image, this.requestId, this.userModel});

  String? subject;
  String? content;
  String? image;
  String? requestId;
  String? userModel;

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "content": content,
    "requestId": requestId,
    "image": image,
    "userModel": userModel,
  };

  Map<String, dynamic> toMap() => {
    "subject": subject,
    "content": content,
    "requestId": requestId,
    "image": image,
    "userModel": userModel,
  };

  @override
  String toString() {
    return 'NotificationModel{subject: $subject, content: $content, image: $image, requestId: $requestId, userModel: $userModel}';
  }
}
