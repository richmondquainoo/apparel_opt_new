import 'dart:convert';
import 'dart:math';

import 'package:apparel_options/Screens/GettingStarted/ForgotPasswordScreen.dart';
import 'package:apparel_options/Screens/GettingStarted/RegisterScreen.dart';
import 'package:apparel_options/Screens/LandingPage/PreLoad.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../Components/ProgressDialog.dart';
import '../../Components/customClipper.dart';
import '../../Constants/Colors.dart';
import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/OTPModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Services/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

  String? email;
  String? password;

  bool showPassword = true;

  UserProfileModel userModel = UserProfileModel();
  UserDB userDB = UserDB();

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
        height: height,
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
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        "assets/images/appLogo.png",
                      ),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              "Let's Sign You In.",
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "To continue, first verify that it's you.",
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
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
                          obscureText: showPassword,
                          style: const TextStyle(color: Colors.black54),
                          controller: passwordController,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
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
                            suffix: IconButton(
                                color: Colors.black,
                                onPressed: () {
                                  setState(() {
                                    if (showPassword) {
                                      showPassword = false;
                                    } else {
                                      showPassword = true;
                                    }
                                  });
                                },
                                icon: Icon(showPassword == true
                                    ? Icons.remove_red_eye
                                    : Icons.password)),
                            labelStyle:
                                TextStyle(color: Colors.black54, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()));
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.raleway(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                              letterSpacing: 0.3,
                            ),
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
                          onChanged: (bool? value) {
                            setState(() {
                              checkBoxValue = value!;
                            });
                          },
                          activeColor: Colors.black54,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                "Keep me logged in",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                                // overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool canProceed = isValidEntries(context);
                        const CircularProgressIndicator();
                        if (canProceed) {
                          OTPModel model = OTPModel(
                            email: email!.trim(),
                            password: password!.trim(),
                          );
                          serverAuthentication(model);
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
                          'Login',
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
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black54),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text(
                                "Register",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: LABEL_COLOR),
                              ),
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
    if (emailController.text.length == 0) {
      new UtilityService().showMessage(
        context: context,
        message: 'Please enter valid email',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (passwordController.text.length == 0) {
      new UtilityService().showMessage(
        context: context,
        message: 'Please enter password',
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      return false;
    } else if (passwordController.text.length < 4) {
      new UtilityService().showMessage(
        context: context,
        message: 'Invalid password',
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

  void serverAuthentication(OTPModel userProfileModel) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Authenticating...');
        },
      );

      var jsonBody = jsonEncode(userProfileModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: AUTH_USER_URL, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');
      print("THE URL : $AUTH_USER_URL");
      print("THE request body : $jsonBody");

      print('auth response: ${response!.body}');

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
        debugPrint("The statusCode: ${status}");
        debugPrint("=============================");
        String message = data['message'];

        if (status == 200 && message == 'Authentication successful') {
          userModel.name = data['data']['name'];
          userModel.email = data['data']['email'];
          userModel.phone = data['data']['phone'];
          userModel.password = passwordController.text;
          print("The user model at the login auth: ${userModel}");

          await saveUserDetailsLocally(userModel);
          // showOrderDetails(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreLoadScreen(),
            ),
          );
        } else {
          new UtilityService().showMessage(
            context: context,
            message: data['message'],
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      new UtilityService().showMessage(
        context: context,
        message: "Invalid username or password",
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      );
      print('server auth error: $e');
    }
  }

  Future<void> saveUserDetailsLocally(UserProfileModel user) async {
    try {
      await userDB.deleteAll();
      await userDB.insertObject(user);
      Provider.of<AppData>(context, listen: false).updateUserData(user);
    } catch (e) {
      print('saving user data to local db error: $e');
    }
  }
}
