import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class NetworkUtility {
  Future<Response?> getData(String url) async {
    try {
      Response response = await http.get(Uri.parse(url));
      return response;
    } catch (e) {
      print('Network Service Error: ${e.toString()}');
      return null;
    }
  }

  Future<Response?> getDataWithAuth({String? url, String? auth}) async {
    Map<String, String> headers = {HttpHeaders.authorizationHeader: auth!};
    try {
      Response? response = await http.get(Uri.parse(url!), headers: headers);
      return response;
    } catch (e) {
      print('Network Service Error: ${e.toString()}');
      return null;
    }
  }

  Future<Response?> postData({String? url, String? body}) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      Response response = await http.post(Uri.parse(url!), headers: headers, body: body);
      return response;
    } catch (e) {
      print('Network Service Error: ${e.toString()}');
      return null;
    }
  }

  Future<Response?> postDataWithAuth(
      {String? url, String? body, String? auth}) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      HttpHeaders.authorizationHeader: auth!
    };
    try {
      Response response = await http.post(Uri.parse(url!), headers: headers, body: body);
      return response;
    } catch (e) {
      print('Network Service Error: ${e.toString()}');
      return null;
    }
  }
}
