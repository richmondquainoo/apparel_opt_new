import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Components/ProgressDialog.dart';
import '../../Components/TextButtonComponent.dart';
import '../../Constants/myColors.dart';
import '../../Model/OTPModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import 'LoginScreen.dart';

class PasswordResetScreen extends StatefulWidget {
  final OTPModel? otpModel;
  const PasswordResetScreen({Key? key, this.otpModel}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() =>
      _PasswordResetScreenState(otpModel: otpModel);
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final OTPModel? otpModel;

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  String? password;
  String? confirmPassword;

  _PasswordResetScreenState({this.otpModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 10, bottom: 10),
                                child: const Icon(Icons.keyboard_arrow_left,
                                    color: Colors.black),
                              ),
                              const Text('Back',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Reset Password',
                    style: GoogleFonts.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/resetPassword.png'),
                      ),
                      borderRadius: BorderRadius.circular(150),
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Your identity has been verified',
                      style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Set your new password',
                      style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 48,
                  // margin: EdgeInsets.all(5),
                  padding: EdgeInsets.only(left: 45, right: 45),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(7.0)), // set rounded corner radius
                  ),
                  child: Center(
                    child: TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.black54),
                      controller: passwordController,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: primaryColor, width: 0.7),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black54,
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  height: 48,
                  // margin: EdgeInsets.all(5),
                  padding: EdgeInsets.only(left: 45, right: 45),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(7.0)), // set rounded corner radius
                  ),
                  child: Center(
                    child: TextField(
                      obscureText: true,
                      style: const TextStyle(color: Colors.black54),
                      controller: confirmPasswordController,
                      onChanged: (value) {
                        confirmPassword = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.black87, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: primaryColor, width: 0.7),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black54,
                        ),
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(
                            color: Colors.black54, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextButtonComponent(
                      labelColor: Colors.black,
                      label: 'Done',
                      onTap: () {
                        // 1. Validate email field
                        bool canSendEmail = isValidEntries(context);
                        if (canSendEmail) {
                          OTPModel model = OTPModel(
                              email: widget.otpModel!.email,
                              password: confirmPasswordController.text);
                          resetPassword(context: context, dataModel: model);
                        }
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEntries(BuildContext context) {
    if (passwordController.text.length == 0) {
      new UtilityService().showMessage(
        context: context,
        message: 'Please enter password',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (passwordController.text.length < 5) {
      new UtilityService().showMessage(
        context: context,
        message: 'Password must be 4 or more characters long',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      new UtilityService().showMessage(
        context: context,
        message: 'Passwords mismatch',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  void resetPassword({OTPModel? dataModel, BuildContext? context}) async {
    try {
      showDialog(
        context: context!,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Resetting Password...');
        },
      );
      // dataModel.pin = int.parse(globalPin);
      var jsonBody = jsonEncode(dataModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: CONFIRM_NEW_PASSWORD,
          body: jsonBody,
          auth: 'Bearer $ACCESS_TOKEN');

      // print("Verify By email: ${OTP_VERIFY_BY_EMAIL}");
      print('reset-password body: ${response!.body}');

      if (response == null) {
        //error handling
        new UtilityService().showMessage(
          context: context,
          message: 'An error has occurred. Please try again',
          icon: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      } else {
        var data = jsonDecode(response.body);

        if (data['status'] == 200 &&
            data['message'] == 'Customer password reset successful') {
          // verification is successful
          print('Body: ${response.body}');
          OTPModel otpModel = new OTPModel(
              email: widget.otpModel!.email,
              password: confirmPasswordController.text.toString());
          Navigator.of(context, rootNavigator: true).pop();

          new UtilityService().showMessage(
            message: data['message'],
            icon: Icon(
              Icons.error_outline,
              color: Colors.teal,
            ),
            context: context,
          );
          goToLogin(context, otpModel);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          new UtilityService().showMessage(
            message: data['message'],
            icon: Icon(
              Icons.check_circle,
              color: Colors.red,
            ),
            context: context,
          );
        }
      }
    } catch (e) {
      print("Verify By email: ${OTP_VERIFY_BY_EMAIL}");
      print('postUserData error: $e');
      new UtilityService().showMessage(
        context: context,
        message: 'An error has occurred. Please try again',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }

  void goToLogin(BuildContext context, OTPModel otpModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
