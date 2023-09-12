import 'dart:convert';

import 'package:apparel_options/Screens/LandingPage/PreLoad.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../Components/ProgressDialog.dart';
import '../../Components/TextButtonComponent.dart';
import '../../Database/DBImplementation.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/OTPModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import 'LoginScreen.dart';
import 'NewRegisterScreen.dart';
import 'PasswordResetScreen.dart';

class OtpVerify extends StatefulWidget {
  final OTPModel? otpModel;
  final String? track;
  final String? password;
  const OtpVerify({Key? key, this.otpModel, this.track, this.password})
      : super(key: key);

  @override
  State<OtpVerify> createState() =>
      _OtpVerifyState(otpModel: otpModel!, password: password!, track: track!);
}

class _OtpVerifyState extends State<OtpVerify> {
  final String? track;
  final OTPModel? otpModel;
  final String? password;
  String? globalPin;
  String? caption =
      'Enter the verification code we just sent to your email address.';

  @override
  void initState() {
    super.initState();
    print('value of track on init is ${widget.track}');
    if (otpModel != null && otpModel!.email != null) {
      caption =
          'Enter the verification code we just sent to your email address '
          '${otpModel!.email!.substring(0, 1)}'
          '***${otpModel!.email!.substring(otpModel!.email!.length - 3)}';
    }
  }

  _OtpVerifyState({this.track, this.otpModel, this.password});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewRegisterScreen()));
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
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Verification',
                        style: GoogleFonts.raleway(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        )),
                  ),
                ),
                Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/OtpImage.jpg'),
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Enter the verification code we',
                      style: GoogleFonts.raleway(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'just sent to your phone number',
                      style: GoogleFonts.raleway(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 50,
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        print("Completed: " + pin);
                        setState(() {
                          globalPin = (pin);
                          print("globalPin: $globalPin");
                        });
                        handleVerification(context);
                        // verifyOTP(context: context, dataModel: otpModel);
                      },
                      obscureText: false,
                      onChanged: (pin) {
                        globalPin = (pin);
                        print("globalPin: $globalPin");
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "If you didn't receive a code.",
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        // OTPModel model = OTPModel(
                        //     name: widget.otpModel.name,
                        //     email: widget.otpModel.email,
                        //     // pin: pin,
                        //     phone: widget.otpModel.phone,
                        //     password: widget.password);
                        createOTP(context: context, dataModel: otpModel!);
                        print('resend');
                        // print("Model: $model");
                      },
                      child: Container(
                        child: Text(
                          'Resend',
                          style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: TextButtonComponent(
                      labelColor: Colors.black,
                      label: 'Verify',
                      onTap: () {
                        handleVerification(context);
                        // verifyOTP(context: context, dataModel: otpModel);
                        // verifyByEmail(context: context, dataModel: otpModel);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidInput(BuildContext context) {
    if (globalPin == null) {
      UtilityService().showMessage(
          message: 'Please enter pin',
          context: context,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
      return false;
    } else if (globalPin != otpModel!.pin.toString()) {
      new UtilityService().showMessage(
          message: 'Invalid pin',
          context: context,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
      return false;
    } else {
      return true;
    }
  }

  void createOTP({OTPModel? dataModel, BuildContext? context}) async {
    try {
      showDialog(
        context: context!,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Resending OTP...');
        },
      );
      var jsonBody = jsonEncode(dataModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: OTP_URL, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      print('Response: ${response!.body}');

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
            password: widget.password!,
          );
          print('data to next screen: $otpModel');
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerify(
                otpModel: otpModel,
                track: 'Registration',
                password: widget.password,
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
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }

  void registerUser({OTPModel? otpModel, BuildContext? context}) async {
    showDialog(
      context: context!,
      builder: (context) {
        return ProgressDialog(displayMessage: 'Please wait...');
      },
    );
    print(otpModel);
    var jsonBody = jsonEncode(otpModel);
    NetworkUtility networkUtility = NetworkUtility();
    Response? response = await networkUtility.postDataWithAuth(
        url: CREATE_USER, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

    var data = jsonDecode(response!.body);
    print("Response: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    int status = data['status'];
    print('reg body: $data');
    // Handle network error
    if (status == 500 || status == 404 || status == 403) {
      new UtilityService().showMessage(
        message:
            'An error has occurred whiles creating account. Please try again',
        icon: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        context: context,
      );
    } else if (status == -333) {
      Navigator.of(context, rootNavigator: true).pop();
      new UtilityService().notificationMessageWithButton(
          title: "Retry",
          message:
              "Account already exist with this email. Please login to proceed.",
          context: context,
          backgroundColor: Colors.white,
          color: Colors.blue,
          buttonText: "Login",
          textColor: Colors.red,
          proceed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
            // Navigator.of(context,rootNavigator: true).pop();
          });
    } else if (status == 201) {
      //account created
      //save the data to local storage
      saveUserInfoLocally(otpModel!);
      //navigate to home
      UserProfileModel user = UserProfileModel(
        name: otpModel.name,
        email: otpModel.email,
        phone: otpModel.phone,
        password: otpModel.password,
      );
      // print("user: $otpModel");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PreLoadScreen()));
      new UtilityService().showMessage(
        context: context,
        message: 'Your registration is successful',
        icon: Icon(
          Icons.check_circle,
          color: Colors.lightGreenAccent,
        ),
      );
    } else {
      // goToSetPin(context, otpModel);
    }
  }

  void verifyOTP({OTPModel? dataModel, BuildContext? context}) async {
    try {
      showDialog(
        context: context!,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );
      dataModel!.pin = int.parse(globalPin!);
      var jsonBody = jsonEncode(dataModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: OTP_VERIFICATION, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      // print('otp verification url: $OTP_VERIFICATION');
      // print('otp verification req: $jsonBody');
      var data = jsonDecode(response!.body);
      print('otp verification response: ${data}');

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
        if (data['verificationStatus']) {
          // verification is successful
          // print('Body: ${response.body}');
          OTPModel otpModel = new OTPModel(
              name: widget.otpModel!.name,
              password: widget.password!,
              email: widget.otpModel!.email,
              phone: widget.otpModel!.phone,
              pin: widget.otpModel!.pin);

          // print('Data after verification: $otpModel | password: ${widget.password}');
          Navigator.of(context, rootNavigator: true).pop();

          //Create user account
          registerUser(otpModel: otpModel, context: context);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          new UtilityService().showMessage(
            message: data['message'],
            icon: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            context: context,
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
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }

  void handleVerification(BuildContext context) {
    bool canProceed = isValidInput(context);
    //  Validate input fields
    if (canProceed) {
      // print("handleVerification called");
      // print(widget.track);
      if (widget.track == 'Registration') {
        // print('handleVerification called with data: $otpModel');
        verifyOTP(dataModel: widget.otpModel, context: context);
      }
      if (widget.track == 'Reset') {
        verifyByEmail(context: context, dataModel: widget.otpModel!);
      }
    }
    // else {
    //   createOTP();
    // }
  }

  void saveUserInfoLocally(OTPModel otpModel) async {
    try {
      DBImplementation dbImplementation = DBImplementation();
      UserDB userDB = UserDB();
      UserProfileModel user = UserProfileModel(
        name: otpModel.name,
        email: otpModel.email,
        phone: otpModel.phone,
        password: otpModel.password,
      );

      await userDB.initialize();
      await userDB.deleteAll();

      await dbImplementation.saveUser(user);
      Provider.of<AppData>(context, listen: false).updateUserData(user);
    } catch (e) {
      print('saving user data to local db error: $e');
    }
  }

  void verifyByEmail({OTPModel? dataModel, BuildContext? context}) async {
    try {
      showDialog(
        context: context!,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );
      dataModel!.pin = int.parse(globalPin!);
      var jsonBody = jsonEncode(dataModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: OTP_VERIFY_BY_EMAIL,
          body: jsonBody,
          auth: 'Bearer $ACCESS_TOKEN');

      // print("Verify By email: ${OTP_VERIFY_BY_EMAIL}");
      print('otp verification by email response: ${response!.body}');

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

        if (data['message'] == 'Valid OTP' &&
            data['verificationStatus'] == true) {
          // verification is successful
          print('Body: ${response.body}');
          OTPModel otpModel = new OTPModel(
              name: widget.otpModel!.name,
              password: widget.password!,
              email: widget.otpModel!.email,
              phone: widget.otpModel!.phone,
              pin: widget.otpModel!.pin);
          Navigator.of(context, rootNavigator: true).pop();
          goToSetPin(context, otpModel);
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          new UtilityService().showMessage(
            message: data['message'],
            icon: Icon(
              Icons.error_outline,
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

  void goToSetPin(BuildContext context, OTPModel otpModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordResetScreen(
          otpModel: otpModel,
        ),
      ),
    );
  }

// void registerUser({OTPModel otpModel, BuildContext context}) async {
//   try {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ProgressDialog(displayMessage: 'Please wait...');
//       },
//     );
//     debugPrint("Print here");
//     debugPrint("$otpModel");
//     var jsonBody = jsonEncode(otpModel);
//     NetworkUtility networkUtility = NetworkUtility();
//     Response response = await networkUtility.postDataWithAuth(
//         url: OTP_VERIFICATION, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');
//     // debugPrint(response.body);
//
//     Navigator.of(context, rootNavigator: true).pop();
//     UtilityService().showMessage(
//       context: context,
//       message: 'Your registration was successful',
//       icon: const Icon(
//         Icons.check_circle_rounded,
//         color: Colors.lightGreenAccent,
//       ),
//     );
//     // Navigator.push(context,
//     //     MaterialPageRoute(builder: (context) => Index(userModel: otpModel)));
//   } catch (e) {
//     print('postUserData error: $e');
//     UtilityService().showMessage(
//       context: context,
//       message: 'An error has occurred. Please try again',
//       icon: const Icon(
//         Icons.error_outline,
//         color: Colors.red,
//       ),
//     );
//     Navigator.of(context, rootNavigator: true).pop();
//   }
// }
}
