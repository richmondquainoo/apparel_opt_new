// To parse this JSON data, do
//
//     final deliveryCost = deliveryCostFromJson(jsonString);

import 'dart:convert';

List<DeliveryCost> deliveryCostFromJson(String str) => List<DeliveryCost>.from(
    json.decode(str).map((x) => DeliveryCost.fromJson(x)));

String deliveryCostToJson(List<DeliveryCost> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeliveryCost {
  DeliveryCost({
    this.id,
    this.organization,
    this.branch,
    this.minDistance,
    this.maxDistance,
    this.cost,
  });

  int? id;
  String? organization;
  String? branch;
  double? minDistance;
  double? maxDistance;
  double? cost;

  factory DeliveryCost.fromJson(Map<String, dynamic> json) => DeliveryCost(
        id: json["id"],
        organization: json["organization"],
        branch: json["branch"],
        minDistance: json["minDistance"],
        maxDistance: json["maxDistance"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "organization": organization,
        "branch": branch,
        "minDistance": minDistance,
        "maxDistance": maxDistance,
        "cost": cost,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "organization": organization,
        "branch": branch,
        "minDistance": minDistance,
        "maxDistance": maxDistance,
        "cost": cost,
      };

  @override
  String toString() {
    return 'DeliveryCost{id: $id, organization: $organization, branch: $branch, minDistance: $minDistance, maxDistance: $maxDistance, cost: $cost}';
  }
}
