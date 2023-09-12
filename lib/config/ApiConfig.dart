import 'package:flutter/cupertino.dart';

class ApiConfig extends ChangeNotifier{
  static const String apiUrl = 'https://dev.api.myfitta.com';
  // static const env = "staging";
  //staging environment
  // static const String apiUrl = "";
// const String apiUrl = "https://6da7-154-160-2-26.ngrok.io"; //dev environment
  // static const String otpLogin = "";
  // static const String otpVerifyAPI = "";

  static const String googleApiKey = "AIzaSyCKM_cLs6dNLYnGn2aS5B599LGepkQlapM";
  static const String token =
      "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJNeUZpdGEiLCJpc3MiOiJTeXNfQWRtaW4iLCJleHAiOjE4MjQzMDczMzl9.PkQ8rDloMwDu3laJoq6k7cE7K14pyhFVMupdBRGGp5o";

// static forEnvironment(String env) {} //dev token
// static const String token =
//     // "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJQT1RCRUxMWSIsImlzcyI6IlN5c19BZG1pbiIsImV4cCI6MTY2NDM2ODE0NX0.IwaAZPtmov7X1fvJAYzdFL0o2Xrg02gDXNZpMkWzHHY"; //dev token
//     "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJQT1RCRUxMWSIsImlzcyI6IlN5c19BZG1pbiIsImV4cCI6MTY2NDkwNDYxNn0.zNOAmUOxb956hGilcBwYFbcw4tCbBV_FnMLB4A75gcE"; //staging token

// static const String fcm_token = "$apiUrl/fcm-token/create-token";
}
