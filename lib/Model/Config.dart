// To parse this JSON data, do
//
//     final config = configFromJson(jsonString);

import 'dart:convert';

List<Config> configFromJson(String str) =>
    List<Config>.from(json.decode(str).map((x) => Config.fromJson(x)));

String configToJson(List<Config> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Config {
  Config({
    this.id,
    this.organization,
    this.branch,
    this.assignmentMode,
    // this.orderTracker,
    this.latitude,
    this.longitude,
    this.serviceCharge,
  });

  int id;
  String organization;
  String branch;
  String assignmentMode;
  // bool orderTracker;
  double latitude;
  double longitude;
  double serviceCharge;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        id: json["id"],
        organization: json["organization"],
        branch: json["branch"],
        assignmentMode: json["assignmentMode"],
        // orderTracker: json["orderTracker"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        serviceCharge: json["serviceCharge"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization": organization,
        "branch": branch,
        "assignmentMode": assignmentMode,
        // "orderTracker": orderTracker,
        "latitude": latitude,
        "longitude": longitude,
        "serviceCharge": serviceCharge,
      };
  Map<String, dynamic> toMap() => {
        "id": id,
        "organization": organization,
        "branch": branch,
        "assignmentMode": assignmentMode,
        // "orderTracker": orderTracker,
        "latitude": latitude,
        "longitude": longitude,
        "serviceCharge": serviceCharge,
      };

  @override
  String toString() {
    return 'Config{id: $id, organization: $organization, branch: $branch, assignmentMode: $assignmentMode, latitude: $latitude, longitude: $longitude, serviceCharge: $serviceCharge}';
  }
}
