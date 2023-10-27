import 'dart:convert';

import 'package:apparel_options/Constants/myColors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../Components/ProgressDialog.dart';
import '../../Constants/Colors.dart';
import '../../Database/DBImplementation.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/OTPModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Services/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import '../CheckoutScreen.dart';
import '../LandingPage/PreLoad.dart';
import 'ForgotPasswordScreen.dart';
import 'NewRegisterScreen.dart';

class NewLoginScreen extends StatefulWidget {
  const NewLoginScreen({Key? key}) : super(key: key);

  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmController = TextEditingController();

  String? email;
  String? password;

  bool checkBoxValue = false;

  bool showPassword = true;

  String? _currentAddress= '';
  Position? _currentPosition;
  String? deliveryLocation;

  UserProfileModel userModel = UserProfileModel();
  UserDB userDB = UserDB();
  @override
  void initState() {
    _getCurrentPosition();
    initDB();

    super.initState();
    _getCurrentPosition();

  }

  void initDB() async {
    await userDB.initialize();
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    print("PERM :${hasPermission}");

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print("PERM123 :${_currentPosition}");
      _getAddressFromLatLng(_currentPosition!);

    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}';
        print("LOC312312: ${_currentAddress}");
        Provider.of<AppData>(context, listen: false)
            .updateConfirmedLocationName(
            _currentAddress.toString());

        print("THE LOCA: ${Provider.of<AppData>(context, listen: false).confirmationLocation}");
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: FIRSTBLACK,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewRegisterScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, right: 20),
                  child: Container(
                    child: Text('Sign Up',
                        style: GoogleFonts.raleway(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                )),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 94,
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    "assets/images/appLogo.png",
                  ),
                ),
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
                SizedBox(
                  height: 14,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.54,
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
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  child: Text(
                                    'Sign In',
                                    style: GoogleFonts.raleway(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 23),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "To continue, first verify that it's you.",
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
                                height: 10,
                              ),
                              const SizedBox(
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
                                height: 16,
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
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _obscured,
                                    focusNode: textFieldFocusNode,
                                    style: const TextStyle(color: Colors.white),

                                    controller: passwordController,
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 30),
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
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                        child: GestureDetector(
                                          onTap: _toggleObscured,
                                          child: Icon(
                                            _obscured
                                                ?Icons.visibility_off_rounded
                                                :Icons.visibility_rounded,
                                            size: 24,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // labelStyle:
                                      // TextStyle(color: Colors.black54, fontSize: 14),
                                      labelText: "Password",
                                      labelStyle: const TextStyle(
                                          color: Colors.white, fontSize: 14),
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
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
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
                                          "Keep me logged in",
                                          style: TextStyle(
                                            color: Colors.white,
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
                                height: 7,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool canProceed = isValidEntries(context);
                                  const CircularProgressIndicator();
                                  if (canProceed) {
                                    var connectivityResult = await (Connectivity().checkConnectivity());
                                    if (connectivityResult == ConnectivityResult.mobile ||
                                    connectivityResult == ConnectivityResult.wifi) {
                                      OTPModel model = OTPModel(
                                        email: email!.trim(),
                                        password: password!.trim(),
                                      );
                                      serverAuthentication(model);
                                    }else{
                                      showError(
                                        context,
                                        message: 'Please check your internet connection!',
                                      );
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
                                    'Sign In',
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
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.white),
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
                                      NewRegisterScreen()));
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
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
      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return ProgressDialog(displayMessage: 'Authenticating...');
      //   },
      // );
      EasyLoading.show(status: 'Authenticating...');

      var jsonBody = jsonEncode(userProfileModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: AUTH_USER_URL, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');
      print("THE URL : $AUTH_USER_URL");
      print("THE request body : $jsonBody");

      print('auth response: ${response!.body}');


      if (response == null) {
        EasyLoading.dismiss();
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
          EasyLoading.dismiss();

          await saveUserInfoLocally(userModel);
          // showOrderDetails(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreLoadScreen(),
            ),
          );
        } else {
          EasyLoading.dismiss();
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
      EasyLoading.dismiss();
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

  // Future<void> saveUserDetailsLocally(UserProfileModel user) async {
  //   try {
  //     await userDB.deleteAll();
  //     await userDB.insertObject(user);
  //     Provider.of<AppData>(context, listen: false).updateUserData(user);
  //   } catch (e) {
  //     print('saving user data to local db error: $e');
  //   }
  // }


  Future<void> saveUserInfoLocally(UserProfileModel userProfileModel) async {
    try {
      DBImplementation dbImplementation = DBImplementation();
      UserDB userDB = UserDB();
      UserProfileModel user = UserProfileModel(
        name: userProfileModel.name,
        email: userProfileModel.email,
        phone: userProfileModel.phone,
        password: userProfileModel.password,
      );

      print("The user from saveUserInfoLocally: $user");

      await userDB.initialize();
      await userDB.deleteAll();

      await dbImplementation.saveUser(user);
      Provider.of<AppData>(context, listen: false).updateUserData(user);
    } catch (e) {
      print('saving user data to local db error: $e');
    }
  }

}
