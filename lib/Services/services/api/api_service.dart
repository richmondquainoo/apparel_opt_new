import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/ApiConfig.dart';


class ApiService {
  final http.Client client;

  ApiService(this.client);

  Future<dynamic> convertCoordToPlace({required double lat, required double long}) async {
    final uri = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${ApiConfig.googleApiKey}");

    final response = await client.get(uri); //send get request to API URL

    print(response);

    if (response.statusCode != 200) {
      throw Exception(jsonDecode((response.body)));
    }
    final parsed = jsonDecode(response.body);
    // print('convertCoordToPlace => $parsed');
    if (parsed['status'] == 'OK' && parsed['results'].isNotEmpty) {
      dynamic firstResult = parsed["results"][0]; //select the first address
      return firstResult;
    }
  }
  //
  // Future<List<TrackingAgentModel>> trackingAgent(RequestModel requestModel, context) async {
  //   final uri = Uri.parse('${ApiConfig.apiUrl}/company-staff/agent-tracking-info/requestId/${requestModel.requestId}');
  //   print("Registration Api: $uri");
  //
  //   final response = await http.get(uri,
  //       headers: {'Authorization': ApiConfig.token, 'content-type': 'Application/json', 'Accept': 'Application/json'});
  //   if (response.statusCode != 200) {
  //     throw Exception(jsonDecode((response.body)));
  //   }
  //   // print("getPlace List: ${response.body}");
  //   var result = jsonDecode(response.body);
  //   // print("Data set: ${jsonEncode(result['data'])}");
  //   print("getRequestList data: ${response.body}");
  //
  //   final List<TrackingAgentModel> trackingList =
  //       List<TrackingAgentModel>.from(result['data'].map((e) => TrackingAgentModel.fromJson(e)));
  //
  //   print('orderList size on download: ${trackingList.length}');
  //
  //   print("This is the list $trackingList");
  //
  //   return trackingList;
  // }
  //
  // Future<TrackingAgentModel> agentLocation(RequestModel requestModel, context) async {
  //   final uri = Uri.parse('${ApiConfig.apiUrl}/company-staff/agent-tracking-info/requestId/${requestModel.requestId}');
  //   print("Registration Api: $uri");
  //
  //   final response = await http.get(uri,
  //       headers: {'Authorization': ApiConfig.token, 'content-type': 'Application/json', 'Accept': 'Application/json'});
  //
  //   if (response.statusCode != 200) {
  //     throw Exception(jsonDecode((response.body)));
  //   }
  //   print("Response for tracking ${response.body}");
  //   var result = jsonDecode(response.body);
  //   return TrackingAgentModel.fromJson(result['data']);
  // }
}
