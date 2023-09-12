// To parse this JSON data, do
//
//     final deliveryAddressModel = deliveryAddressModelFromJson(jsonString);

import 'dart:convert';

DeliveryAddressModel deliveryAddressModelFromJson(String str) => DeliveryAddressModel.fromJson(json.decode(str));

String deliveryAddressModelToJson(DeliveryAddressModel data) => json.encode(data.toJson());

class DeliveryAddressModel {
  String? email;
  String? address;
  double? latitude;
  double? longitude;
  String? country;
  String? region;
  String? postCode;
  String? dateCreated;
  String? lastEdited;

  DeliveryAddressModel({
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.region,
    required this.postCode,
    required this.dateCreated,
    required this.lastEdited,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) => DeliveryAddressModel(
    email: json["email"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    country: json["country"],
    region: json["region"],
    postCode: json["postCode"],
    dateCreated: json["dateCreated"],
    lastEdited: json["lastEdited"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "country": country,
    "region": region,
    "postCode": postCode,
    "dateCreated": dateCreated,
    "lastEdited": lastEdited,
  };
}
