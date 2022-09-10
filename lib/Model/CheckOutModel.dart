// To parse this JSON data, do
//
//     final checkoutModel = checkoutModelFromJson(jsonString);

// import 'dart:convert';

class CheckoutModel {
  CheckoutModel({
    this.checkoutURL,
    this.checkoutID,
    this.clientReference,
    this.message,
    this.checkoutDirectURL,
  });

  String checkoutURL;
  String checkoutID;
  String clientReference;
  String message;
  String checkoutDirectURL;

  // factory CheckoutModel.fromJson(Map<String, dynamic> json) => CheckoutModel(
  //       checkoutUrl: json["checkoutUrl"].toString(),
  //       checkoutId: json["checkoutId"].toString(),
  //       clientReference: json["clientReference"].toString(),
  //       message: json["message"].toString(),
  //       checkoutDirectUrl: json["checkoutDirectUrl"].toString(),
  //     );

  Map<String, dynamic> toMap() => {
        "checkoutUrl": checkoutURL,
        "checkoutId": checkoutID,
        "clientReference": clientReference,
        "message": message,
        "checkoutDirectUrl": checkoutDirectURL,
      };

  Map<String, dynamic> toJson() => {
        "checkoutUrl": checkoutURL,
        "checkoutId": checkoutID,
        "clientReference": clientReference,
        "message": message,
        "checkoutDirectUrl": checkoutDirectURL,
      };

  @override
  String toString() {
    return 'CheckoutModel{checkoutUrl: $checkoutURL, checkoutId: $checkoutID, clientReference: $clientReference, message: $message, checkoutDirectUrl: $checkoutDirectURL}';
  }
}
