import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig extends ChangeNotifier {
  AppConfig({
    this.env,
    this.baseUrl,
    this.sendOtpMessageUrl,
    this.sendOtpForLoginUrl,
    this.createUserUrl,
    this.createUserWithImageUrl,
    this.fetchUserByPhoneUrl,
    this.editUserDetailsUrl,
    this.editCustomerDetailsUrl,
    this.editCustomerDetailsWithImageUrl,
    this.editUserCarUrl,
    this.editUserCarWithImageUrl,
    this.fetchAllCarModelUrl,
    this.fetchCarMakeByModelUrl,
    this.addCarWithoutImageUrl,
    this.addCarWithImageUrl,
    this.fetchAllUserCarsUrl,
    this.fetchAllServicesUrl,
    this.fetchAllRequestsUrl,
    this.sendRequestUrl,
    this.sendNotificationWithTokenUrl,
    this.fetchCallOutChargeUrl,
    this.initiatePaymentUrl,
    this.checkPaymentStatusUrl,
    this.confirmArrivalUrl,
    this.cancelRequestUrl,
    this.fetchAgentByIdUrl,
    this.agentTrackingUrl,
    this.requestByRequestIdUrl,
    this.fetchAgentLocationByRequestIdUrl,
    this.addRatingUrl,
    this.payProfChargeUrl,
    this.retryRequestUrl,
    this.mapApiKey,
    this.fetchPopularProductsUrl,
    this.fetchAllProductsByCategoryUrl,
    this.fetchProductByProductOptionsUrl,
    this.token,
    this.fetchSearchedProductUrl,
    this.sendTokenToServerUrl,
    this.deleteTokenToServerUrl,
    this.accessTokenForRequest,
    this.verifyLicenseUrl,
    this.deleteCustomer
  });

  String? env;
  String? baseUrl;
  String? sendOtpMessageUrl;
  String? sendOtpForLoginUrl;
  String? createUserUrl;
  String? createUserWithImageUrl;
  String? fetchUserByPhoneUrl;
  String? editUserDetailsUrl;
  String? editCustomerDetailsUrl;
  String? editCustomerDetailsWithImageUrl;
  String? editUserCarUrl;
  String? editUserCarWithImageUrl;
  String? fetchAllCarModelUrl;
  String? fetchCarMakeByModelUrl;
  String? addCarWithoutImageUrl;
  String? addCarWithImageUrl;
  String? fetchAllUserCarsUrl;
  String? fetchAllServicesUrl;
  String? fetchAllRequestsUrl;
  String? sendRequestUrl;
  String? sendNotificationWithTokenUrl;
  String? fetchCallOutChargeUrl;
  String? initiatePaymentUrl;
  String? checkPaymentStatusUrl;
  String? confirmArrivalUrl;
  String? cancelRequestUrl;
  String? fetchAgentByIdUrl;
  String? agentTrackingUrl;
  String? requestByRequestIdUrl;
  String? fetchAgentLocationByRequestIdUrl;
  String? addRatingUrl;
  String? payProfChargeUrl;
  String? retryRequestUrl;
  String? mapApiKey;
  String? fetchPopularProductsUrl;
  String? fetchAllProductsByCategoryUrl;
  String? fetchProductByProductOptionsUrl;
  String? token;
  String? sendTokenToServerUrl;
  String? deleteTokenToServerUrl;
  String? fetchSearchedProductUrl;
  String? accessTokenForRequest;
  String? verifyLicenseUrl;
  String? deleteCustomer;

  static Future<AppConfig> forEnvironment(String env) async {
    // set default to prod if nothing was passed
    env = env.isEmpty ? 'prod' : env;

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/configs/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    return AppConfig(
      env: json["env"],
      baseUrl: json["baseUrl"],
      sendOtpMessageUrl: json["sendOtpMessageUrl"],
      sendOtpForLoginUrl: json["sendOtpForLoginUrl"],
      createUserUrl: json["createUserUrl"],
      createUserWithImageUrl: json["createUserWithImageUrl"],
      fetchUserByPhoneUrl: json["fetchUserByPhoneUrl"],
      editUserDetailsUrl: json["editUserDetailsUrl"],
      editCustomerDetailsUrl: json["editCustomerDetailsUrl"],
      editCustomerDetailsWithImageUrl: json["editCustomerDetailsWithImageUrl"],
      editUserCarUrl: json["editUserCarUrl"],
      editUserCarWithImageUrl: json["editUserCarWithImageUrl"],
      fetchAllCarModelUrl: json["fetchAllCarModelUrl"],
      fetchCarMakeByModelUrl: json["fetchCarMakeByModelUrl"],
      addCarWithoutImageUrl: json["addCarWithoutImageUrl"],
      addCarWithImageUrl: json["addCarWithImageUrl"],
      fetchAllUserCarsUrl: json["fetchAllUserCarsUrl"],
      fetchAllServicesUrl: json["fetchAllServicesUrl"],
      fetchAllRequestsUrl: json["fetchAllRequestsUrl"],
      sendRequestUrl: json["sendRequestUrl"],
      sendNotificationWithTokenUrl: json["sendNotificationWithTokenUrl"],
      fetchCallOutChargeUrl: json["fetchCallOutChargeUrl"],
      initiatePaymentUrl: json["initiatePaymentUrl"],
      checkPaymentStatusUrl: json["checkPaymentStatusUrl"],
      confirmArrivalUrl: json["confirmArrivalUrl"],
      cancelRequestUrl: json["cancelRequestUrl"],
      fetchAgentByIdUrl: json["fetchAgentByIdUrl"],
      agentTrackingUrl: json["agentTrackingUrl"],
      requestByRequestIdUrl: json["requestByRequestIdUrl"],
      fetchAgentLocationByRequestIdUrl:
          json["fetchAgentLocationByRequestIdUrl"],
      addRatingUrl: json["addRatingUrl"],
      payProfChargeUrl: json["payProfChargeUrl"],
      retryRequestUrl: json["retryRequestUrl"],
      mapApiKey: json["mapApiKey"],
      fetchAllProductsByCategoryUrl: json["fetchAllProductsByCategoryUrl"],
      fetchProductByProductOptionsUrl: json["fetchProductByProductOptionsUrl"],
      token: json['token'],
      fetchPopularProductsUrl: json['fetchPopularProductsUrl'],
      fetchSearchedProductUrl: json['fetchSearchedProductUrl'],
      sendTokenToServerUrl: json['sendTokenToServerUrl'],
      deleteTokenToServerUrl: json['deleteTokenToServerUrl'],
      accessTokenForRequest: json['accessTokenForRequest'],
      verifyLicenseUrl: json['verifyLicenseUrl'],
      deleteCustomer: json['deleteCustomer'],
    );
  }
}
