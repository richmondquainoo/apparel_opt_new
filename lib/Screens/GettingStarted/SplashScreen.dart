import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:apparel_options/Screens/GettingStarted/GettingStartedScreen.dart';
import 'package:flutter/material.dart';

import '../../Constants/myColors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundTheme,
      body: AnimatedSplashScreen(
        splash: Container(
          height: 250,
          width: 250,
          child: Image.asset(
            "assets/images/appLogo.png",
          ),
        ),
        splashTransition: SplashTransition.decoratedBoxTransition,
        duration: 4000,
        nextScreen: GettingStartedScreen(),
      ),
    );
  }
}
