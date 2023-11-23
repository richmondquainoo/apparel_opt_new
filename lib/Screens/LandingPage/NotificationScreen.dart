import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

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
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${message.notification!.title}'),
              Text('${message.notification!.body}'),
              Text('${message.data}'),
              // Padding(
              //   padding:
              //       const EdgeInsets.only(bottom: 2, top: 2, right: 5, left: 5),
              //   child: Center(
              //     child: Text(
              //       "There are no notifications",
              //       style: GoogleFonts.raleway(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w400,
              //         color: Colors.black,
              //         letterSpacing: 0.3,
              //       ),
              //       overflow: TextOverflow.ellipsis,
              //       maxLines: 1,
              //     ),
              //   ),
              // ),
            ]),
      ),
    );
  }
}
