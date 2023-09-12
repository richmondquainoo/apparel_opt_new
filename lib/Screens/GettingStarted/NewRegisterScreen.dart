import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../../Components/ProgressDialog.dart';
import '../../Constants/Colors.dart';
import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../Model/OTPModel.dart';
import '../../Services/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import 'NewLoginScreen.dart';
import 'OtpVerify.dart';

class NewRegisterScreen extends StatefulWidget {
  const NewRegisterScreen({Key? key}) : super(key: key);

  @override
  State<NewRegisterScreen> createState() => _NewRegisterScreenState();
}

class _NewRegisterScreenState extends State<NewRegisterScreen> {
  var usernameController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();
  var phoneController = TextEditingController();

  String? username;
  String? email;
  String? password;
  String? phone;
  String? passwordConfirm;

  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: FIRSTBLACK,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20),
                  child: Container(
                    child: Text('Sign In',
                        style: GoogleFonts.raleway(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 130,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        "Apparel",
                        style: GoogleFonts.aBeeZee(
                          fontSize: 22,
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
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: SECONDBLACK,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(
                                0.2,
                                0.4,
                              )),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Center(
                                    child: Text(
                                      "Sign up to get access to product info!",
                                      style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 48,
                              margin: EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.0)), // set rounded corner radius
                              ),
                              child: Center(
                                child: TextField(
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.white),
                                  controller: usernameController,
                                  onChanged: (value) {
                                    username = value;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.amber, width: 0.7),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                    labelText: "Username",
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 48,
                              margin: EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.0)), // set rounded corner radius
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
                                          color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.amber, width: 0.7),
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
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 48,
                              margin: EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.0)), // set rounded corner radius
                              ),
                              child: Center(
                                child: TextField(
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.white),
                                  controller: passwordController,
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.amber, width: 0.7),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 48,
                              margin: EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    10.0)), // set rounded corner radius
                              ),
                              child: Center(
                                child: TextField(
                                  keyboardType: TextInputType.numberWithOptions(),
                                  obscureText: false,
                                  style: const TextStyle(color: Colors.white),
                                  controller: phoneController,
                                  onChanged: (value) {
                                    phone = value;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.amber, width: 0.7),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    labelText: "Phone",
                                    labelStyle: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                  checkColor: Colors.black,
                                  value: checkBoxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      checkBoxValue = value!;
                                    });
                                  },
                                  activeColor: Colors.white,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: const Text(
                                        "I have accepted the",
                                        style: TextStyle(
                                          color: Colors.white,
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
                                          color: Colors.amber,
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
                              height: 16,
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool canProceed = isValidEntries(context);
                                const CircularProgressIndicator();
                                if (canProceed) {
                                  bool canProceed = isValidEntries(context);
                                  if (canProceed) {
                                    OTPModel model = OTPModel(
                                      name: username!.trim(),
                                      email: email!.trim(),
                                      // pin: pin,
                                      phone: phone!.trim(),
                                    );
                                    new UtilityService().confirmationBox(
                                        title: 'Confirmation',
                                        message:
                                            'Are you sure you want to proceed with the registration?',
                                        context: context,
                                        yesButtonColor: Colors.teal,
                                        noButtonColor: LABEL_COLOR,
                                        // color: Colors.blueAccent,
                                        onYes: () {
                                          print("+++++++");
                                          Navigator.pop(context);
                                          checkForEmail(context: context, dataModel: model);
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
                                        color: Colors.white,
                                        offset: const Offset(0.05, 0.07),
                                        blurRadius: 1,
                                        spreadRadius: 0)
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.amber, Colors.amber],
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: GoogleFonts.raleway(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewLoginScreen()));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Sign In",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.amber),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  void checkForEmail({OTPModel? dataModel, BuildContext? context}) async {
    try {
      showDialog(
        context: context!,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );
      print("******");
      String url = '$GET_CUSTOMER_BY_EMAIL/${dataModel!.email}';
      print("URL: $url");
      NetworkUtility networkUtility = NetworkUtility();

      Response? response = await networkUtility.getDataWithAuth(
          url: url, auth: 'Bearer $ACCESS_TOKEN');
      print("RESPONSE: ${response!.body.toString()}");

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
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }

  void createOTP({OTPModel? dataModel, BuildContext? context}) async {
    try {
      showDialog(
        context: context!,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );
      var jsonBody = jsonEncode(dataModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: OTP_URL, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      print('Response Code: ${response!.statusCode}');

        // //when there is a response to handle
        // int status = response.statusCode;
        var data = jsonDecode(response.body);
      print('Response ***: ${response.statusCode}');

        int status = response.statusCode;
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
        } else if(status == 201) {


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
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }
}
