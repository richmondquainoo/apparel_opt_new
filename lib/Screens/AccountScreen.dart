import 'package:apparel_options/Database/UserDB.dart';
import 'package:apparel_options/Model/UserProfileModel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/settingCardComponent.dart';
import '../Constants/constantColors.dart';
import '../Constants/myColors.dart';
import 'LandingPage/AboutScreen.dart';
import 'LandingPage/EditProfileScreen.dart';
import 'LandingPage/FavoritesScreen.dart';
import 'LandingPage/OrderScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  void cleanUp() async {
    try {
      //clear user db
      await userDB.deleteAll();

      //clear shared prefs

    } catch (e) {
      print("Error on clean on logout");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundTheme,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0.2,
        automaticallyImplyLeading: false,
        title: Text(
          "Account",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w400,
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
                                          ? userProfileModel.name
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
            AccountMenu(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(
                      showBackButton: true,
                    ),
                  ),
                );
              },
              menu: "My Orders",
              iconImage: Icons.card_giftcard_outlined,
            ),
            // AccountMenu(
            //     onTap: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => PaymentScreen()));
            //     },
            //     menu: "Payment History",
            //     iconImage: Icons.payment),
            AccountMenu(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(),
                  ),
                );
              },
              menu: "Favorites",
              iconImage: Icons.favorite_border,
            ),
            // AccountMenu(
            //   onTap: () {
            //     // File file = await fromAsset('assets/Policy.pdf', 'Policy.pdf');
            //     // fromAsset('assets/Policy.pdf', 'Policy.pdf').then((f) {
            //     //   setState(() {
            //     //     path = f.path;
            //     //   });
            //     // });
            //     // print('file: $file | ${file.path}');
            //     // if (file != null) {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => TermsAndConditionsScreen(
            //           path:
            //               '/data/user/0/com.casantey.potbelly/app_flutter/terms.pdf',
            //         ),
            //       ),
            //     );
            //   },
            //   menu: "Terms & Conditions",
            //   iconImage: Icons.bookmark_border_outlined,
            // ),
            AccountMenu(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutScreen()));
              },
              menu: "About App",
              iconImage: Icons.info_rounded,
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
                                  child: FlatButton(
                                    height: 34,
                                    color: Colors.teal.shade400,
                                    onPressed: () async {
                                      Navigator.pop(context); //close Dialog
                                      await cleanUp();
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8),
                                  child: FlatButton(
                                      height: 34,
                                      color: LABEL_COLOR,
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
                                )
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
    );
  }
}

class AccountMenu extends StatelessWidget {
  final String menu;
  final Function onTap;
  final IconData iconImage;
  final Color iconColor;
  const AccountMenu(
      {Key key, this.menu, this.onTap, this.iconImage, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                        menu,
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: onTap,
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
