// To parse this JSON data, do
//
//     final newOrderModel = newOrderModelFromJson(jsonString);

import 'dart:convert';

import 'package:apparel_options/Model/FullCartModel.dart';

import 'ProductModel.dart';

NewOrderModel newOrderModelFromJson(String str) => NewOrderModel.fromJson(json.decode(str));

String newOrderModelToJson(NewOrderModel data) => json.encode(data.toJson());

class NewOrderModel {

  String orderNo;
  String orderBy;
  String orderPhone;
  String orderAddress;
  String orderEmail;
  String orderDetail;
  String orderAdditionalInfo;
  double orderTotalAmount;
  String orderBranch;
  double paymentAmount;
  String paymentMode;
  String channel;
  String deliveryOption;
  double orderLat;
  double orderLon;
  double orderItemCost;
  String orderTakenBy;
  String organizationName;
  String organizationCode;
  String dispatcher;
  String dispatcherPhone;
  String distance;
  String eta;
  String deliveryDate;
  int orderQuantity;
  String orderStatus;
  String acknowledgementDate;
  String paymentStatus;
  String deliveryCharge;
  String serviceCharge;
  List<ProductModel> products;

  factory NewOrderModel.fromJson(Map<String, dynamic> json) => NewOrderModel(
    orderNo: json["orderNo"],
    orderBy: json["orderBy"],
    orderPhone: json["orderPhone"],
    orderAddress: json["orderAddress"],
    orderEmail: json["orderEmail"],
    orderDetail: json["orderDetail"],
    orderAdditionalInfo: json["orderAdditionalInfo"],
    orderTotalAmount: json["orderTotalAmount"],
    orderBranch: json["orderBranch"],
    paymentAmount: json["paymentAmount"],
    paymentMode: json["paymentMode"],
    channel: json["channel"],
    deliveryOption: json["deliveryOption"],
    orderLat: json["orderLat"].toDouble(),
    orderLon: json["orderLon"].toDouble(),
    orderItemCost: json["orderItemCost"],
    orderTakenBy: json["orderTakenBy"],
    organizationName: json["organizationName"],
    organizationCode: json["organizationCode"],
    orderQuantity: json["orderQuantity"],
    products:json['products'],
    dispatcher:json['dispatcher'],
    distance:json['distance'],
    eta:json['eta'],
    deliveryDate:json['deliveryDate'],
    dispatcherPhone:json['dispatcherPhone'],
    paymentStatus:json['paymentStatus'],


  );

  Map<String, dynamic> toJson() => {
    "orderNo": orderNo,
    "orderBy": orderBy,
    "orderPhone": orderPhone,
    "orderAddress": orderAddress,
    "orderEmail": orderEmail,
    "orderDetail": orderDetail,
    "orderAdditionalInfo": orderAdditionalInfo,
    "orderTotalAmount": orderTotalAmount,
    "orderBranch": orderBranch,
    "paymentAmount": paymentAmount,
    "paymentMode": paymentMode,
    "channel": channel,
    "deliveryOption": deliveryOption,
    "orderLat": orderLat,
    "orderLon": orderLon,
    "orderItemCost": orderItemCost,
    "orderTakenBy": orderTakenBy,
    "organizationName": organizationName,
    "organizationCode": organizationCode,
    "orderQuantity": orderQuantity,
    "products": products,
    'dispatcher': dispatcher,
    'dispatcherPhone': dispatcherPhone,
    'distance': distance,
    'eta': eta,
    'paymentStatus':paymentStatus,
    'deliveryDate': deliveryDate,
  };

  Map<String, dynamic> toMap() => {
    "orderNo": orderNo,
    "orderBy": orderBy,
    "orderPhone": orderPhone,
    "orderAddress": orderAddress,
    "orderEmail": orderEmail,
    "orderDetail": orderDetail,
    "orderAdditionalInfo": orderAdditionalInfo,
    "orderTotalAmount": orderTotalAmount,
    "orderBranch": orderBranch,
    "paymentAmount": paymentAmount,
    "paymentMode": paymentMode,
    "channel": channel,
    "deliveryOption": deliveryOption,
    "orderLat": orderLat,
    "orderLon": orderLon,
    "orderItemCost": orderItemCost,
    "orderTakenBy": orderTakenBy,
    "organizationName": organizationName,
    "organizationCode": organizationCode,
    "orderQuantity": orderQuantity,
    "products":products,
    'dispatcher': dispatcher,
    'dispatcherPhone': dispatcherPhone,
    'distance': distance,
    'eta': eta,
    'paymentStatus':paymentStatus,
    'deliveryDate': deliveryDate,
    'serviceCharge' : serviceCharge,
    'deliveryCharge' : deliveryCharge
  };


  @override
  String toString() {
    return 'NewOrderModel{orderNo: $orderNo, orderBy: $orderBy, orderPhone: $orderPhone, orderAddress: $orderAddress, orderEmail: $orderEmail, orderDetail: $orderDetail, orderAdditionalInfo: $orderAdditionalInfo, orderTotalAmount: $orderTotalAmount, orderBranch: $orderBranch, paymentAmount: $paymentAmount, paymentMode: $paymentMode, channel: $channel, deliveryOption: $deliveryOption, orderLat: $orderLat, orderLon: $orderLon, orderItemCost: $orderItemCost, orderTakenBy: $orderTakenBy, organizationName: $organizationName, organizationCode: $organizationCode, dispatcher: $dispatcher, dispatcherPhone: $dispatcherPhone, distance: $distance, eta: $eta, deliveryDate: $deliveryDate, orderQuantity: $orderQuantity, orderStatus: $orderStatus, acknowledgementDate: $acknowledgementDate, paymentStatus: $paymentStatus, products: $products}';
  }

  NewOrderModel({
      this.orderNo,
      this.orderBy,
      this.orderPhone,
      this.orderAddress,
      this.orderEmail,
      this.orderDetail,
      this.orderAdditionalInfo,
      this.orderTotalAmount,
      this.orderBranch,
      this.paymentAmount,
      this.paymentMode,
      this.channel,
      this.deliveryOption,
      this.orderLat,
      this.orderLon,
      this.orderItemCost,
      this.orderTakenBy,
      this.organizationName,
      this.organizationCode,
      this.dispatcher,
      this.dispatcherPhone,
      this.distance,
      this.eta,
      this.deliveryDate,
      this.orderQuantity,
      this.orderStatus,
      this.acknowledgementDate,
      this.paymentStatus,
      this.deliveryCharge,
      this.serviceCharge,
      this.products});
}

