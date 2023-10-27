// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

PaymentModel welcomeFromJson(String str) => PaymentModel.fromJson(json.decode(str));

String welcomeToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  PaymentModel({
    this.id,
    this.organizationCode,
    this.organizationName,
    this.branchCode,
    this.branchName,
    this.name,
    this.phone,
    this.email,
    this.billNo,
    this.billAmount,
    this.debitAmount,
    this.billType,
    this.description,
    this.callbackUrl,
    this.returnUrl,
    this.cancellationUrl,
    this.status,
    this.receiptSent,
    this.dateCreated,
    this.paymentDate,
    this.paymentAmount,
    this.sendCheckoutUrl,
  });

  int? id;
  String? organizationCode;
  String? organizationName;
  String? branchCode;
  String? branchName;
  String? name;
  String? phone;
  String? email;
  String? billNo;
  double? billAmount;
  double? debitAmount;
  String? billType;
  String? description;
  String? callbackUrl;
  String? returnUrl;
  String? cancellationUrl;
  String? status;
  String? receiptSent;
  String? dateCreated;
  String? paymentDate;
  int? paymentAmount;
  int? sendCheckoutUrl;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json["id"],
    organizationCode: json["organizationCode"],
    organizationName: json["organizationName"],
    branchCode: json["branchCode"],
    branchName: json["branchName"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    billNo: json["billNo"],
    billAmount: json["billAmount"],
    debitAmount: json["debitAmount"],
    billType: json["billType"],
    description: json["description"],
    callbackUrl: json["callbackUrl"],
    returnUrl: json["returnUrl"],
    cancellationUrl: json["cancellationUrl"],
    status: json["status"],
    receiptSent: json["receiptSent"],
    dateCreated: json["dateCreated"],
    paymentDate: json["paymentDate"],
    paymentAmount: json["paymentAmount"],
    sendCheckoutUrl: json["sendCheckoutUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "organizationCode": organizationCode,
    "organizationName": organizationName,
    "branchCode": branchCode,
    "branchName": branchName,
    "name": name,
    "phone": phone,
    "email": email,
    "billNo": billNo,
    "billAmount": billAmount,
    "debitAmount": debitAmount,
    "billType": billType,
    "description": description,
    "callbackUrl": callbackUrl,
    "returnUrl": returnUrl,
    "cancellationUrl": cancellationUrl,
    "status": status,
    "receiptSent": receiptSent,
    "dateCreated": dateCreated,
    "paymentDate": paymentDate,
    "paymentAmount": paymentAmount,
    "sendCheckoutUrl": sendCheckoutUrl,
  };

  Map<String, dynamic> toMap() => {
    "id": id,
    "organizationCode": organizationCode,
    "organizationName": organizationName,
    "branchCode": branchCode,
    "branchName": branchName,
    "name": name,
    "phone": phone,
    "email": email,
    "billNo": billNo,
    "billAmount": billAmount,
    "debitAmount": debitAmount,
    "billType": billType,
    "description": description,
    "callbackUrl": callbackUrl,
    "returnUrl": returnUrl,
    "cancellationUrl": cancellationUrl,
    "status": status,
    "receiptSent": receiptSent,
    "dateCreated": dateCreated,
    "paymentDate": paymentDate,
    "paymentAmount": paymentAmount,
    "sendCheckoutUrl": sendCheckoutUrl,
  };

  @override
  String toString() {
    return 'PaymentModel{id: $id, organizationCode: $organizationCode, organizationName: $organizationName, branchCode: $branchCode, branchName: $branchName, name: $name, phone: $phone, email: $email, billNo: $billNo, billAmount: $billAmount, debitAmount: $debitAmount, billType: $billType, description: $description, callbackUrl: $callbackUrl, returnUrl: $returnUrl, cancellationUrl: $cancellationUrl, status: $status, receiptSent: $receiptSent, dateCreated: $dateCreated, paymentDate: $paymentDate, paymentAmount: $paymentAmount, sendCheckoutUrl: $sendCheckoutUrl}';
  }
}
