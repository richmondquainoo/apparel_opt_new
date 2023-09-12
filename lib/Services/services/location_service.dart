import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  late LocationSettings locationSettings;

  Stream<Position> get locationStream => _locationController.stream;

  StreamController<Position> _locationController = StreamController<Position>();

  getDistanceFromGeolocator(double startLat, double startLong, double endLat, double endLong) {
    var distance =
        Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
    return distance;
  }

  LocationService() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
    requestLocationPermission().then((_) {
      print('location service created after permission was successful');
    }).catchError((err) {
      print("location permission request failed $err");
    }); //ok run
    //run the code
    //I R
    //Please is left with the orders list is still INstance of ordermodel
    //yh, its supposed to show that way
    // Geolocator.getPositionStream(locationSettings: locationSettings)
    //     .listen((Position? position) {
    //   print(position == null
    //       ? 'Unknown'
    //       : '${position.longitude}, ${position.longitude.toString()}');
    //   if (position != null) {
    //     _locationController.sink.add(position);
    //   }
    // });
  }

  Future requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location is denied');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied,we cannot request permissions.');
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      //  Geolocator.getCurrentPosition(forceAndroidLocationManager: true,
      // desiredAccuracy: LocationAccuracy.lowest);
      Position pos = await Geolocator.getCurrentPosition();
      print('current location hurry $pos');

      return pos;
    } catch (e) {
      print('something went wrong here, retry the get current pos');
      throw (e);
    }
  }

  Future<List<Placemark>> getPlacemarkFromCoord(
      double latitude, double longitude) async {
    var res = await placemarkFromCoordinates(latitude, longitude);
    print("GET COORD");
    return res;
  }
}
