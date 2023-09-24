import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Components/ProgressDialog.dart';
import '../../Components/TextButtonComponent.dart';
import '../../Constants/myColors.dart';
import '../../Model/OTPModel.dart';
import '../../Services/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import 'OtpVerify.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  var emailController = TextEditingController();

  String? email;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: FIRSTBLACK,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
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
                                    color: Colors.white),
                              ),
                              Text('Back',
                                  style: GoogleFonts.raleway(
                                      fontSize: 17,
                                      color: Colors.white,
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
                    'Forgot Password ?',
                    style: GoogleFonts.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/forgotPassword.jpg'),
                    ),
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Enter the email address',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'associated with your account.',
                      style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 27,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'We will send an OTP to the phone number linked to the email',
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                const SizedBox(
                  height: 27,
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
                      obscureText: false,
                      style: const TextStyle(color: Colors.white),
                      controller: emailController,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.7),
                        ),
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        labelText: "Email",
                        labelStyle: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextButtonComponent(
                      labelColor: Colors.amber,
                      label: 'Send',
                      textColor: Colors.black,
                      onTap: () {
                        //1. Validate email field
                        bool canSendEmail = isCorrectInput(context);
                        if (canSendEmail) {
                          OTPModel model = OTPModel(
                            email: emailController.text.trim(),
                          );
                          sendEmail(model);
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

  bool isCorrectInput(BuildContext context) {
    if (emailController.text.length == 0 ||
        !emailController.text.contains('@') ||
        !emailController.text.contains(".")) {
      new UtilityService().showMessage(
          context: context,
          message: 'Please enter email',
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
      return false;
    } else {
      return true;
    }
  }

  void sendEmail(OTPModel userProfileModel) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Sending...');
        },
      );

      var jsonBody = jsonEncode(userProfileModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: RESET_PASSWORD, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      print('email response: ${response!.body}');

      Navigator.of(context, rootNavigator: true).pop();
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

        int status = data['status'];
        String message = data['message'];
        // Handle network error
        if (status == 500 || status == 404 || status == 403) {
          new UtilityService().showMessage(
            message: 'An error has occurred. Please try again',
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            context: context,
          );
        } else {
          OTPModel user = OTPModel(
            name: data['name'],
            email: data['email'],
            phone: data['phone'],
            pin: data['pin'],
          );
          print('about sending track reset to otpVerify');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpVerify(
                        otpModel: user,
                        track: 'Reset',
                      )));
        }
      }
    } catch (e) {
      print('server auth error: $e');
      new UtilityService().showMessage(
        context: context,
        message: 'An error has occurred. Please try again',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
    }
  }
}
