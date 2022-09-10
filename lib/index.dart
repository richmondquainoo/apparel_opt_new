import 'package:apparel_options/Constants/Colors.dart';
import 'package:apparel_options/Screens/LandingPage/explore.dart';
import 'package:flutter/material.dart';

import 'Constants/constantColors.dart';
import 'Model/UserModel.dart';
import 'Screens/CategoryScreen.dart';
import 'Screens/LandingPage/NotificationScreen.dart';
import 'Screens/LandingPage/OrderScreen.dart';
import 'Utils/Utility.dart';
import 'components/ProgressDialog.dart';

class Index extends StatefulWidget {
  final UserModel userModel;
  const Index({Key key, this.userModel}) : super(key: key);

  @override
  _IndexState createState() => _IndexState(userModel: userModel);
}

class _IndexState extends State<Index> {
  final UserModel userModel;
  int _selectedIndex = 0;

  _IndexState({this.userModel});

  Future<bool> showExitPopUp() async {
    new UtilityService().confirmationBox(
      title: 'Quit Application',
      message: 'Are you sure you want to exit application?',
      context: context,
      yesButtonColor: Colors.teal,
      noButtonColor: Colors.red,
      onYes: () async {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return ProgressDialog(
              displayMessage: 'Exiting application...',
            );
          },
        );

        return true;
      },
      onNo: () {
        Navigator.pop(context);
        return false;
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopUp,
      child: Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(),
        backgroundColor: NAVBAR_BACKGROUND_COLOR,
        body: navigator(_selectedIndex),
      ),
    );
  }

  Widget navigator(int index) {
    // Provider.of<AppData>(context, listen: false).updateUserData(customer);
    if (index == 0) {
      return ExplorePage(
      );
    } else if (index == 1) {
      return const CategoryScreen();
    } else if (index == 2) {
      return OrderScreen(
        showBackButton: false,
      );
    } else if (index == 3) {
      return NotificationScreen();
    }
    // else if (index == 3) {
    //   return const LitigationScreen();
    // }
    else {
      return null;
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: NAVBAR_BACKGROUND_COLOR,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.black54,
      selectedFontSize: 13,
      unselectedFontSize: 9,
      iconSize: 30,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 22,
            color: kPrimaryTextColor,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.widgets_rounded,
            size: 22,
            color: kPrimaryTextColor,
          ),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.card_giftcard,
            size: 22,
            color: kPrimaryTextColor,
          ),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications_active,
            size: 22,
            color: kPrimaryTextColor,
          ),
          label: 'Notification',
        ),
      ],
    );
  }
}
