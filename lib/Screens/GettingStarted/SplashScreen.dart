import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:apparel_options/Screens/GettingStarted/GettingStartedScreen.dart';
import 'package:apparel_options/Screens/LandingPage/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../Database/UserDB.dart';
import '../../Index.dart';
import '../../Model/AppData.dart';
import '../../Model/UserModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Services/services/location_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  LocationService locationservice = LocationService();

  String? _currentAddress= '';
  Position? _currentPosition;
  LatLng? initialPosition;

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

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);

    }).catchError((e) {
      // debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        print("THE LOCATION: ${_currentAddress}");
        initialPosition = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        print("THE INITIAL POSITION: $initialPosition");
        _currentAddress = '${place.street}, ${place.subLocality}';

        Provider.of<AppData>(context, listen: false)
            .updateConfirmedLocationName(
            _currentAddress.toString());
        print("THE LOCATION FROM SPLASH: ${Provider.of<AppData>(context, listen: false).locationName}");
      });
      print("LOC: ${_currentAddress}");
    }).catchError((e) {
      // debugPrint(e);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    locationservice = LocationService();

    Timer(Duration(seconds: 5), () async {
      UserDB userDB = UserDB();
      await userDB.initialize();
      List<UserProfileModel> users = await userDB.getAllUsers();
      print("User List: ${users}");

      //if user exists, go to select branch page
      if (users.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Index(),
          ),
        );
      }
      //if no user exists, go to select login page
      else if(users.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GettingStartedScreen(),
          ),
        );
      }
    });
  }

  final spinkit = SpinKitCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.white54 : Colors.amber,
        ),
      );
    },
  );

  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: kBackgroundTheme,
    //   body: AnimatedSplashScreen(
    //     splash: Container(
    //       height: 250,
    //       width: 250,
    //       child: Image.asset(
    //         "assets/images/appLogo.png",
    //       ),
    //     ),
    //     splashTransition: SplashTransition.decoratedBoxTransition,
    //     duration: 4000,
    //     nextScreen: GettingStartedScreen(),
    //   ),
    // );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 100,
                    child: Image.asset("assets/images/appLogo.png",),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    spinkit,
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    Text(
                      "Powered by DataRun \u00a9 ",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600, fontSize: 13.0, color: Colors.white),
                    )
                    // Text(
                    //   "Version 1.0.0",
                    //   softWrap: true,
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.raleway(
                    //       fontWeight: FontWeight.w300,
                    //       fontSize: 13.0,
                    //       color: kPrimaryTextColor,
                    //       letterSpacing: 0.8),
                    // )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

