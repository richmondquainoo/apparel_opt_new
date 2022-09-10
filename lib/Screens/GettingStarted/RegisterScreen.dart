import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Components/ProgressDialog.dart';
import '../../Components/customClipper.dart';
import '../../Constants/Colors.dart';
import '../../Constants/myColors.dart';
import '../../Model/OTPModel.dart';
import '../../Services/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import 'LoginScreen.dart';
import 'OtpVerify.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var usernameController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  var phoneController = TextEditingController();

  String username;
  String email;
  String password;
  String phone;
  String passwordConfirm;

  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
          size: 28,
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20),
                child: Container(
                  child: Text('Skip',
                      style: GoogleFonts.raleway(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                ),
              )),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Container(
                  child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [
                          DEEP_YELLOW,
                          Colors.white24.withOpacity(1),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "Apparel",
                              style: GoogleFonts.aBeeZee(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: DEEP_YELLOW,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "Options",
                              style: GoogleFonts.raleway(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Container(
                      child: Text(
                        "Sign up to get access to product info!",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black38),
                      ),
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.all(5),
                      padding: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // set rounded corner radius
                      ),
                      child: Center(
                        child: TextField(
                          obscureText: false,
                          style: const TextStyle(color: Colors.black54),
                          controller: usernameController,
                          onChanged: (value) {
                            username = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 0.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 0.7),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.black54,
                            ),
                            labelText: "Username",
                            labelStyle: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // set rounded corner radius
                      ),
                      child: Center(
                        child: TextField(
                          obscureText: false,
                          style: const TextStyle(color: Colors.black54),
                          controller: emailController,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 0.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 0.7),
                            ),
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: Colors.black54,
                            ),
                            labelText: "Email",
                            labelStyle: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // set rounded corner radius
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
                                  color: Colors.black54, width: 0.7),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.black54, width: 0.7),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.black54,
                            ),
                            labelText: "Password",
                            labelStyle:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 48,
                      margin: EdgeInsets.all(5),
                      padding: const EdgeInsets.only(left: 5),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // set rounded corner radius
                      ),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black54),
                          controller: phoneController,
                          onChanged: (value) {
                            phone = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Colors.black87, width: 0.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: primaryColor, width: 0.7),
                            ),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.black54,
                            ),
                            labelText: "Mobile Number",
                            labelStyle: const TextStyle(
                                color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          // checkColor:Colors.blueAccent,
                          value: checkBoxValue,
                          onChanged: (bool value) {
                            setState(() {
                              checkBoxValue = value;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                "I have accepted the",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                                // overflow: TextOverflow.fade,
                              ),
                            ),
                            Container(
                              child: const Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                // overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        bool canProceed = isValidEntries(context);
                        const CircularProgressIndicator();
                        if (canProceed) {
                          bool canProceed = isValidEntries(context);
                          if (canProceed) {
                            OTPModel model = OTPModel(
                              name: username.trim(),
                              email: email.trim(),
                              // pin: pin,
                              phone: phone.trim(),
                            );
                            new UtilityService().confirmationBox(
                                title: 'Confirmation',
                                message:
                                    'Are you sure you want to proceed with the registration?',
                                context: context,
                                yesButtonColor: kCardBackGround,
                                noButtonColor: kCardBackGround,
                                // color: Colors.blueAccent,
                                onYes: () {
                                  Navigator.pop(context);
                                  checkForEmail(
                                      context: context, dataModel: model);
                                },
                                onNo: () {
                                  Navigator.pop(context);
                                });
                          }
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: const Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              PRIMARY_BLACK,
                              PRIMARY_BLACK,
                            ],
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have an account?",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black54),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Login",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEntries(BuildContext context) {
    if (usernameController.text.length == 0) {
      UtilityService().showMessage(
        context: context,
        message: 'Please enter username',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (emailController.text.length == 0 ||
        !emailController.text.contains("@") ||
        !emailController.text.contains(".")) {
      UtilityService().showMessage(
        context: context,
        message: 'Please enter valid email',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (passwordController.text.isEmpty) {
      UtilityService().showMessage(
        context: context,
        message: 'Please enter password',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (passwordController.text.length < 5) {
      UtilityService().showMessage(
        context: context,
        message: 'Invalid length of password',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (phoneController.text.length < 5) {
      UtilityService().showMessage(
        context: context,
        message: 'Invalid length of phone',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (checkBoxValue == false) {
      UtilityService().showMessage(
        context: context,
        message: 'You need to accept terms to proceed',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  void checkForEmail({OTPModel dataModel, BuildContext context}) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );
      String url = '$GET_CUSTOMER_BY_EMAIL/${dataModel.email}';
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.getDataWithAuth(
          url: url, auth: 'Bearer $ACCESS_TOKEN');

      int status = response.statusCode;
      Navigator.of(context, rootNavigator: true).pop();
      if (status == 404) {
        createOTP(context: context, dataModel: dataModel);
      } else if (status == 200) {
        new UtilityService().showMessage(
          context: context,
          message: 'A user with this account already exists.',
          icon: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('postUserData error: $e');
      new UtilityService().showMessage(
        context: context,
        message: 'An error has occurred. Please try again',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void createOTP({OTPModel dataModel, BuildContext context}) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );
      var jsonBody = jsonEncode(dataModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response response = await networkUtility.postDataWithAuth(
          url: OTP_URL, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      print('Response: ${response.body}');

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
        // //when there is a response to handle
        // int status = response.statusCode;
        var data = jsonDecode(response.body);

        int status = data['status'];
        print('Status: $status');
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
          print('Body: ${response.body}');
          OTPModel otpModel = new OTPModel(
            name: data['name'],
            email: data['email'],
            pin: data['pin'],
            phone: data['phone'],
            password: passwordController.text.trim(),
          );
          print(
              'data to next screen: $otpModel | pass: ${passwordController.text}');
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerify(
                otpModel: otpModel,
                track: 'Registration',
                password: passwordController.text.trim(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('postUserData error: $e');
      new UtilityService().showMessage(
        context: context,
        message: 'An error has occurred. Please try again',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
