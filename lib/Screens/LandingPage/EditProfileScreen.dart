import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../Components/ProgressDialog.dart';
import '../../Constants/constantColors.dart';
import '../../Database/UserDB.dart';
import '../../Model/AppData.dart';
import '../../Model/UserProfileModel.dart';
import '../../Utils/NetworkUtility.dart';
import '../../Utils/Utility.dart';
import '../../Utils/paths.dart';
import '../../animation/FadeAnimation.dart';
import '../../index.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var profileNameController = TextEditingController();
  var phoneController = TextEditingController();
  // var addressController = TextEditingController();

  String? profileName;
  String? phone;
  String? address;
  UserDB userDB = UserDB();
  UserProfileModel userProfileModel = UserProfileModel();

  @override
  void initState() {
    super.initState();
    initDB();
  }

  void initDB() async {
    try {
      await userDB.initialize();
      await loadUserFromLocalStorage();
    } catch (e) {
      print("Error on init DB");
    }
  }

  Future<void> loadUserFromLocalStorage() async {
    List<UserProfileModel> list = await userDB.getAllUsers();
    if (list.isNotEmpty) {
      Provider.of<AppData>(context, listen: false).updateUserData(list.first);
      UserProfileModel? user =
          Provider.of<AppData>(context, listen: false).userData;
      if (user != null) {
        setState(() {
          userProfileModel = user;
          profileNameController.text = userProfileModel.name!;
          phoneController.text = userProfileModel.phone!;
        });
      }
    }
    print('userProfileModel after load up: $userProfileModel');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: MaterialButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          "Confirmation",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to edit your profile?",
                        style: GoogleFonts.raleway(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: 0.3,
                        ),
                      ),
                      actions: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if (profileNameController.text.isEmpty) {
                                new UtilityService().showMessage(
                                  context: context,
                                  message: 'Please enter your name',
                                  icon: const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                );
                              } else if (phoneController.text.length !=
                                  10) {
                                new UtilityService().showMessage(
                                  context: context,
                                  message:
                                  'Please enter valid phone number',
                                  icon: const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                );
                              } else {
                                UserProfileModel user = UserProfileModel(
                                  name: profileNameController.text,
                                  email: userProfileModel.email,
                                  phone: phoneController.text,
                                );

                                editProfile(user);
                              }
                            },
                            child: Text(
                              "Yes",
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 8.0, right: 8),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black
                              ),
                              onPressed: () {
                                Navigator.pop(context); //close Dialog
                              },
                              child: Text(
                                "No",
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                              )),
                        ),
                        SizedBox(width: 35,),
                      ],
                    );
                  });
            },
            height: 40,
            elevation: 0,
            splashColor: Colors.teal[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            child: Center(
              child: Text(
                "Edit",
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        )
      ],
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14, top: 20),
          child: Column(
            children: [
              Card(
                child: Container(
                  // height: 210,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 10, bottom: 40),
                    child: Column(
                      children: [
                        TextField(
                          controller: profileNameController,
                          onChanged: (value) {
                            profileName = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: LABEL_COLOR),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w300),
                            labelText: "Profile name",
                            prefixIcon: Icon(
                              Icons.person,
                              color: LABEL_COLOR,
                              size: 22,
                            ),
                            suffixIcon: Icon(
                              Icons.edit,
                              // color: Colors.black38,
                              size: 22,
                            ),
                          ),
                        ),
                        TextField(
                          controller: phoneController,
                          onChanged: (value) {
                            phone = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black54),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: LABEL_COLOR),
                            ),
                            labelStyle: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w300),
                            labelText: "Phone Number",
                            prefixIcon: Icon(
                              Icons.phone,
                              color: LABEL_COLOR,
                              size: 22,
                            ),
                            suffixIcon: Icon(
                              Icons.edit,
                              // color: Colors.black38,
                              size: 22,
                            ),
                          ),
                        ),
                        // TextField(
                        //   style: TextStyle(
                        //     color: Colors.black54,
                        //   ),
                        //   controller: addressController,
                        //   onChanged: (value) {
                        //     address = value;
                        //   },
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //     enabledBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.black54),
                        //     ),
                        //     focusedBorder: UnderlineInputBorder(
                        //       borderSide: BorderSide(color: SECOND_COLOR),
                        //     ),
                        //     labelStyle: TextStyle(
                        //         color: Colors.black54,
                        //         fontSize: 13,
                        //         letterSpacing: 0,
                        //         fontWeight: FontWeight.w300),
                        //     labelText: "Address",
                        //     prefixIcon: Icon(
                        //       Icons.home,
                        //       color: SECOND_COLOR,
                        //       size: 22,
                        //     ),
                        //     suffixIcon: Icon(
                        //       Icons.edit,
                        //       // color: Colors.black38,
                        //       size: 22,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editProfile(UserProfileModel userProfileModel) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(displayMessage: 'Please wait...');
        },
      );

      var jsonBody = jsonEncode(userProfileModel);
      NetworkUtility networkUtility = NetworkUtility();
      Response? response = await networkUtility.postDataWithAuth(
          url: EDIT_USER_URL, body: jsonBody, auth: 'Bearer $ACCESS_TOKEN');

      if (response!.statusCode != 200) {
        new UtilityService().showMessage(
          context: context,
          message: 'An error has occurred. Please try again',
          icon: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
        throw Exception(jsonDecode((response.body)));
      }
      Navigator.of(context, rootNavigator: true).pop();
      // print('edit profile response: ${response.body}');
      var result = jsonDecode(response.body);
      final user = UserProfileModel.fromJson(result['data']);
      // print('parsed user: $user');
      if (user != null) {
        userProfileModel.name = user.name;
        userProfileModel.phone = user.phone;
        userDB.updateObject(userProfileModel);

        setState(() {
          userProfileModel = user;
        });
        Provider.of<AppData>(context, listen: false).updateUserData(user);

        new UtilityService().showMessage(
          context: context,
          message: 'You have successfully updated your profile.',
          icon: Icon(
            Icons.check,
            color: Colors.teal,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Index(),
          ),
        );
      } else {
        new UtilityService().showMessage(
          context: context,
          message: 'Something went wrong. Please try again',
          icon: Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('edit profile error: $e');
    }
  }
}
