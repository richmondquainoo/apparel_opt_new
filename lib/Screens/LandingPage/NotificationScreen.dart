

import 'package:apparel_options/Constants/constantColors.dart';
import 'package:apparel_options/push_notifications/push_notification_system.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/myColors.dart';

class NotificationScreen extends StatefulWidget {
  final bool? showBackButton;
  const NotificationScreen({
    Key? key,
    this.showBackButton,
  }) : super(key: key);
  static const route = '/notification-screen';

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState(showBackButton: showBackButton);
}

class _NotificationScreenState extends State<NotificationScreen> {
  final bool? showBackButton;
  _NotificationScreenState({this.showBackButton});


  String? _currentAddress;
  Position? _currentPosition;
  bool? notifIsPresent;



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
    print("PERMISSION: ${hasPermission}");
    if (hasPermission==true) {
      print("PERMISSION:AFTER");

       Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
        print("LOC ${_currentPosition!.longitude}");
        _getAddressFromLatLng(_currentPosition!);
      });
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print("LOC ${_currentPosition!.longitude}");
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

        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        print("PPPPPP: ${_currentPosition?.longitude}");
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    print("HEYYY");
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    // PushNotificationSystem;
    if(message.data.isEmpty){
      notifIsPresent = true;
    }else{
      notifIsPresent = false;
    }
    print("THE MESSAGE NOTIF: ${message}");

    return Scaffold(

      appBar: AppBar(
        leading: (showBackButton != null && showBackButton!)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 19,
                  color: Colors.black54,
                ),
              )
            : Container(),
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text('${message.notification!.title}'),
              // Text('${message.notification!.body}'),
              // Text('${message.data}'),
              Container(
                child: notifIsPresent == true
                ?Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      // height: 130,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                borderRadius:BorderRadius.circular(2)
                              ),
                              child: Icon(
                                Icons.notification_add_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14,left: 6,bottom:16,right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${message.notification!.title}",
                                  style: GoogleFonts.raleway(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  "${message.notification!.body}",
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ),
                  ),
                )
                :  Padding(
                  padding:
                  const EdgeInsets.only(bottom: 2, top: 2, right: 5, left: 5),
                  child: Center(
                    child: Text(
                      "There are no notifications",
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),

            ]),
      ),
    );
  }
}
