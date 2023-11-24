// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

String requestNotificationModelToJson(RequestNotificationModel data) => json.encode(data.toJson());

class RequestNotificationModel {
  RequestNotificationModel({this.requestId, this.agentId});

  String? requestId;
  String? agentId;

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "agentId": agentId,
      };

  Map<String, dynamic> toMap() => {
        "requestId": requestId,
        "agentId": agentId,
      };

  @override
  String toString() {
    return 'RequestNotificationModel{requestId: $requestId, agentId: $agentId}';
  }
}
