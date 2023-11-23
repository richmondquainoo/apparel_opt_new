import 'package:apparel_options/Screens/LandingPage/NotificationScreen.dart';
import 'package:apparel_options/Screens/LandingPage/OrderScreen.dart';
import 'package:apparel_options/Screens/home/home_screen.dart';
import 'package:apparel_options/api/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'Model/AppData.dart';
import 'Screens/GettingStarted/SplashScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:apparel_options/firebase_options.dart';

import 'Screens/LandingPage/explore.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        title: 'Apparel Options',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        builder: EasyLoading.init(),
        navigatorKey: navigatorKey,
        routes: {
          OrderScreen.route:(context) => const OrderScreen(),
          NotificationScreen.route:(context) => const NotificationScreen(),
          ExplorePage.route:(context) => const ExplorePage()
        },
      ),
    );
  }
}
