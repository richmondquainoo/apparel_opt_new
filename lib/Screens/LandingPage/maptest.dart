
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapTest extends StatefulWidget {
  const MapTest({key});

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 15,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps"),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
