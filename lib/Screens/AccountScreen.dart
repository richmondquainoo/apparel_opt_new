import 'package:apparel_options/Database/UserDB.dart';
import 'package:apparel_options/Model/UserProfileModel.dart';
import 'package:apparel_options/Screens/GettingStarted/GettingStartedScreen.dart';
import 'package:apparel_options/Screens/GettingStarted/NewLoginScreen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/ProgressDialog.dart';
import '../Components/settingCardComponent.dart';
import '../Constants/constantColors.dart';
import '../Constants/myColors.dart';
import '../Database/MenuDB.dart';
import '../Database/ProductDetailsDB.dart';
import '../Database/ProductSpecificationDB.dart';
import '../Database/ProductVariantDB.dart';
import '../Model/ProductVariantModel.dart';
import 'LandingPage/AboutScreen.dart';
import 'LandingPage/EditProfileScreen.dart';
import 'LandingPage/FavoritesScreen.dart';
import 'LandingPage/OrderScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserDB userDB = UserDB();
  UserProfileModel userProfileModel = UserProfileModel();
  MenuDB? menuDB = MenuDB();
  ProductVariantModel? productVariantModel = ProductVariantModel();
  ProductVariantDB? productVariantDB = ProductVariantDB();
  ProductSpecificationDB? productSpecificationDB = ProductSpecificationDB();
  ProductDetailsDB? productDetailsDB = ProductDetailsDB();

  @override
  void initState() {
    super.initState();
    initDB();
  }

  void initDB() async {
    try {
      await userDB.initialize();
      await loadUserFromLocalStorage();
      await menuDB!.initialize();
      await productVariantDB!.initialize();
      await productSpecificationDB!.initialize();
      await productDetailsDB!.initialize();
    } catch (e) {
      print("Error on init DB");
    }
  }

  Future<void> loadUserFromLocalStorage() async {
    List<UserProfileModel> users = await userDB.getAllUsers();
    if (users.isNotEmpty) {
      setState(() {
        userProfileModel = users.first;
      });
    }
    print('userProfileModel after load up: $userProfileModel');
  }
  Future<bool> showExitPopUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Leaving Application",
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            content: Text(
              "Are you sure you want to logout?",
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
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      cleanUp();
                      SystemNavigator.pop();
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryTheme,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
              )
            ],
          );
        });
    return false;
  }

  void cleanUp() async {
    try {
      await userDB.deleteAll();
      await menuDB!.deleteAll();
      await productVariantDB!.deleteAll();
      await productSpecificationDB!.deleteAll();
      await productDetailsDB!.deleteAll();


    } catch (e) {
      print("Error on clean up logout");
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBackgroundTheme,
        persistentFooterButtons: [
          Center(
            child: Text(
              "Version 1.0.2",
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: Colors.black54,
                letterSpacing: .75,
              ),
            ),
          ),
        ],
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          elevation: 0.2,
          automaticallyImplyLeading: false,
          title: Text(
            "Account",
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
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 19,
              color: Colors.black54,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 143,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AvatarGlow(
                                endRadius: 35,
                                glowColor: LABEL_COLOR,
                                child: Container(
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white12,
                                    maxRadius: 23.5,
                                    backgroundImage: AssetImage(
                                        "assets/images/personIcon.png"),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                        (userProfileModel != null &&
                                                userProfileModel.name != null)
                                            ? userProfileModel.name!
                                            : "-",
                                        style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    child: Text(
                                        userProfileModel.email.toString() ?? "-",
                                        style: GoogleFonts.raleway(
                                            fontSize: 13,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text('Phone',
                                          style: GoogleFonts.raleway(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      child: Text(
                                          userProfileModel.phone.toString() ??
                                              "-",
                                          style: GoogleFonts.lato(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 27,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Edit",
                                        style: GoogleFonts.raleway(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14, bottom: 10),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(children: [
                    SettingCardComponent(
                      title: "My Orders",
                      leadingIcon: Icons.card_giftcard_outlined,
                      bgIconColor: Colors.amber,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderScreen(
                              showBackButton: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14,bottom: 10),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(children: [
                    SettingCardComponent(
                      title: "Favorites",
                      leadingIcon: Icons.favorite_border,
                      bgIconColor: Colors.amber,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14,bottom: 10),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(children: [
                    SettingCardComponent(
                      title: "Privacy Policy",
                      leadingIcon: Icons.shield,
                      bgIconColor: Colors.amber,
                      onTap: () {

                      },
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14,bottom: 10),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(children: [
                    SettingCardComponent(
                      title: "About App",
                      leadingIcon: Icons.info_rounded,
                      bgIconColor: Colors.amber,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AboutScreen()));
                      },
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(children: [
                    SettingCardComponent(
                      title: "Log Out",
                      leadingIcon: Icons.logout_outlined,
                      bgIconColor: Colors.redAccent,
                      onTap: () {
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
                                  "Are you sure you want to logout?",
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
                                    child: SizedBox(
                                      height: 34,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ProgressDialog(displayMessage: 'Logging out...');
                                            },
                                          );
                                          //close Dialog
                                          cleanUp();
                                          print("CLEAN UP COMPLETE!!!!!!!!!!!!!!");
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NewLoginScreen()));
                                          // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                                    child: SizedBox(
                                      height: 34,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryTheme,
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
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountMenu extends StatelessWidget {
  final String? menu;
  final Function? onTap;
  final IconData? iconImage;
  final Color? iconColor;
  const AccountMenu(
      {Key? key, this.menu, this.onTap, this.iconImage, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Container(
                      child: Icon(
                        iconImage,
                        color: iconColor ?? Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        menu!,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        onTap;
                      },
                      icon: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.black54)),
                ],
              ),
            ),
            const Divider(
              color: Colors.black54,
              thickness: 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
